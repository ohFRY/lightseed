import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lightseed/main.dart';
import 'package:lightseed/src/models/affirmation.dart';
import 'package:lightseed/src/services/affirmations_service.dart';
import 'package:lightseed/src/logic/timeline_state.dart';
import 'package:lightseed/src/services/network/network_status_service.dart';
import 'package:provider/provider.dart';
import '../models/timeline_item.dart';
import '../models/emotion.dart';
import '../services/emotions_service.dart';
import 'account_state_screen.dart';

class TodayPageState extends ChangeNotifier {
  final AffirmationsService _affirmationsService = AffirmationsService();
  final EmotionsService _emotionsService = EmotionsService();
  final AccountState accountState;
  List<Affirmation> affirmations = [];
  List<Emotion> todayEmotions = [];
  Affirmation currentAffirmation = Affirmation(content: '', id: 0);
  Timer? _timer;
  bool _hasError = false;
  bool _isLoading = false;
  bool _emotionsLoaded = false; // Track if emotions were loaded
  bool _isEmotionsLoading = false; // Track active loading to prevent duplicates
  bool _isDisposed = false;
  StreamSubscription? _networkSubscription;

  bool get hasError => _hasError;
  bool get isLoading => _isLoading;
  bool get emotionsLoaded => _emotionsLoaded;

  set emotionsLoaded(bool value) {
    _emotionsLoaded = value;
    debugPrint('Emotion loaded status set to: $value');
  }

  TodayPageState(this.accountState) {
    _initializeAffirmations();
    _startPeriodicUpdate();
    _listenForConnectivityChanges();
  }

  Future<void> _initializeAffirmations() async {
    _isLoading = true;
    notifyListeners();
    try {
      affirmations = await _affirmationsService.loadAffirmationsFromCache();
      if (affirmations.isEmpty) {
        await fetchAllAffirmations();
      } else {
        currentAffirmation = getRandomDailyAffirmation();
        notifyListeners();
      }
      _hasError = false;
    } catch (e) {
      print('Error initializing affirmations: $e');
      _hasError = true;
      notifyListeners();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void _startPeriodicUpdate() {
    _timer = Timer.periodic(Duration(days: 1), (timer) async {
      await fetchAllAffirmations();
    });
  }

  // Update the _listenForConnectivityChanges method
  void _listenForConnectivityChanges() {
    // Cancel any existing subscription first
    _networkSubscription?.cancel();
    
    try {
      _networkSubscription = NetworkStatusProvider.instance.networkStatusStream.listen((isOnline) {
        // Skip if disposed
        if (_isDisposed) return;
        
        if (isOnline && !emotionsLoaded) {
          _initializeAffirmations();
          loadTodayEmotions();
        }
      });
    } catch (e) {
      debugPrint('Error setting up network listener in TodayPageState: $e');
    }
  }

  // Modified to only load once or when explicitly requested
  Future<void> loadTodayEmotions() async {
    // Skip if already loaded or currently loading
    if (emotionsLoaded || _isEmotionsLoading) {
      print('⏩ Skipping emotions reload - already loaded or loading in progress');
      return;
    }
    
    print('📊 Loading today emotions');
    _isEmotionsLoading = true;
    
    try {
      final userId = accountState.user?.id;
      if (userId == null) {
        _isEmotionsLoading = false;
        return;
      }
    
      // Use the existing TimelineState instance from Provider
      final timelineState = Provider.of<TimelineState>(navigatorKey.currentContext!, listen: false);
      
      final today = DateTime.now();
      final todayTimelineItems = timelineState.items.where((item) {
        return item.type == TimelineItemType.emotion_log &&
            item.createdAt.year == today.year &&
            item.createdAt.month == today.month &&
            item.createdAt.day == today.day;
      }).toList();
    
      // Process all emotions in a single batch
      final emotions = <Emotion>[];
      final futures = <Future<List<Emotion>>>[];
      
      for (var item in todayTimelineItems) {
        // Create futures without awaiting each one
        futures.add(_emotionsService.fetchEmotionLogsByTimelineItemId(item.id));
      }
      
      // Wait for all fetches to complete in parallel
      final results = await Future.wait(futures);
      
      // Combine all results
      for (var emotionList in results) {
        emotions.addAll(emotionList);
      }
      
      // Update state once with all emotions
      todayEmotions = emotions;
      emotionsLoaded = true;
      notifyListeners();
    } catch (e) {
      debugPrint('❌ Error loading today emotions: $e');
    } finally {
      _isEmotionsLoading = false;
    }
  }
  
  // Add a method to force reload emotions (call after adding new emotion logs)
  Future<void> refreshTodayEmotions() async {
    debugPrint('🔄 Explicitly refreshing today emotions'); 
    emotionsLoaded = false;
    await loadTodayEmotions();
  }

  @override
  void notifyListeners() {
    if (!_isDisposed) {
      super.notifyListeners();
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    _networkSubscription?.cancel();
    _timer?.cancel();
    super.dispose();
  }

  Future<void> fetchAllAffirmations() async {
    _isLoading = true;
    notifyListeners();
    try {
      final data = await _affirmationsService.fetchAllAffirmationsFromDB();
      affirmations = data;
      if (affirmations.isNotEmpty) {
        currentAffirmation = getRandomDailyAffirmation();
      }
      _hasError = false;
    } catch (e) {
      print('Error fetching affirmations: $e');
      _hasError = true;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Affirmation getRandomDailyAffirmation() {
    final int dayOfYear = int.parse(DateFormat("D").format(DateTime.now()));
    final int index = dayOfYear % affirmations.length;
    return affirmations[index];
  }

  Map<String, int> getEmotionCounts() {
    Map<String, int> counts = {};
    
    // Count occurrences of each emotion in the todayEmotions list
    for (var emotion in todayEmotions) {
      counts[emotion.id] = (counts[emotion.id] ?? 0) + 1;
    }
    
    return counts;
  }
}