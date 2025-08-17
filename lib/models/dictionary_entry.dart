class DictionaryEntry {
  final String category;
  final String deWord;
  final String engWord;
  final String rusWord;
  final String example;
  final String partOfSpeech;
  final String? article;
  final String? pluralForm;
  final String? presentVerb;
  final String? pastVerb;
  final String? perfectVerb;
  final String? prepositions;

  DictionaryEntry({
    required this.category,
    required this.deWord,
    required this.engWord,
    required this.rusWord,
    required this.example,
    required this.partOfSpeech,
    this.article,
    this.pluralForm,
    this.presentVerb,
    this.pastVerb,
    this.perfectVerb,
    this.prepositions,
  });

  factory DictionaryEntry.fromJson(Map<String, dynamic> json) {
    return DictionaryEntry(
      category: json['Category'] ?? '',
      deWord: json['DeWord'] ?? '',
      engWord: json['EngWord'] ?? '',
      rusWord: json['RusWord'] ?? '',
      example: json['Example'] ?? '',
      partOfSpeech: json['PartOfSpeech'] ?? '',
      article: json['Article'],
      pluralForm: json['PluralForm'],
      presentVerb: json['PresentVerb'],
      pastVerb: json['PastVerb'],
      perfectVerb: json['PerfectVerb'],
      prepositions: json['Prepositions'],
    );
  }
}
