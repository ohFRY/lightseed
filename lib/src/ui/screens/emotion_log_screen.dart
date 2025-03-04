import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../logic/emotions_state.dart';
import '../../logic/timeline_state.dart';
import '../elements/emotion_chip.dart';
import '../../shared/extensions.dart';
import '../../models/emotion.dart';

/// A screen that allows users to select and log their current emotions.
/// 
/// This screen presents a grid of emotion chips that users can tap to select
/// multiple emotions they are currently feeling. Selected emotions can be saved
/// to the user's timeline by tapping the 'Save' button in the app bar.
class EmotionLogScreen extends StatelessWidget {
  const EmotionLogScreen({super.key});

  /// Sorts emotions based on valence (positive, neutral, negative) and arousal level.
  ///
  /// The sort order is:
  /// 1. Positive emotions (high arousal → medium arousal → low arousal)
  /// 2. Neutral emotions (high arousal → medium arousal → low arousal)
  /// 3. Negative emotions (low arousal → medium arousal → high arousal)
  ///
  /// For negative emotions, the arousal ordering is reversed compared to positive/neutral
  /// emotions to place milder negative emotions (like sadness) before intense ones (like rage).
  ///
  /// Returns a new sorted list without modifying the original list.
  List<Emotion> _sortEmotions(List<Emotion> emotions) {
    // Create a copy of the list to avoid modifying the original
    final sortedEmotions = List<Emotion>.from(emotions);
    
    sortedEmotions.sort((a, b) {
      // First, sort by valence (positive > neutral > negative)
      final valenceOrder = {
        'positive': 0,
        'neutral': 1,
        'negative': 2,
      };
      
      final valenceCompare = valenceOrder[a.valence]!.compareTo(valenceOrder[b.valence]!);
      if (valenceCompare != 0) return valenceCompare;
      
      // If valence is the same, sort by arousal level (high > medium > low)
      final arousalOrder = {
        'high': 0,
        'medium': 1,
        'low': 2,
      };
      
      // If we're comparing negative emotions, reverse the arousal order
      if (a.valence == 'negative') {
        // For negative emotions, we want low arousal first (like sadness)
        // then medium, then high arousal (like rage)
        return arousalOrder[b.arousalLevel]!.compareTo(arousalOrder[a.arousalLevel]!);
      } else {
        // For positive and neutral emotions, keep the original order
        return arousalOrder[a.arousalLevel]!.compareTo(arousalOrder[b.arousalLevel]!);
      }
    });
    
    return sortedEmotions;
  }

  /// Builds the emotion log screen UI.
  ///
  /// Displays a grid of selectable emotion chips and a save button in the app bar
  /// that adds the selected emotions to the timeline when pressed.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => EmotionsState(),
      builder: (context, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('I\'m feeling...', textAlign: TextAlign.center),
            actions: [
              TextButton(
                onPressed: () async {
                  final emotionsState = context.read<EmotionsState>();
                  final timelineState = context.read<TimelineState>();
                  
                  final formattedEmotionNames = emotionsState.getFormattedEmotionNames();
                  
                  await timelineState.addEmotionLog(
                    emotionsState.selectedEmotionIds.toList(),
                    'felt $formattedEmotionNames',
                  );
                  if (!context.mounted) return;
                  Navigator.of(context).pop();
                },
                child: const Text('Save'),
              ),
            ],
          ),
          body: Consumer<EmotionsState>(
            builder: (context, emotionsState, child) {
              if (emotionsState.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (emotionsState.hasError) {
                return const Center(child: Text('Error loading emotions'));
              }
              
              // Sort emotions by valence and arousal level
              final sortedEmotions = _sortEmotions(emotionsState.emotions);
              
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return Center(
                          child: Container(
                            width: constraints.maxWidthForContent,
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: SingleChildScrollView(
                              child: Wrap(
                                spacing: 8.0,
                                runSpacing: 4.0,
                                alignment: WrapAlignment.spaceBetween,
                                children: sortedEmotions.map((emotion) {
                                  final isSelected = emotionsState.selectedEmotionIds.contains(emotion.id);
                                  return EmotionChip(
                                    label: emotion.name,
                                    selected: isSelected,
                                    leading: isSelected ? const Icon(Icons.check) : null,
                                    onTap: () => emotionsState.toggleSelection(emotion.id),
                                    emotion: emotion,
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}