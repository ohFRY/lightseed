import 'package:flutter/material.dart';

class BigCard extends StatelessWidget {
  final String text;

  const BigCard({required this.text, super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final style = theme.textTheme.headlineMedium!.copyWith(
      color: theme.colorScheme.onTertiary,
    );

    return Card(
      color: theme.colorScheme.tertiary,
      child: Padding(
        padding: const EdgeInsets.all(48.0), 
        child: Text(
          text.toString(),
          style: style
        ),
      ),
    );
  }
}