import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/timeline_item.dart';

class TimelineService {
  static String _getTimelineKey(String userId) => 'timeline_items_$userId';
  
  Future<List<TimelineItem>> getTimelineItems(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_getTimelineKey(userId));
    if (jsonString != null) {
      final List<dynamic> jsonData = json.decode(jsonString);
      return jsonData.map((item) => TimelineItem.fromJson(item)).toList();
    }
    return [];
  }

  Future<void> addToTimeline(TimelineItem item, String userId) async {
    final prefs = await SharedPreferences.getInstance();
    final items = await getTimelineItems(userId);
    if (!items.any((existing) => existing.id == item.id && existing.type == item.type)) {
      items.add(item);
      final jsonString = json.encode(items.map((i) => i.toJson()).toList());
      await prefs.setString(_getTimelineKey(userId), jsonString);
    }
  }

  Future<void> removeFromTimeline(TimelineItem item, String userId) async {
    final prefs = await SharedPreferences.getInstance();
    final items = await getTimelineItems(userId);
    items.removeWhere((i) => i.id == item.id && i.type == item.type);
    final jsonString = json.encode(items.map((i) => i.toJson()).toList());
    await prefs.setString(_getTimelineKey(userId), jsonString);
  }

  // Add method to clear timeline for a user
  Future<void> clearTimeline(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_getTimelineKey(userId));
  }
}