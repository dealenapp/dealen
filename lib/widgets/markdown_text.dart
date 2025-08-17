import 'package:flutter/material.dart';

class MarkdownText extends StatelessWidget {
  final String text;
  final TextStyle? style;

  const MarkdownText(this.text, {super.key, this.style});

  @override
  Widget build(BuildContext context) {
    final normalStyle = style ?? Theme.of(context).textTheme.bodyMedium!;
    final boldStyle = normalStyle.copyWith(fontWeight: FontWeight.bold);

    final spans = <TextSpan>[];
    final regex = RegExp(r'\*\*(.+?)\*\*');
    int lastMatchEnd = 0;

    for (final match in regex.allMatches(text)) {
      if (match.start > lastMatchEnd) {
        spans.add(TextSpan(text: text.substring(lastMatchEnd, match.start), style: normalStyle));
      }
      spans.add(TextSpan(text: match.group(1), style: boldStyle));
      lastMatchEnd = match.end;
    }

    if (lastMatchEnd < text.length) {
      spans.add(TextSpan(text: text.substring(lastMatchEnd), style: normalStyle));
    }

    return RichText(text: TextSpan(children: spans));
  }
}
