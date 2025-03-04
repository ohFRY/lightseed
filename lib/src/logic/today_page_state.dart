import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lightseed/src/models/affirmation.dart';
import 'package:lightseed/src/services/affirmations_service.dart';
import 'package:lightseed/src/services/network/connectivity_service.dart';
import 'package:lightseed/src/logic/timeline_state.dart';
import '../models/timeline_item.dart';
import '../models/emotion.dart';
import '../services/emotions_service.dart';
import 'account_state_screen.dart';

class TodayPageState extends ChangeNotifier {
  final AffirmationsService _affirmationsService = AffirmationsService();
  final ConnectivityService _connectivityService = ConnectivityService();
  final EmotionsService _emotionsService = EmotionsService();
  final AccountState accountState;
  List<Affirmation> affirmations = [];
  List<Emotion> todayEmotions = [];
  Affirmation currentAffirmation = Affirmation(content: '', id: 0);
  Timer? _timer;
  bool _hasError = false;
  bool _isLoading = false;

  bool get hasError => _hasError;
  bool get isLoading => _isLoading;

  TodayPageState(this.accountState) {
    _initializeAffirmations();
    _startPeriodicUpdate();
    _listenForConnectivityChanges();
    _loadTodayEmotions();
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

  void _listenForConnectivityChanges() {
    _connectivityService.connectivityStream.listen((isConnected) {
      if (isConnected) {
        _initializeAffirmations();
      }
    });
  }

  Future<void> _loadTodayEmotions() async {
    final userId = accountState.user?.id;
    if (userId == null) return;

    final timelineState = TimelineState(userId);
    await timelineState.loadTimeline();
    final today = DateTime.now();
    final todayTimelineItems = timelineState.items.where((item) {
      return item.type == TimelineItemType.emotion_log &&
          item.createdAt.year == today.year &&
          item.createdAt.month == today.month &&
          item.createdAt.day == today.day;
    }).toList();

    todayEmotions = [];
    final processedTimelineItemIds = <String>{};
    for (var item in todayTimelineItems) {
      if (processedTimelineItemIds.contains(item.id)) continue;
      processedTimelineItemIds.add(item.id);

      debugPrint('Processing timeline item ID: ${item.id}');
      final emotionLogs = await _emotionsService.fetchEmotionLogsByTimelineItemId(item.id);
      debugPrint('Emotion logs for timeline item ID ${item.id}: $emotionLogs');
      todayEmotions.addAll(emotionLogs);
    }
    notifyListeners();
  }

  @override
  void dispose() {
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