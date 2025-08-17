import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/grammar_topic.dart';
import 'grammar_rule_screen.dart';
import 'grammar_test_screen.dart';

class GrammarDeScreen extends StatefulWidget {
  const GrammarDeScreen({super.key});

  @override
  State<GrammarDeScreen> createState() => _GrammarDeScreenState();
}

class _GrammarDeScreenState extends State<GrammarDeScreen> {
  List<GrammarTopic> topics = [];
  bool _loading = true;
  String? _error;

  final Map<String, Color> categoryColors = {
    "A1": Colors.green.shade100,
    "A2": Colors.lightGreen.shade100,
    "B1": Colors.yellow.shade100,
    "B2": Colors.purple.shade100,
    "C1": Colors.blue.shade100,
    "C2": Colors.blue.shade100,
  };

  final Map<String, Color> categoryTextColors = {
    "A1": Colors.green.shade800,
    "A2": Colors.lightGreen.shade800,
    "B1": Colors.orange.shade800,
    "B2": Colors.purple.shade800,
    "C1": Colors.blue.shade800,
    "C2": Colors.blue.shade800,
  };

  @override
  void initState() {
    super.initState();
    loadGrammarData();
  }

  Future<void> loadGrammarData() async {
    try {
      final String jsonString =
          await rootBundle.loadString('lib/data/degram.json');
      final dynamic decoded = json.decode(jsonString);

      final List<dynamic> listData;
      if (decoded is List) {
        listData = decoded;
      } else if (decoded is Map) {
        listData = [decoded];
      } else {
        listData = [];
      }

      final parsed = listData
          .where((e) => e is Map)
          .map((e) =>
              GrammarTopic.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList();

      setState(() {
        topics = parsed;
        _loading = false;
      });
    } catch (e, st) {
      debugPrint('Error loading degram.json: $e\n$st');
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (_error != null) {
      return Scaffold(body: Center(child: Text('Ошибка загрузки: $_error')));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Grammatik')),
      body: topics.isEmpty
          ? const Center(child: Text('Нет тем в degram.json'))
          : ListView.separated(
              itemCount: topics.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final topic = topics[index];
                final firstRule =
                    topic.rule.isNotEmpty ? topic.rule.first : null;

                final category = firstRule?.category ?? "";
                final bgColor = categoryColors[category] ?? Colors.grey.shade100;
                final textColor =
                    categoryTextColors[category] ?? Colors.black;

                return Container(
                  color: bgColor,
                  child: ListTile(
                    title: Text(
                      topic.theme 
                      // +
                      //     (category.isNotEmpty ? " [$category]" : "")
                          ,
                      style: TextStyle(
                        color: textColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    // subtitle: Text(
                    //   firstRule?.title ?? '',
                    //   style: TextStyle(color: textColor.withOpacity(0.8)),
                    // ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (topic.test.isNotEmpty)
                          IconButton(
                            icon: Icon(Icons.quiz, color: textColor),
                            tooltip: "Test",
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => GrammarTestScreen(
                                      questions: topic.test),
                                ),
                              );
                            },
                          ),
                        Icon(Icons.arrow_forward_ios,
                            size: 16, color: textColor),
                      ],
                    ),
                    onTap: () {
                      if (firstRule != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => GrammarRuleScreen(
                              rule: firstRule,
                              testQuestions: topic.test,
                            ),
                          ),
                        );
                      }
                    },
                  ),
                );
              },
            ),
    );
  }
}
