import 'package:flutter/foundation.dart';
import 'package:lightseed/src/services/timeline_sync_service.dart';
import '../models/timeline_item.dart';
import '../services/timeline_service.dart';

/// Manages the state of timeline items in the application.
/// 
/// This class is responsible for:
/// - Loading and maintaining the in-memory list of timeline items
/// - Adding and removing timeline items (affirmations, emotion logs, etc.)
/// - Synchronizing timeline data with the server
/// - Managing loading and refreshing states
/// 
/// It follows an offline-first approach, with all operations first updating the local
/// state for immediate UI feedback, then persisting to local storage, and finally
/// attempting server synchronization when network connectivity is available.
class TimelineState extends ChangeNotifier {
  /// Service for timeline storage and synchronization
  final TimelineService _service = TimelineService();
  
  /// Service specifically for timeline synchronization operations
  final TimelineSyncService _syncService = TimelineSyncService();
  
  /// In-memory list of timeline items
  List<TimelineItem> _items = [];
  
  /// User ID for whom this timeline state is being managed
  final String userId;
  
  /// Flag indicating if a refresh/sync operation is in progress
  bool _isRefreshing = false;
  
  /// Flag indicating if initial loading is in progress
  bool _isLoading = false;

  /// Current list of timeline items
  List<TimelineItem> get items => _items;
  
  /// Whether a refresh/sync operation is in progress
  bool get isRefreshing => _isRefreshing;
  
  /// Whether any loading operation is in progress (initial or refresh)
  bool get isLoading => _isLoading || _isRefreshing;

  /// Creates a new TimelineState for the specified user and loads their timeline.
  /// 
  /// @param userId The ID of the user whose timeline to manage
  TimelineState(this.userId) {
    loadTimeline();
  }

  /// Loads timeline items from local storage into memory.
  /// 
  /// Updates loading state and notifies listeners when complete.
  Future<void> loadTimeline() async {
    _isLoading = true;
    notifyListeners();
    try {
      _items = await _service.getTimelineItems(userId);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Adds an emotion log to the timeline.
  /// 
  /// Creates a new TimelineItem for the emotion log, saves it using the timeline
  /// service, and reloads the timeline to ensure consistency.
  /// 
  /// @param emotionIds List of emotion IDs that were logged
  /// @param notes Optional notes or context about the emotions
  Future<void> addEmotionLog(List<String> emotionIds, String notes) async {
    final timelineItem = TimelineItem.forEmotionLog(userId, notes, emotionIds);
    debugPrint('Adding emotion log with timeline item: ${timelineItem.toJson()}');
    await _service.addEmotionLog(timelineItem, emotionIds, notes);
    await loadTimeline();
  }

  /// Adds a timeline item to the user's timeline.
  /// 
  /// Updates the in-memory list immediately for UI responsiveness, then
  /// persists the item using the timeline service which handles both local
  /// storage and server synchronization.
  /// 
  /// @param item The timeline item to add
  Future<void> addToTimeline(TimelineItem item) async {
    // Add to local state
    items.add(item);
    notifyListeners();
    
    // Save to local storage and attempt server sync
    await _service.saveTimelineItem(item);
  }

  /// Removes a timeline item from the user's timeline.
  /// 
  /// Removes the item from local storage and reloads the timeline to
  /// ensure consistency.
  /// 
  /// @param item The timeline item to remove
  Future<void> removeFromTimeline(TimelineItem item) async {
    // Remove from local state first for immediate UI feedback
    _items.removeWhere((i) => i.id == item.id);
    notifyListeners();
    
    // Then delete from storage and server
    await _service.deleteTimelineItem(item, userId);
  }

  /// Clears all timeline items for the current user.
  /// 
  /// Removes all items from both local storage and memory.
  Future<void> clearTimeline() async {
    await _service.clearTimeline(userId);
    _items = [];
    notifyListeners();
  }

  /// Refreshes the timeline by synchronizing with the server.
  /// 
  /// This triggers a full synchronization cycle:
  /// 1. Push local changes to the server
  /// 2. Pull server changes to local storage
  /// 3. Reload the in-memory timeline
  /// 
  /// If a refresh operation is already in progress, this method returns
  /// without taking any action.
  Future<void> refreshTimeline() async {
    if (_isRefreshing) return;

    _isRefreshing = true;
    notifyListeners();

    try {
      await _syncService.syncItems(userId);
      await loadTimeline();  // Reload local items after sync
    } catch (e) {
      debugPrint('❌ Timeline refresh failed: $e');
    } finally {
      _isRefreshing = false;
      notifyListeners();
    }
  }
}