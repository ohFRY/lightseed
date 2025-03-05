import 'package:flutter/material.dart';
import 'package:lightseed/src/logic/timeline_state.dart';
import 'package:lightseed/src/logic/today_page_state.dart';
import 'package:lightseed/src/logic/account_state_screen.dart';
import 'package:provider/provider.dart';

/// A service responsible for managing the application's data initialization sequence.
///
/// This class handles the ordered loading of user data, timeline information,
/// and emotion records with built-in retry mechanisms and error handling.
/// It employs a sequential approach to ensure data dependencies are respected.
class AppInitializationService {

  /// Initializes all app data in the correct sequence, respecting data dependencies.
  ///
  /// This method orchestrates the initialization flow:
  /// 1. First loads user profile information (authentication data)
  /// 2. Then refreshes timeline data from local storage and remote server
  /// 3. Finally loads today's emotions with built-in retry mechanism
  ///
  /// The method uses stored provider references to avoid BuildContext access across
  /// async gaps, which prevents potential widget tree rebuild issues.
  ///
  /// Parameters:
  ///   [context] - The BuildContext used to access providers
  ///
  /// Returns:
  ///   [Future<bool>] - Returns true if initialization completes successfully, 
  ///                    false if any critical initialization step fails
  ///
  /// Throws:
  ///   Catches all exceptions internally and returns false rather than propagating them
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
      
      // Refresh timeline data
      await timelineState.refreshTimeline();
      
      // Small delay to ensure storage operations complete
      await Future.delayed(const Duration(milliseconds: 300));
      
      // IMPORTANT: Force reload emotions with two attempts for reliability
      todayState.emotionsLoaded = false; // Reset the flag to force reload
      await todayState.loadTodayEmotions();
      
      // Double check - retry emotions load if not successful
      if (todayState.todayEmotions.isEmpty) {
        debugPrint("⚠️ First emotion load attempt yielded no emotions, retrying...");
        await Future.delayed(const Duration(milliseconds: 300));
        todayState.emotionsLoaded = false;
        await todayState.loadTodayEmotions();
      }
      
      return true;
    } catch (e) {
      debugPrint('❌ Error during app initialization: $e');
      return false;
    }
  }
}