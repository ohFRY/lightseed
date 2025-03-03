import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EmotionChip extends StatelessWidget {
  final String label;
  final int count;
  final bool selected;
  final Widget? leading;
  final void Function()? onTap;

  const EmotionChip({
    super.key,
    required this.label,
    this.count = 0,
    this.selected = false,
    this.leading,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final displayLabel = count > 1 ? '$label ($count)' : label;
    final theme = Theme.of(context);
    final selectedColor = theme.colorScheme.onSecondary;

    return GestureDetector(
      onTap: onTap,
      child: Chip(
        avatar: leading,
        label: Text(
          displayLabel,
          style: GoogleFonts.bricolageGrotesque(
            textStyle: theme.textTheme.bodyMedium,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: selected ? selectedColor : null,
      ),
    );
  }
}