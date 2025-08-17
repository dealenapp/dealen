class Question {
  final String question;
  final List<String> options;
  final String correct;

  Question({
    required this.question,
    required this.options,
    required this.correct,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      question: json['question'] ?? '',
      options: List<String>.from(json['options'] ?? []),
      correct: json['correct'] ?? '',
    );
  }
}
