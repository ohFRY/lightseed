import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:lightseed/src/shared/extensions.dart';

class AnimatedTextCard extends StatefulWidget {
  final String text;
  final IconData icon;
  final VoidCallback onIconPressed;
  final bool animationPlayed; // Add a flag to track if the animation has played
  final VoidCallback onAnimationFinished; // Add a callback function

  const AnimatedTextCard({
    required this.text,
    required this.icon,
    required this.onIconPressed,
    required this.animationPlayed, // Receive the animation state
    required this.onAnimationFinished, // Receive the callback
    super.key,
  });

  @override
  State<AnimatedTextCard> createState() => _AnimatedTextCardState();
}

class _AnimatedTextCardState extends State<AnimatedTextCard> with AutomaticKeepAliveClientMixin {
  bool isTextVisible = false;

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context); // Call super.build to ensure that the mixin is working correctly
    final theme = Theme.of(context);

    final style = theme.textTheme.displaySmall;
    final stylelabel = theme.textTheme.bodySmall;

    return Center(
      child: SizedBox(
        width: 600, // Set a fixed width to align with other elements
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Stack(
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: 25, // Fixed height for both states
                      child: AnimatedCrossFade(
                        duration: const Duration(milliseconds: 300),
                        crossFadeState: isTextVisible ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                        firstChild: SizedBox(height: 25),
                        secondChild: FittedBox(
                          fit: BoxFit.fitWidth,
                          child: Center(
                            child: Text(
                              "Repeat the following 3 times",
                              style: stylelabel,
                            ),
                          ),
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
                          height: textHeight,
                          width: constraints.isMobile
                              ? constraints.maxWidth
                              : constraints.maxWidth / 2,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 48.0, vertical: 20.0), // Reduce vertical padding
                            child: widget.animationPlayed // Use the flag passed from MyMainScreen
                                ? Text(widget.text.toString(), style: style)
                                : AnimatedTextKit(
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
                                      widget.onAnimationFinished(); // Call the callback function
                                    },
                                    key: ValueKey(widget.text),
                                  ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: IconButton(
                    onPressed: widget.onIconPressed,
                    icon: Icon(widget.icon),
                    tooltip: "Save",
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}