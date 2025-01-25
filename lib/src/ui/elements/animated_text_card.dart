import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:lightseed/src/shared/extensions.dart';
import 'package:lightseed/src/ui/elements/fadein_animated_text.dart';

class AnimatedTextCard extends StatefulWidget {
  final String text;

  const AnimatedTextCard({required this.text, super.key});

  @override
  State<AnimatedTextCard> createState() => _AnimatedTextCardState();
}

class _AnimatedTextCardState extends State<AnimatedTextCard> {
  bool isTextVisible = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final style = theme.textTheme.displayMedium;
    final stylelabel = theme.textTheme.bodySmall;

    return Column(
      children: [
        if (!isTextVisible) SizedBox(height: 20)
        else
          SizedBox(
            height: 20,
            child: Center(
              child: AnimatedTextKit(
                animatedTexts: [
                  FadeInAnimatedText(
                    "Repeat the following 3 times",
                    textStyle: stylelabel,
                  ),
                ],
                totalRepeatCount: 1,
                repeatForever: false,
                isRepeatingAnimation: false,
              ),
            ),
          ),
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

            textPainter.layout(
                maxWidth: (constraints.isMobile
                        ? constraints.maxWidth
                        : constraints.maxWidth / 2) -
                    96.0); // Subtract padding

            final textHeight = textPainter.size.height;

            return SizedBox(
              height: textHeight + 96,
              width: constraints.isMobile
                  ? constraints.maxWidth
                  : constraints.maxWidth / 2,
              child: Padding(
                padding: const EdgeInsets.all(48.0),
                child: AnimatedTextKit(
                  animatedTexts: [
                    TyperAnimatedText(widget.text.toString(),
                        textStyle: style,
                        speed: const Duration(milliseconds: 70)),
                  ],
                  displayFullTextOnTap: true,
                  repeatForever: false,
                  isRepeatingAnimation: false,
                  onFinished: () {
                    setState(() {
                      isTextVisible = true;
                    });
                  },
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
