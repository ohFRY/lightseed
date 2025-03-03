import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:lightseed/src/models/affirmation.dart';
import 'package:lightseed/src/services/network/network_status_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/timeline_item.dart';

/// Service responsible for managing timeline items both locally and on the server.
/// 
/// This service implements an offline-first approach where timeline items are always
/// saved locally first, and then synchronized with the server when a connection is available.
/// It handles both reading from and writing to local storage, as well as syncing with Supabase.
class TimelineService {
  final supabase = Supabase.instance.client;

  /// Creates a unique storage key for a user's timeline items.
  /// 
  /// @param userId The ID of the user whose timeline is being accessed.
  /// @return A string key used for SharedPreferences storage.
  static String _getTimelineKey(String userId) => 'timeline_items_$userId';

  /// Retrieves all timeline items for a specific user from local storage.
  /// 
  /// @param userId The ID of the user whose timeline items to retrieve.
  /// @return A list of timeline items, or empty list if none are found.
  Future<List<TimelineItem>> getTimelineItems(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_getTimelineKey(userId));
    if (jsonString != null) {
      final List<dynamic> jsonData = json.decode(jsonString);
      return jsonData.map((item) {
        try {
          return TimelineItem.fromJson(item);
        } catch (e) {
          debugPrint('Error parsing TimelineItem from JSON: $e');
          return null;
        }
      }).whereType<TimelineItem>().toList();
    }
    return [];
  }

  /// Removes all timeline items for a specific user from local storage.
  /// 
  /// @param userId The ID of the user whose timeline items to clear.
  Future<void> clearTimeline(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_getTimelineKey(userId));
  }

  /// Saves an affirmation to the user's timeline.
  /// 
  /// Converts the affirmation to a timeline item and saves it both locally
  /// and to the server if online.
  /// Currently used when the user wants to save the recommended daily affirmation onto their timeline.
  /// 
  /// @param affirmation The affirmation to save to the timeline.
  Future<void> saveAffirmation(Affirmation affirmation) async {
    final userId = supabase.auth.currentUser!.id;
    final timelineItem = TimelineItem.fromAffirmation(affirmation, userId);
    await saveTimelineItem(timelineItem);
  }

  /// Adds an emotion log to the user's timeline.
  /// 
  /// Stores the provided emotion IDs in the timeline item's metadata
  /// and saves it both locally and to the server if online.
  ///
  /// @param timelineItem The timeline item to use as a base for the emotion log.
  /// @param emotionIds List of emotion IDs to associate with this log.
  /// @param notes User notes or content for this emotion log.
  Future<void> addEmotionLog(TimelineItem timelineItem, List<String> emotionIds, String notes) async {
    // Setting the emotion IDs in metadata if not already set
    if (!timelineItem.metadata.containsKey('emotion_ids')) {
      final updatedMetadata = Map<String, dynamic>.from(timelineItem.metadata);
      updatedMetadata['emotion_ids'] = emotionIds;
      timelineItem = TimelineItem(
        id: timelineItem.id,
        userId: timelineItem.userId,
        content: notes,
        type: timelineItem.type,
        createdAt: timelineItem.createdAt,
        metadata: updatedMetadata,
      );
    }
    
    await saveTimelineItem(timelineItem);
  }

  /// Adds a timeline item to local storage.
  /// 
  /// Only adds the item if an item with the same ID doesn't already exist.
  /// 
  /// @param item The timeline item to add to local storage.
  /// @param userId The ID of the user whose timeline to update.
  Future<void> addToTimeline(TimelineItem item, String userId) async {
    final prefs = await SharedPreferences.getInstance();
    final items = await getTimelineItems(userId);
    if (!items.any((existing) => existing.id == item.id)) {
      items.add(item);
      final jsonString = json.encode(items.map((i) => i.toJson()).toList());
      await prefs.setString(_getTimelineKey(userId), jsonString);
    }
  }

  /// Removes a timeline item from local storage.
  /// 
  /// @param item The timeline item to remove.
  /// @param userId The ID of the user whose timeline to update.
  Future<void> removeFromTimeline(TimelineItem item, String userId) async {
    final prefs = await SharedPreferences.getInstance();
    final items = await getTimelineItems(userId);
    items.removeWhere((i) => i.id == item.id);
    final jsonString = json.encode(items.map((i) => i.toJson()).toList());
    await prefs.setString(_getTimelineKey(userId), jsonString);
  }

  /// Core method to save any timeline item with an offline-first approach.
  /// 
  /// Saves the item locally first, then attempts to save to the server if online.
  /// Adds timestamps for sync purposes and handles special cases like emotion logs.
  /// 
  /// @param item The timeline item to save.
  Future<void> saveTimelineItem(TimelineItem item) async {
    final userId = supabase.auth.currentUser!.id;
    
    // Always save locally first for immediate UI update
    await addToTimeline(item, userId);
    
    // Try to sync with server if online
    final networkStatusProvider = NetworkStatusProvider.instance;
    final isOnline = networkStatusProvider.isOnline;
    
    if (isOnline) {
      try {
        // Add timestamp before server save
        if (item.metadata['saved_at'] == null) {
          final updatedMetadata = Map<String, dynamic>.from(item.metadata);
          updatedMetadata['saved_at'] = DateTime.now().toIso8601String();
          item = TimelineItem(
            id: item.id,
            userId: item.userId,
            content: item.content,
            type: item.type,
            createdAt: item.createdAt,
            metadata: updatedMetadata,
          );
        }
        
        await supabase.from('timeline_items').insert(item.toJson());
        
        // For emotion logs, also save related data
        if (item.type == TimelineItemType.emotion_log) {
          final emotionIds = item.metadata['emotion_ids'] as List<dynamic>;
          for (final emotionId in emotionIds) {
            await supabase.from('emotion_logs').insert({
              'timeline_item_id': item.id,
              'emotion_id': emotionId,
              'notes': item.content,
              'created_at': DateTime.now().toIso8601String(),
            });
          }
        }
        
        debugPrint('✅ Server save successful for ${item.id}');
      } catch (e) {
        debugPrint('❌ Server save failed: $e');
        // Already saved locally, so just log the error
      }
    }
  }

  /// Deletes a timeline item using an offline-first approach.
  /// 
  /// Removes the item from local storage first, then attempts to delete from
  /// the server if online.
  /// 
  /// @param item The timeline item to delete.
  /// @param userId The ID of the user whose timeline to update.
  Future<void> deleteTimelineItem(TimelineItem item, String userId) async {
    // Always delete locally first for immediate UI update
    await removeFromTimeline(item, userId);
    
    // Try to delete from server if online
    final networkStatusProvider = NetworkStatusProvider.instance;
    final isOnline = networkStatusProvider.isOnline;
    
    if (isOnline) {
      try {
        // For emotion logs, delete related records first
        if (item.type == TimelineItemType.emotion_log) {
          await supabase.from('emotion_logs')
              .delete()
              .eq('timeline_item_id', item.id);
        }
        
        // Then delete the timeline item itself
        await supabase.from('timeline_items')
            .delete()
            .eq('id', item.id);
        
        debugPrint('✅ Server delete successful for ${item.id}');
      } catch (e) {
        debugPrint('❌ Server delete failed: $e');
        // Already deleted locally, so just log the error
      }
    }
  }
}