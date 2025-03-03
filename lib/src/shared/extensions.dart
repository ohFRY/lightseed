import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

extension BreakpointUtils on BoxConstraints {
  bool get isTablet => maxWidth > 730;
  bool get isDesktop => maxWidth > 1200;
  bool get isMobile => !isTablet && !isDesktop;

  double get maxWidthForContent {
    if (isDesktop) {
      return 800.0; // Set desired max width for desktop here
    }
    return double.infinity;
  }
}

extension NetworkExtensions on BuildContext {
  /// Checks if the Supabase server is reachable.
  Future<bool> checkServerHealth() async {
    try {
      final healthCheck = await Supabase.instance.client
          .from('health_checks')
          .select()
          .limit(1)
          .maybeSingle()
          .timeout(const Duration(seconds: 5));
      return (healthCheck != null);
    } catch (e) {
      return false;
    }
  }

  /// Shows a persistent offline snackbar.
  void showOfflineSnackbar({String? message}) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message ?? "No connection. Features are unavailable."),
        duration: const Duration(days: 1),
        action: SnackBarAction(
          label: 'Dismiss',
          onPressed: () => ScaffoldMessenger.of(this).hideCurrentSnackBar(),
        ),
      ),
    );
  }
}