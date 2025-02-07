import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/timeline_item.dart';

class TimelineService {
  static const String _timelineKey = 'timeline_items';

  Future<List<TimelineItem>> getTimelineItems() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_timelineKey);
    if (jsonString != null) {
      final List<dynamic> jsonData = json.decode(jsonString);
      return jsonData.map((item) => TimelineItem.fromJson(item)).toList();
    }
    return [];
  }

  Future<void> addToTimeline(TimelineItem item) async {
    final prefs = await SharedPreferences.getInstance();
    final items = await getTimelineItems();
    if (!items.any((existing) => existing.id == item.id && existing.type == item.type)) {
      items.add(item);
      final jsonString = json.encode(items.map((i) => i.toJson()).toList());
      await prefs.setString(_timelineKey, jsonString);
    }
  }

  Future<void> removeFromTimeline(TimelineItem item) async {
    final prefs = await SharedPreferences.getInstance();
    final items = await getTimelineItems();
    items.removeWhere((i) => i.id == item.id && i.type == item.type);
    final jsonString = json.encode(items.map((i) => i.toJson()).toList());
    await prefs.setString(_timelineKey, jsonString);
  }
}