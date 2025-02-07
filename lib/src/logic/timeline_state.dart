import 'package:flutter/foundation.dart';
import '../models/timeline_item.dart';
import '../services/timeline_service.dart';

class TimelineState extends ChangeNotifier {
  final TimelineService _service = TimelineService();
  List<TimelineItem> _items = [];
  
  List<TimelineItem> get items => _items;

  TimelineState() {
    loadTimeline();
  }

  Future<void> loadTimeline() async {
    _items = await _service.getTimelineItems();
    notifyListeners();
  }

  Future<void> addToTimeline(TimelineItem item) async {
    await _service.addToTimeline(item);
    await loadTimeline();
  }

  Future<void> removeFromTimeline(TimelineItem item) async {
    await _service.removeFromTimeline(item);
    await loadTimeline();
  }
}