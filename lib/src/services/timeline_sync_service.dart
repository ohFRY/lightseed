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
      
      // Query saved_affirmations instead of timeline_items
      final response = await Supabase.instance.client
          .from('saved_affirmations')
          .select()
          .eq('user_id', userId);
      
      final serverItems = (response as List).map((item) => TimelineItem(
        id: item['affirmation_id'],
        content: item['content'],
        type: TimelineItemType.affirmation,
        createdAt: DateTime.parse(item['created_at']),
        savedAt: DateTime.parse(item['saved_at']),
      )).toList();

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
    final itemsToSync = localItems.where((local) =>
      !serverItems.any((server) => 
        server.id == local.id && 
        server.type == local.type
      )
    ).toList();

    if (itemsToSync.isNotEmpty) {
      debugPrint('📤 Uploading ${itemsToSync.length} items to server');
      await Future.wait(
        itemsToSync.map((item) => 
          Supabase.instance.client
              .from('saved_affirmations')
              .insert({
                'user_id': userId,
                'affirmation_id': item.id,
                'content': item.content,
                'created_at': item.createdAt.toIso8601String(),
                'saved_at': item.savedAt.toIso8601String(),
              })
        )
      );
    }
  }

  Future<void> _syncServerToLocal(
    List<TimelineItem> serverItems,
    List<TimelineItem> localItems,
    String userId,
  ) async {
    final itemsToSync = serverItems.where((server) =>
      !localItems.any((local) => 
        local.id == server.id && 
        local.type == server.type
      )
    ).toList();

    if (itemsToSync.isNotEmpty) {
      debugPrint('📥 Downloading ${itemsToSync.length} items from server');
      for (final item in itemsToSync) {
        await _timelineService.addToTimeline(item, userId);
      }
    }
  }
}