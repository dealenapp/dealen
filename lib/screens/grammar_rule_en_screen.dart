// screens/grammar_rule_en_screen.dart
import 'package:flutter/material.dart';
import '../models/grammar_topic_en.dart';
import '../models/grammar_table.dart';

class GrammarRuleEnScreen extends StatelessWidget {
  final GrammarTopicEn topic;

  const GrammarRuleEnScreen({super.key, required this.topic});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: Text(topic.theme)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                topic.description,
                style: theme.textTheme.bodyMedium?.copyWith(fontSize: 16),
              ),
              const SizedBox(height: 16),
              if (topic.examples.isNotEmpty) ...[
                Text(
                  "Examples:",
                  style: theme.textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                ...topic.examples.map(
                  (ex) => Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      ex['en'] ?? '',
                      style: theme.textTheme.bodyMedium?.copyWith(fontSize: 15),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
              if (topic.table != null) ...[
                Text(
                  "Table:",
                  style: theme.textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                _buildTable(topic.table!, isDark, theme),
              ],
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
