import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/emotion.dart';

/// A customized chip widget that represents an emotion with visual styling based on 
/// the emotion's valence and arousal level.
///
/// The chip's appearance changes based on:
/// - Selection state (selected/unselected)
/// - Emotion properties (if provided):
///   - Valence (positive, neutral, negative) affects the base color
///   - Arousal level (high, medium, low) affects the color intensity
///
/// If no emotion is provided, default theme colors are used.
class EmotionChip extends StatelessWidget {
  /// The text displayed on the chip.
  final String label;
  
  /// Optional counter value that will be displayed as "(count)" when greater than 1.
  final int count;
  
  /// Whether this chip is in a selected state.
  /// When selected, the chip displays with different styling and a check icon.
  final bool selected;
  
  /// Optional widget to display before the label.
  final Widget? leading;
  
  /// Callback function that is called when the chip is tapped.
  final void Function()? onTap;
  
  /// Optional emotion model that determines the chip's color scheme.
  /// Colors will be based on the emotion's valence and arousal level.
  final Emotion? emotion;

  /// Creates an emotion chip.
  ///
  /// The [label] parameter is required and determines the text displayed on the chip.
  /// If [count] is greater than 1, it will be displayed as "label (count)".
  /// When [selected] is true, the chip will display with selection styling.
  /// The [onTap] callback is triggered when the chip is tapped.
  /// If an [emotion] is provided, the chip's color will be determined by its properties.
  const EmotionChip({
    super.key,
    required this.label,
    this.count = 0,
    this.selected = false,
    this.leading,
    this.onTap,
    this.emotion,
  });

  /// Builds the emotion chip widget with appropriate styling.
  ///
  /// The chip's appearance is determined by:
  /// - Selection state (border style, icon)
  /// - Emotion valence (color)
  /// - Emotion arousal level (opacity)
  @override
  Widget build(BuildContext context) {
    final displayLabel = count > 1 ? '$label ($count)' : label;
    final theme = Theme.of(context);
    
    // Default colors if selected or no emotion provided
    Color chipColor = selected ? theme.colorScheme.primaryContainer : theme.colorScheme.surfaceContainer;
    Color textColor = selected ? theme.colorScheme.onPrimaryContainer : theme.colorScheme.onSurfaceVariant;
    
    // If emotion is provided and not in selected state, use valence and arousal for color
    if (emotion != null) {
      final String valence = emotion!.valence;
      final String arousalLevel = emotion!.arousalLevel;
      
      // Set base color based on valence
      switch (valence) {
        case 'positive':
          chipColor = theme.colorScheme.tertiaryContainer;
          textColor = theme.colorScheme.onTertiaryContainer;
        case 'negative':
          chipColor = theme.colorScheme.errorContainer;
          textColor = theme.colorScheme.onErrorContainer;
        case 'neutral':
          chipColor = theme.colorScheme.onPrimary;
          textColor = theme.colorScheme.primary;
      }
      
      // Modify opacity based on arousal level
      double opacity;
      switch (arousalLevel) {
        case 'high':
          opacity = 1.0;  // Full intensity
        case 'low':
          opacity = 0.2;  // Muted intensity
        default:          
          opacity = 0.6;  // Standard intensity
      }
      
      chipColor = chipColor.withAlpha((255 * opacity).toInt());

    }

    // Define border style based on selection state
    BorderSide borderSide = selected 
        ? BorderSide(color: textColor, width: 2.0) 
        : BorderSide(color: chipColor, width: 2.0) ;

    return GestureDetector(
      onTap: onTap,
      child: Chip(
        avatar: selected ? Icon(
                Icons.check_circle,
                size: 18,
                color: textColor.withAlpha((255 * 0.5).toInt()),
              ) : Icon(
                Icons.circle_outlined,
                size: 18,
                color: textColor.withAlpha((255 * 0.5).toInt()),
              ),
        backgroundColor: chipColor,
        side: borderSide,
        label: Text(
          displayLabel,
          style: GoogleFonts.bricolageGrotesque(
            textStyle: theme.textTheme.bodyMedium,
            color: textColor,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}