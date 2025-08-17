class WordModel {
  final String word;
  final String translation;
  final String example;
  final String wordForSound;

  WordModel({
    required this.word,
    required this.translation,
    required this.example,
    required this.wordForSound,
  });

  factory WordModel.fromJson(Map<String, dynamic> json) {
    return WordModel(
      word: json['word'] ?? '',
      translation: json['translation'] ?? '',
      example: json['example'] ?? '',
      wordForSound: json['wordForSound'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'word': word,
      'translation': translation,
      'example': example,
      'wordForSound': wordForSound,
    };
  }
}

class ThemeModel {
  final String theme;
  final String icon;
  final List<WordModel> words;

  ThemeModel({
    required this.theme,
    required this.icon,
    required this.words,
  });

  factory ThemeModel.fromJson(Map<String, dynamic> json) {
    return ThemeModel(
      theme: json['theme'] ?? '',
      icon: json['icon'] ?? '',
      words: (json['words'] as List<dynamic>? ?? [])
          .map((e) => WordModel.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'theme': theme,
      'icon': icon,
      'words': words.map((e) => e.toJson()).toList(),
    };
  }
}
