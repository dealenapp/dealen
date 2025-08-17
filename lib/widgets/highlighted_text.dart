import 'package:flutter/material.dart';

class HighlightedText extends StatelessWidget {
  final String text;
  final TextStyle? normalStyle;
  final TextStyle? boldStyle;

  const HighlightedText({
    super.key,
    required this.text,
    this.normalStyle,
    this.boldStyle,
  });

  @override
  Widget build(BuildContext context) {
    final baseStyle = normalStyle ??
        TextStyle(fontFamily: 'RobotoCondensed', fontSize: 16);
    final bold = boldStyle ??
        TextStyle(
          fontFamily: 'RobotoCondensed',
          fontSize: 16,
          fontWeight: FontWeight.bold,
        );

    final regex = RegExp(r'\*\*(.+?)\*\*');
    final spans = <TextSpan>[];
    int lastMatchEnd = 0;

    for (final match in regex.allMatches(text)) {
      // обычный текст перед выделением
      if (match.start > lastMatchEnd) {
        spans.add(TextSpan(
          text: text.substring(lastMatchEnd, match.start),
          style: baseStyle,
        ));
      }
      // выделенный жирный текст
      spans.add(TextSpan(
        text: match.group(1),
        style: bold,
      ));
      lastMatchEnd = match.end;
    }

    // остаток текста
    if (lastMatchEnd < text.length) {
      spans.add(TextSpan(
        text: text.substring(lastMatchEnd),
        style: baseStyle,
      ));
    }

    return RichText(
      text: TextSpan(children: spans),
    );
  }
}
