import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';

class BigCard extends StatelessWidget {
  final String text;

  const BigCard({required this.text, super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final style = theme.textTheme.displayMedium;

    return Card(
      
      child: Padding(
        padding: const EdgeInsets.all(48.0), 
        child: 
          AnimatedTextKit(
          animatedTexts: [
            TypewriterAnimatedText(
              text.toString(),
              textStyle: style,
              speed: const Duration(milliseconds: 100),
            ),
          ],
          
          //totalRepeatCount: 4,
          //pause: const Duration(milliseconds: 100),
          displayFullTextOnTap: true,
          //stopPauseOnTap: true,
          //repeatForever: true,
        ),
      ),
    );
  }
}