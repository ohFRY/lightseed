import 'package:flutter/material.dart';

/// Extension on BuildContext that provides simplified snackbar functionality.
///
/// This extension makes it easy to show snackbars throughout the app with
/// consistent styling and behavior. It supports error states, custom durations,
/// and persistent messages with dismissal actions.
extension SnackBarExtension on BuildContext {
  /// Shows a snackbar with the given message.
  ///
  /// Parameters:
  ///   [message] - The text content to display in the snackbar
  ///   [isError] - If true, styles the snackbar as an error (default: false)
  ///   [persistent] - If true, shows the snackbar indefinitely with a dismiss button (default: false)
  ///
  /// When [persistent] is true, the snackbar includes a "Dismiss" action button and
  /// remains visible until explicitly dismissed.
  void showSnackBar(String message, {bool isError = false, bool persistent = false}) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Theme.of(this).colorScheme.error : null,
        duration: persistent ? const Duration(days: 1) : const Duration(seconds: 4),
        action: persistent ? SnackBarAction(
          label: 'Dismiss',
          onPressed: () => ScaffoldMessenger.of(this).hideCurrentSnackBar(),
        ) : null,
      ),
    );
  }
}
