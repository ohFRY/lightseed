import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/timeline_item.dart';
import 'timeline_service.dart';

class TimelineSyncService {
  final TimelineService _timelineService = TimelineService();
  
  Future<void> syncItems(String userId) async {
    debugPrint('🔄 Starting timeline sync for user: $userId');
    try {
      final localItems = await _timelineService.getTimelineItems(userId);
      
      final response = await Supabase.instance.client
          .from('timeline_items')
          .select()
          .eq('user_id', userId);
      
      final serverItems = (response as List)
          .map((item) => TimelineItem.fromJson(item))
          .toList();

      await _syncLocalToServer(localItems, serverItems, userId);
      await _syncServerToLocal(serverItems, localItems, userId);
      
      debugPrint('✅ Timeline sync completed');
    } catch (e) {
      debugPrint('❌ Timeline sync failed: $e');
    }
  }

  Future<void> _syncLocalToServer(
    List<TimelineItem> localItems,
    List<TimelineItem> serverItems,
    String userId,
  ) async {
    for (final localItem in localItems) {
      final serverItem = serverItems.firstWhere(
        (server) => server.id == localItem.id,
        orElse: () => localItem,
      );

      // If item exists on server, check if local is newer
      if (serverItems.any((s) => s.id == localItem.id)) {
        if (_shouldSync(localItem, serverItem)) {
          await Supabase.instance.client
              .from('timeline_items')
              .upsert(localItem.toJson());
        }
      } else {
        // Item doesn't exist on server, upload it
        await Supabase.instance.client
            .from('timeline_items')
            .insert(localItem.toJson());
      }
    }
  }

  Future<void> _syncServerToLocal(
    List<TimelineItem> serverItems,
    List<TimelineItem> localItems,
    String userId,
  ) async {
    for (final serverItem in serverItems) {
      final localItem = localItems.firstWhere(
        (local) => local.id == serverItem.id,
        orElse: () => serverItem,
      );

      // If item exists locally, check if server is newer
      if (localItems.any((l) => l.id == serverItem.id)) {
        if (_shouldSync(serverItem, localItem)) {
          await _timelineService.addToTimeline(serverItem, userId);
        }
      } else {
        // Item doesn't exist locally, download it
        await _timelineService.addToTimeline(serverItem, userId);
      }
    }
  }

  bool _shouldSync(TimelineItem source, TimelineItem target) {
    final sourceSavedAt = DateTime.parse(source.metadata['saved_at'] as String);
    final targetSavedAt = DateTime.parse(target.metadata['saved_at'] as String);
    return sourceSavedAt.isAfter(targetSavedAt);
  }
}