import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
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
  /// Retrieves all emotions that were logged in the specified timeline item
  /// by joining the emotion_logs table with the emotions table.
  /// 
  /// @param timelineItemId ID of the timeline item for which to fetch emotions.
  /// @return A list of Emotion objects associated with the timeline item.
  /// @throws Exception If a network error occurs or if the fetch operation fails.
  Future<List<Emotion>> fetchEmotionLogsByTimelineItemId(String timelineItemId) async {
    try {
      debugPrint('Fetching emotion logs for timeline item ID: $timelineItemId');
      final data = await supabase
          .from('emotion_logs')
          .select('emotion_id, emotions!inner(id, name, description, valence, arousal_level)')
          .eq('timeline_item_id', timelineItemId);

      debugPrint('Fetched emotion logs for $timelineItemId: $data');

      return data.map<Emotion>((item) {
        final emotionData = item['emotions'];
        if (emotionData == null) {
          throw Exception('Emotion data is null for timeline item ID: $timelineItemId');
        }
        return Emotion.fromJson(emotionData);
      }).toList();
    } on SocketException catch (e) {
      throw Exception('Network error: $e');
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
}