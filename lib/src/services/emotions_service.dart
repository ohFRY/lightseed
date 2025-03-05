import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:lightseed/main.dart';
import 'package:lightseed/src/logic/timeline_state.dart';
import 'package:lightseed/src/models/timeline_item.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/emotion.dart';

/// Service responsible for retrieving and managing emotions data.
/// 
/// This class handles:
/// - Fetching emotions from the Supabase database
/// - Caching emotions locally for offline access
/// - Loading emotions from the local cache
/// - Retrieving emotion logs associated with timeline items
/// 
/// It implements an offline-first approach where emotions are cached locally
/// after being fetched from the database to ensure availability even when offline.
class EmotionsService {
  /// Key used for storing emotions data in SharedPreferences.
  static const String _cacheKey = 'cached_emotions';
  
  /// Supabase client instance for database operations.
  final supabase = Supabase.instance.client;

  /// Fetches all emotions from the Supabase database.
  /// 
  /// Retrieves the complete list of emotions, ordered by creation date,
  /// and automatically caches them locally for offline access.
  /// 
  /// @return A list of Emotion objects.
  /// @throws Exception If a network error occurs or if the fetch operation fails.
  Future<List<Emotion>> fetchAllEmotionsFromDB() async {
    try {
      final data = await supabase
          .from('emotions')
          .select()
          .order('created_at', ascending: true);

      final emotions = data.map<Emotion>((item) => Emotion.fromJson(item)).toList();
      await _cacheAllEmotionsLocally(emotions);
      return emotions;
    } on SocketException catch (e) {
      throw Exception('Network error: $e');
    } catch (e) {
      throw Exception('Error fetching emotions: $e');
    }
  }

  /// Fetches emotions associated with a specific timeline item.
  /// 
  /// This method implements a cache-first approach:
  /// 1. First attempts to retrieve emotions from the cached timeline items
  /// 2. Falls back to Supabase database queries only when needed
  /// 
  /// The caching flow works as follows:
  /// - Checks if the timeline item exists in the TimelineState provider's cached items
  /// - If found, extracts emotion IDs from the item's metadata
  /// - Converts these IDs to Emotion objects using fetchEmotionsByIds
  /// - Only if not found in cache, performs a database join query between emotion_logs and emotions
  /// 
  /// @param timelineItemId ID of the timeline item for which to fetch emotions
  /// @return A list of Emotion objects associated with the timeline item
  /// @throws Exception If retrieval fails for any reason
  Future<List<Emotion>> fetchEmotionLogsByTimelineItemId(String timelineItemId) async {
    try {
      debugPrint('Processing timeline item ID: $timelineItemId');
      
      // First, check if we can get this data from the timeline cache
      final timelineState = Provider.of<TimelineState>(navigatorKey.currentContext!, listen: false);
      
      // Find the timeline item in cached items using try-catch pattern for null safety
      TimelineItem? timelineItem;
      try {
        // Attempt to find matching timeline item in the cached items
        timelineItem = timelineState.items.firstWhere(
          (item) => item.id == timelineItemId && item.type == TimelineItemType.emotion_log,
        );
      } catch (e) {
        // Item not found in cache, timelineItem remains null
        // Will fall through to database query path
      }

      // Cache hit: Timeline item exists and contains emotion_ids in its metadata
      if (timelineItem != null && 
          timelineItem.metadata.containsKey('emotion_ids')) {
        debugPrint('Using cached timeline item for emotion logs: $timelineItemId');
        
        // Extract emotion IDs from metadata and convert to properly typed List<String>
        final emotionIds = List<String>.from(timelineItem.metadata['emotion_ids']);
        
        // Convert IDs to full Emotion objects
        final emotions = await fetchEmotionsByIds(emotionIds);
        return emotions;
      }
      
      // Cache miss: Fetch from Supabase database
      debugPrint('Fetching emotion logs from server for timeline item ID: $timelineItemId');
      final data = await supabase
          .from('emotion_logs')
          .select('emotion_id, emotions!inner(id, name, description, valence, arousal_level)')
          .eq('timeline_item_id', timelineItemId);

      debugPrint('Fetched emotion logs for $timelineItemId: $data');

      // Transform response data into Emotion objects
      final emotions = data.map<Emotion>((item) {
        final emotionData = item['emotions'];
        return Emotion.fromJson(emotionData);
      }).toList();
      
      return emotions;
    } catch (e) {
      throw Exception('Error fetching emotion logs: $e');
    }
  }

  /// Saves emotions to local cache for offline access.
  /// 
  /// Serializes the emotion list to JSON and stores it in SharedPreferences.
  /// 
  /// @param emotions List of Emotion objects to cache locally.
  Future<void> _cacheAllEmotionsLocally(List<Emotion> emotions) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = json.encode(emotions.map((e) => e.toJson()).toList());
    await prefs.setString(_cacheKey, jsonString);
  }

  /// Loads emotions from the local cache.
  /// 
  /// Retrieves the cached emotions data from SharedPreferences and
  /// deserializes it into a list of Emotion objects.
  /// 
  /// @return A list of Emotion objects from the cache, or an empty list if the cache is empty.
  Future<List<Emotion>> loadEmotionsFromCache() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_cacheKey);
    if (jsonString != null) {
      final List<dynamic> jsonData = json.decode(jsonString);
      return jsonData.map((item) => Emotion.fromJson(item)).toList();
    }
    return [];
  }

  /// Fetches complete Emotion objects by their IDs.
  /// 
  /// This helper method:
  /// - Takes a list of emotion IDs
  /// - Queries each emotion individually from the database
  /// - Returns a list of fully populated Emotion objects
  /// 
  /// Used primarily to convert emotion IDs stored in timeline item metadata
  /// into complete Emotion objects with all properties.
  ///
  /// @param emotionIds List of emotion UUID strings to fetch
  /// @return List of corresponding Emotion objects
  /// @throws Exception If any fetch operation fails
  Future<List<Emotion>> fetchEmotionsByIds(List<String> emotionIds) async {
    try {
      final emotions = <Emotion>[];
      
      // Fetch each emotion by ID - individual queries for simplicity
      // Could be optimized with an "in" query for better performance with many IDs
      for (final id in emotionIds) {
        final data = await supabase
            .from('emotions')
            .select()
            .eq('id', id)
            .single();
        
        emotions.add(Emotion.fromJson(data));
      }
      
      return emotions;
    } catch (e) {
      throw Exception('Error fetching emotions by IDs: $e');
    }
  }
}