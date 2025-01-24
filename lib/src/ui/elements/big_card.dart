import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:lightseed/src/shared/extensions.dart';

class AnimatedTextCard extends StatefulWidget {
  final String text;

  const AnimatedTextCard({required this.text, super.key});

  @override
  State<AnimatedTextCard> createState() => _AnimatedTextCardState();
}

class _AnimatedTextCardState extends State<AnimatedTextCard> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final style = theme.textTheme.displayMedium;
    final stylelabel = theme.textTheme.bodySmall;

    return Column(
      children: [
        Text("Repeat the following 3 times", style: stylelabel,),
        LayoutBuilder(
          builder: (context, constraints) {
            final textSpan = TextSpan(
              text: widget.text.toString(),
              style: style,
            );

            final textPainter = TextPainter(
              text: textSpan,
              textDirection: TextDirection.ltr,
              maxLines: null,
            );
          
            textPainter.layout(maxWidth: (constraints.isMobile? constraints.maxWidth : constraints.maxWidth/2) - 96.0); // Subtract padding

            final textHeight = textPainter.size.height;

        return SizedBox(
          height: textHeight+96,
          width: constraints.isMobile? constraints.maxWidth : constraints.maxWidth/2,
          child: Padding(
            padding: const EdgeInsets.all(48.0), 
            child: 
              AnimatedTextKit(
              animatedTexts: [
                TyperAnimatedText(
                  widget.text.toString(),
                  textStyle: style,
                  speed: const Duration(milliseconds: 70)
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
          },
        ),
      ],
    );
  }
}