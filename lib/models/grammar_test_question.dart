class GrammarTestQuestion {
  final String question;
  final List<String> options;
  final int correctIndex;

  GrammarTestQuestion({
    required this.question,
    required this.options,
    required this.correctIndex,
  });

  factory GrammarTestQuestion.fromJson(Map<String, dynamic> json) {
    return GrammarTestQuestion(
      question: json['question'] ?? '',
      options: List<String>.from(json['options'] ?? []),
      correctIndex: json['correctIndex'] ?? 0,
    );
  }
}
