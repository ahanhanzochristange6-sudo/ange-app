import 'package:flutter/material.dart';
import '../core/theme.dart';

class GradientText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final Gradient gradient;
  const GradientText(this.text, {super.key, this.style, this.gradient = const LinearGradient(colors: [AppTheme.fireRed, AppTheme.gold])});

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => gradient.createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
      child: Text(text, style: (style ?? const TextStyle(color: Colors.white, fontSize: 20)).copyWith(color: Colors.white)),
    );
  }
}
