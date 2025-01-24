import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';

class BigCard extends StatefulWidget {
  final String text;

  const BigCard({required this.text, super.key});

  @override
  State<BigCard> createState() => _BigCardState();
}

class _BigCardState extends State<BigCard> {
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
              widget.text.toString(),
              textStyle: style,
              speed: const Duration(milliseconds: 100),
            ),
          ],
          
          //totalRepeatCount: 1,
          //pause: const Duration(milliseconds: 100),
          displayFullTextOnTap: true,
          //stopPauseOnTap: true,
          repeatForever: false,
          isRepeatingAnimation: false,
          key: ValueKey(widget.text),
        ),
      ),
    );
  }
}