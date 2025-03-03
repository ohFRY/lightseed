import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../logic/emotions_state.dart';
import '../../logic/timeline_state.dart';
import '../elements/emotion_chip.dart';
import '../../shared/extensions.dart';

class EmotionLogScreen extends StatelessWidget {
  const EmotionLogScreen({super.key});

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
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return Center(
                          child: Container(
                            width: constraints.maxWidthForContent,
                            padding: const EdgeInsets.all(8.0),
                            child: SingleChildScrollView(
                              child: Wrap(
                                spacing: 8.0,
                                runSpacing: 4.0,
                                children: emotionsState.emotions.map((emotion) {
                                  final isSelected = emotionsState.selectedEmotionIds.contains(emotion.id);
                                  return EmotionChip(
                                    label: emotion.name,
                                    selected: isSelected,
                                    leading: isSelected ? const Icon(Icons.check) : null,
                                    onTap: () => emotionsState.toggleSelection(emotion.id),
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