import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/timeline_item.dart';
import 'timeline_service.dart';

/// Service responsible for synchronizing timeline items between local storage and the server.
///
/// This service handles the bidirectional synchronization process:
/// 1. Local-to-server sync: Pushes local changes to the Supabase database
/// 2. Server-to-local sync: Pulls server changes to local storage
///
/// The sync process uses timestamps in each item's metadata to determine which version
/// is more recent. Items without timestamps are handled safely to prevent data loss.
class TimelineSyncService {
  // Add these static variables
  static DateTime? _lastGlobalSyncTime;
  static bool _syncInProgress = false;
  static final _syncDebounceTime = const Duration(seconds: 10);
  
  final TimelineService _timelineService = TimelineService();

  /// Synchronizes timeline items for a specific user.
  ///
  /// This is the main entry point for the sync process. It:
  /// 1. Fetches all timeline items from both local storage and the server
  /// 2. Pushes local changes to the server
  /// 3. Pulls server changes to local storage
  ///
  /// @param userId The ID of the user whose timeline to synchronize
  Future<void> syncItems(String userId) async {
    // Check if sync is in progress or was done recently
    final now = DateTime.now();
    if (_syncInProgress) {
      debugPrint('⏱️ Skipping sync - another sync already in progress');
      return;
    }
    
    if (_lastGlobalSyncTime != null && 
        now.difference(_lastGlobalSyncTime!) < _syncDebounceTime) {
      debugPrint('⏱️ Skipping sync - previous sync too recent (${now.difference(_lastGlobalSyncTime!).inSeconds}s ago)');
      return;
    }
    
    try {
      _syncInProgress = true;
      _lastGlobalSyncTime = now;
      debugPrint('🔄 Starting timeline sync for user: $userId');
      final localItems = await _timelineService.getTimelineItems(userId);
      
      // Add debug info for local items
      debugPrint('📱 Local items count: ${localItems.length}');
      if (localItems.isNotEmpty) {
        debugPrint('📱 Sample local item metadata: ${localItems.first.metadata}');
        debugPrint('📱 Local timestamps: ${localItems.map((item) => item.metadata['saved_at']).toList()}');
      }
      
      final response = await Supabase.instance.client
          .from('timeline_items')
          .select()
          .eq('user_id', userId);
      
      final serverItems = (response as List)
          .map((item) => TimelineItem.fromJson(item))
          .toList();
      
      // Add debug info for server items
      debugPrint('☁️ Server items count: ${serverItems.length}');
      if (serverItems.isNotEmpty) {
        debugPrint('☁️ Sample server item metadata: ${serverItems.first.metadata}');
        debugPrint('☁️ Server timestamps: ${serverItems.map((item) => item.metadata['saved_at']).toList()}');
      }

      await _syncLocalToServer(localItems, serverItems, userId);
      await _syncServerToLocal(serverItems, localItems, userId);
      
      debugPrint('✅ Timeline sync completed');
    } catch (e) {
      debugPrint('❌ Timeline sync failed: $e');
      rethrow;
    } finally {
      _syncInProgress = false;
    }
  }

  /// Uploads local timeline items to the server.
  ///
  /// For each local item:
  /// - If it exists on the server, updates it if the local version is newer
  /// - If it doesn't exist on the server, creates it
  ///
  /// @param localItems List of timeline items from local storage
  /// @param serverItems List of timeline items from the server
  /// @param userId The ID of the user whose timeline is being synchronized
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

      // Enhanced debug info
      debugPrint('Considering local->server sync for item ${localItem.id} (${localItem.type})');
      debugPrint('- Local item metadata: ${localItem.metadata}');
      debugPrint('- Local item saved_at: ${localItem.metadata['saved_at']}');
      
      // If item exists on server, check if local is newer
      if (serverItems.any((s) => s.id == localItem.id)) {
        debugPrint('- Item exists on server, checking if update needed');
        final shouldUpdate = _shouldSync(localItem, serverItem);
        debugPrint('- Should update? $shouldUpdate');
        
        if (shouldUpdate) {
          debugPrint('- Updating item on server: ${localItem.id}');
          try {
            await Supabase.instance.client
                .from('timeline_items')
                .upsert(localItem.toJson());
            debugPrint('- ✅ Server update successful for ${localItem.id}');
          } catch (e) {
            debugPrint('- ❌ Server update failed: $e');
            rethrow;
          }
        }
      } else {
        // Item doesn't exist on server, upload it
        debugPrint('- Item doesn\'t exist on server, uploading: ${localItem.id}');
        try {
          await Supabase.instance.client
              .from('timeline_items')
              .insert(localItem.toJson());
          debugPrint('- ✅ Server insert successful for ${localItem.id}');
        } catch (e) {
          debugPrint('- ❌ Server insert failed: $e');
          rethrow; 
        }
      }
    }
  }

  /// Downloads server timeline items to local storage.
  ///
  /// For each server item:
  /// - If it exists locally, updates it if the server version is newer
  /// - If it doesn't exist locally, downloads it
  ///
  /// @param serverItems List of timeline items from the server
  /// @param localItems List of timeline items from local storage
  /// @param userId The ID of the user whose timeline is being synchronized
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

  /// Determines if a source item should be synchronized to replace a target item.
  ///
  /// Compares the 'saved_at' timestamps in the metadata of both items.
  /// Source item should replace target item if its timestamp is more recent.
  /// If either item is missing a timestamp, no sync is performed to prevent data loss.
  ///
  /// @param source The item being considered as the new version
  /// @param target The existing item that might be replaced
  /// @return true if the source should replace the target, false otherwise
  bool _shouldSync(TimelineItem source, TimelineItem target) {
    // If either item doesn't have a saved_at timestamp, don't try to compare them
    if (source.metadata['saved_at'] == null || target.metadata['saved_at'] == null) {
      debugPrint('⚠️ Cannot compare items due to missing timestamp');
      // Since they're already synced (based on IDs matching), don't try to sync again
      return false;
    }
    
    final sourceSavedAt = DateTime.parse(source.metadata['saved_at'] as String);
    final targetSavedAt = DateTime.parse(target.metadata['saved_at'] as String);
    return sourceSavedAt.isAfter(targetSavedAt);
  }
}