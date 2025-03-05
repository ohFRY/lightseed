import 'package:flutter/material.dart';
import 'package:lightseed/src/logic/timeline_state.dart';
import 'package:lightseed/src/logic/today_page_state.dart';
import 'package:lightseed/src/logic/account_state_screen.dart';
import 'package:provider/provider.dart';

class AppInitializationService {
  /// Initializes all app data in the correct sequence
  /// Returns true when initialization is complete
  static Future<bool> initializeAppData(BuildContext context) async {
    // Store providers to avoid BuildContext across async gaps
    final timelineState = Provider.of<TimelineState>(context, listen: false);
    final todayState = Provider.of<TodayPageState>(context, listen: false);
    final accountState = Provider.of<AccountState>(context, listen: false);
    
    try {
      // Fetch user profile first (lightweight operation)
      if (accountState.user == null) {
        await accountState.fetchUser();
      }
      
      // Fetch timeline data with proper error handling
      try {
        await timelineState.refreshTimeline();
      } catch (e) {
        debugPrint('Error refreshing timeline: $e');
        // Continue despite error - we'll try to work with local data
      }
      
      // Small delay to ensure storage operations complete
      await Future.delayed(const Duration(milliseconds: 300));
      
      // Load emotions with error handling
      try {
        await todayState.loadTodayEmotions();
      } catch (e) {
        debugPrint('Error loading emotions: $e');
        // Continue despite error
      }
      
      return true;
    } catch (e) {
      debugPrint('❌ Error during app initialization: $e');
      return false;
    }
  }
}