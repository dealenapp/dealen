import 'grammar_rule.dart';
import 'grammar_test_question.dart';

class GrammarTopic {
  final String theme;
  final List<GrammarRule> rule;
  final List<GrammarTestQuestion> test;

  GrammarTopic({
    required this.theme,
    required this.rule,
    required this.test,
  });

  factory GrammarTopic.fromJson(Map<String, dynamic> json) {
    return GrammarTopic(
      theme: json['theme'] ?? '',
      rule: (json['rule'] as List<dynamic>? ?? [])
          .map((e) => GrammarRule.fromJson(e))
          .toList(),
      test: (json['test'] as List<dynamic>? ?? [])
          .map((e) => GrammarTestQuestion.fromJson(e))
          .toList(),
    );
  }
}
