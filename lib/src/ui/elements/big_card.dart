import 'package:flutter/material.dart';

class BigCard extends StatelessWidget {
  final String text;

  const BigCard({required this.text, super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
    );

    return Card(
      color: theme.colorScheme.primary,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Text(
          text.toString(),
          style: style ),
      ),
    );
  }
}