import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';

class FadeInAnimatedText extends AnimatedText {
  /// Marks ending of fade-in interval, default value = 0.5
  final double fadeInEnd;

  FadeInAnimatedText(
    String text, {
    super.textAlign,
    super.textStyle,
    super.duration = const Duration(milliseconds: 2000),
    this.fadeInEnd = 0.5,
  }) : super(
          text: text,
        );

  late Animation<double> _fadeIn;

  @override
  void initAnimation(AnimationController controller) {
    _fadeIn = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(0.0, fadeInEnd),
      ),
    );
  }

  @override
  Widget animatedBuilder(BuildContext context, Widget? child) {
    return Opacity(
      opacity: _fadeIn.value,
      child: textWidget(text),
    );
  }
}