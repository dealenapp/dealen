class GrammarTable {
  final List<String> headers;
  final List<List<String>> rows;

  GrammarTable({
    required this.headers,
    required this.rows,
  });

  factory GrammarTable.fromJson(Map<String, dynamic> json) {
    return GrammarTable(
      headers: (json['headers'] as List<dynamic>? ?? []).cast<String>(),
      rows: (json['rows'] as List<dynamic>? ?? [])
          .map((row) => (row as List<dynamic>).cast<String>())
          .toList(),
    );
  }
}
