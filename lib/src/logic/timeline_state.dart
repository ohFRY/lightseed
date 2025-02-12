import 'package:flutter/foundation.dart';
import 'package:lightseed/src/services/timeline_sync_service.dart';
import '../models/timeline_item.dart';
import '../services/timeline_service.dart';

class TimelineState extends ChangeNotifier {
  final TimelineService _service = TimelineService();
  final TimelineSyncService _syncService = TimelineSyncService();
  List<TimelineItem> _items = [];
  final String userId;
  bool _isRefreshing = false;
  bool _isLoading = false;  // Add this
  
  List<TimelineItem> get items => _items;
  bool get isRefreshing => _isRefreshing;
  bool get isLoading => _isLoading || _isRefreshing;  // Modify this

  TimelineState(this.userId) {
    loadTimeline();
  }

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

  Future<void> addToTimeline(TimelineItem item) async {
    await _service.addToTimeline(item, userId);
    await loadTimeline();
  }

  Future<void> removeFromTimeline(TimelineItem item) async {
    await _service.removeFromTimeline(item, userId);
    await loadTimeline();
  }

  Future<void> clearTimeline() async {
    await _service.clearTimeline(userId);
    _items = [];
    notifyListeners();
  }

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