import 'package:flutter/material.dart';
import '../models/grammar_rule.dart';
import '../models/grammar_test_question.dart';
import 'grammar_test_screen.dart';

class GrammarRuleScreen extends StatelessWidget {
  final GrammarRule rule;
  final List<GrammarTestQuestion> testQuestions;

  const GrammarRuleScreen({
    super.key,
    required this.rule,
    required this.testQuestions,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: Text(rule.title)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                rule.description,
                style: theme.textTheme.bodyMedium?.copyWith(fontSize: 16),
              ),
              const SizedBox(height: 16),
              if (rule.examples.isNotEmpty) ...[
                Text(
                  "Beispiele:",
                  style: theme.textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                ...rule.examples.map(
                  (ex) => Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      ex['de'] ?? '',
                      style: theme.textTheme.bodyMedium?.copyWith(fontSize: 15),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
              if (rule.table != null) ...[
                Text(
                  "Tabelle:",
                  style: theme.textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                _buildTable(rule.table!, isDark, theme),
                const SizedBox(height: 16),
              ],
              if (testQuestions.isNotEmpty)
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              GrammarTestScreen(questions: testQuestions),
                        ),
                      );
                    },
                    child: const Text("Test zum Thema"),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTable(GrammarTable table, bool isDark, ThemeData theme) {
    final borderColor =
        isDark ? Colors.grey.shade700 : Colors.grey.shade400;
    final headerColor =
        isDark ? Colors.grey.shade800 : Colors.grey.shade200;

    return Table(
      border: TableBorder.all(color: borderColor),
      columnWidths: const {},
      children: [
        TableRow(
          decoration: BoxDecoration(color: headerColor),
          children: table.headers
              .map((header) => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      header,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ))
              .toList(),
        ),
        ...table.rows.map(
          (row) => TableRow(
            children: row
                .map((cell) => Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(cell, style: theme.textTheme.bodyMedium),
                    ))
                .toList(),
          ),
        )
      ],
    );
  }
}
