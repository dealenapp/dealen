import 'package:flutter/material.dart';
import 'highlighted_text.dart';

class AppText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  const AppText(
    this.text, {
    super.key,
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
  });

  @override
  Widget build(BuildContext context) {
    final defaultStyle = Theme.of(context).textTheme.bodyMedium ?? const TextStyle();

    return HighlightedText(
      text: text,
      normalStyle: (style ?? defaultStyle).copyWith(fontFamily: 'RobotoCondensed'),
      boldStyle: (style ?? defaultStyle).copyWith(
        fontWeight: FontWeight.bold,
        fontFamily: 'RobotoCondensed',
      ),
    );
  }
}
