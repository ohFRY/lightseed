import 'package:flutter/material.dart';

extension ShowSnackBar on BuildContext {
  void showSnackBar(
    String message, {
    bool isError = false,
    bool persistent = false,
  }) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: persistent 
            ? const Duration(days: 365) 
            : const Duration(seconds: 4),
        backgroundColor: isError 
            ? Theme.of(this).colorScheme.error
            : null,
      ),
    );
  }
}