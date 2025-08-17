import 'question.dart';

class Topic {
  final String id;
  final String theme;
  final String rule;
  final List<String> examples;
  final List<Question> test;

  Topic({
    required this.id,
    required this.theme,
    required this.rule,
    required this.examples,
    required this.test,
  });

  factory Topic.fromJson(Map<String, dynamic> json) {
    return Topic(
      id: json['id'] ?? '',
      theme: json['theme'] ?? '',
      rule: json['rule'] ?? '',
      examples: List<String>.from(json['examples'] ?? []),
      test: (json['test'] as List<dynamic>?)
              ?.map((e) => Question.fromJson(e))
              .toList() ??
          [],
    );
  }
}
