import 'package:flutter/material.dart';

extension SnackBarExtension on BuildContext {
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
