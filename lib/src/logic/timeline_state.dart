import 'package:flutter/foundation.dart';
import '../models/timeline_item.dart';
import '../services/timeline_service.dart';

class TimelineState extends ChangeNotifier {
  final TimelineService _service = TimelineService();
  List<TimelineItem> _items = [];
  final String userId;
  
  List<TimelineItem> get items => _items;

  TimelineState(this.userId) {
    loadTimeline();
  }

  Future<void> loadTimeline() async {
    _items = await _service.getTimelineItems(userId);
    notifyListeners();
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
}