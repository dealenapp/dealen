// models/grammar_topic_en.dart
import 'grammar_table.dart';

class GrammarTopicEn {
  final String theme;
  final String category;
  final String description;
  final GrammarTable? table;
  final List<Map<String, String>> examples;

  GrammarTopicEn({
    required this.theme,
    required this.category,
    required this.description,
    this.table,
    required this.examples,
  });

  factory GrammarTopicEn.fromJson(Map<String, dynamic> json) {
    return GrammarTopicEn(
      theme: json['theme'] ?? '',
      category: json['category'] ?? '',
      description: json['description'] ?? '',
      table: json['table'] != null
          ? GrammarTable.fromJson(json['table'])
          : null,
      examples: (json['examples'] as List<dynamic>? ?? [])
          .map((e) => Map<String, String>.from(e))
          .toList(),
    );
  }
}
