class GrammarRule {
  final String id;
  final String category;
  final String title;
  final String description;
  final List<Map<String, String>> examples;
  final GrammarTable? table;

  GrammarRule({
    required this.id,
    required this.category,
    required this.title,
    required this.description,
    required this.examples,
    this.table,
  });

  factory GrammarRule.fromJson(Map<String, dynamic> json) {
    return GrammarRule(
      id: json['id'] ?? '',
      category: json['category'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      examples: (json['examples'] as List<dynamic>? ?? [])
          .map((e) => Map<String, String>.from(e))
          .toList(),
      table: json['table'] != null ? GrammarTable.fromJson(json['table']) : null,
    );
  }
}

class GrammarTable {
  final List<String> headers;
  final List<List<String>> rows;

  GrammarTable({required this.headers, required this.rows});

  factory GrammarTable.fromJson(Map<String, dynamic> json) {
    return GrammarTable(
      headers: List<String>.from(json['headers'] ?? []),
      rows: (json['rows'] as List<dynamic>? ?? [])
          .map((row) => List<String>.from(row))
          .toList(),
    );
  }
}
