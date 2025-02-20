import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:lightseed/src/models/affirmation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/timeline_item.dart';

class TimelineService {
  final supabase = Supabase.instance.client;

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

  Future<void> saveAffirmation(Affirmation affirmation) async {
    final userId = supabase.auth.currentUser!.id;
    final timelineItem = TimelineItem.fromAffirmation(affirmation, userId);

    try {
      await supabase
          .from('timeline_items')
          .insert(timelineItem.toJson());
          
      // Also save locally for offline access
      await addToTimeline(timelineItem, userId);
    } catch (e) {
      debugPrint('Error saving affirmation to timeline: $e');
      // Still save locally if offline
      await addToTimeline(timelineItem, userId);
    }
  }

  Future<void> addToTimeline(TimelineItem item, String userId) async {
    final prefs = await SharedPreferences.getInstance();
    final items = await getTimelineItems(userId);
    if (!items.any((existing) => existing.id == item.id)) {
      items.add(item);
      final jsonString = json.encode(items.map((i) => i.toJson()).toList());
      await prefs.setString(_getTimelineKey(userId), jsonString);
    }
  }

  Future<void> removeFromTimeline(TimelineItem item, String userId) async {
    final prefs = await SharedPreferences.getInstance();
    final items = await getTimelineItems(userId);
    items.removeWhere((i) => i.id == item.id);
    final jsonString = json.encode(items.map((i) => i.toJson()).toList());
    await prefs.setString(_getTimelineKey(userId), jsonString);
  }

  // Add method to clear timeline for a user
  Future<void> clearTimeline(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_getTimelineKey(userId));
  }
}