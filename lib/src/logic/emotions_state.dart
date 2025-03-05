import 'package:flutter/material.dart';
import '../models/emotion.dart';
import '../services/emotions_service.dart';
import '../services/network/connectivity_service.dart';

/// Manages the state of emotions in the application.
/// 
/// This class is responsible for:
/// - Loading emotions from local cache or database
/// - Tracking which emotions are selected by the user
/// - Managing loading and error states
/// - Refreshing emotions data when network connectivity is restored
/// - Formatting selected emotions for display
/// 
/// It follows an offline-first approach, first loading from cache and then
/// attempting to fetch from the database when connectivity is available.
class EmotionsState extends ChangeNotifier {
  /// Service for fetching and caching emotions
  final EmotionsService _emotionsService = EmotionsService();
  
  /// Service for monitoring device connectivity
  final ConnectivityService _connectivityService = ConnectivityService();
  
  /// List of all available emotions
  List<Emotion> emotions = [];
  
  /// Set of currently selected emotion IDs
  Set<String> selectedEmotionIds = {};
  
  /// Flag indicating if an error occurred during data loading
  bool _hasError = false;
  
  /// Flag indicating if emotions are currently being loaded
  bool _isLoading = false;

  /// Whether an error occurred during data loading
  bool get hasError => _hasError;
  
  /// Whether emotions are currently being loaded
  bool get isLoading => _isLoading;

  /// Whether the state has been disposed
  bool _isDisposed = false;

  /// Creates a new EmotionsState instance and initializes emotions data.
  EmotionsState() {
    _initializeEmotions();
    _listenForConnectivityChanges();
  }

  /// Initializes the emotions list from cache or database.
  /// 
  /// First tries to load emotions from the local cache. If the cache is empty,
  /// it attempts to fetch emotions from the database. Sets loading and error
  /// states appropriately during the process.
  Future<void> _initializeEmotions() async {
    try {
      // Add a mounted/disposed check before any state updates
      if (_isDisposed) return;
      
      _isLoading = true;
      notifyListeners();
      try {
        emotions = await _emotionsService.loadEmotionsFromCache();
        if (emotions.isEmpty) {
          await fetchAllEmotions();
        }
        _hasError = false;
      } catch (e) {
        print('Error initializing emotions: $e');
        _hasError = true;
      } finally {
        _isLoading = false;
        // Before notifying listeners
        if (!_isDisposed) {
          notifyListeners();
        }
      }
    } catch (e) {
      print('Error initializing emotions: $e');
    }
  }

  /// Sets up a listener to refresh emotions when network connectivity is restored.
  void _listenForConnectivityChanges() {
    _connectivityService.connectivityStream.listen((isConnected) {
      if (isConnected) {
        _initializeEmotions();
      }
    });
  }

  /// Fetches all emotions directly from the database.
  /// 
  /// Updates loading and error states appropriately during the process.
  /// This is used both during initialization and for explicit refresh requests.
  Future<void> fetchAllEmotions() async {
    _isLoading = true;
    notifyListeners();
    try {
      emotions = await _emotionsService.fetchAllEmotionsFromDB();
      _hasError = false;
    } catch (e) {
      print('Error fetching emotions: $e');
      _hasError = true;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Toggles the selection state of an emotion.
  /// 
  /// If the emotion is already selected, it will be deselected.
  /// If it's not selected, it will be added to the selection.
  /// 
  /// @param id The ID of the emotion to toggle
  void toggleSelection(String id) {
    if (selectedEmotionIds.contains(id)) {
      selectedEmotionIds.remove(id);
    } else {
      selectedEmotionIds.add(id);
    }
    notifyListeners();
  }

  /// Formats the selected emotion names into a comma-separated string.
  /// 
  /// @return A string containing all selected emotion names, separated by commas,
  ///         or an empty string if no emotions are selected.
  String getFormattedEmotionNames() {
    if (selectedEmotionIds.isEmpty) return '';
    
    final emotionMap = {for (var e in emotions) e.id: e.name};
    final emotionNames = selectedEmotionIds.map((id) => emotionMap[id]).whereType<String>();
    return emotionNames.join(', ');
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }
}