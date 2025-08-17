// screens/grammar_en_screen.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/grammar_topic_en.dart';
import 'grammar_rule_en_screen.dart';

class GrammarEnScreen extends StatefulWidget {
  const GrammarEnScreen({super.key});

  @override
  State<GrammarEnScreen> createState() => _GrammarEnScreenState();
}

class _GrammarEnScreenState extends State<GrammarEnScreen> {
  List<GrammarTopicEn> topics = [];
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
          await rootBundle.loadString('lib/data/enggram.json');
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
          .map((e) => GrammarTopicEn.fromJson(Map<String, dynamic>.from(e)))
          .toList();

      setState(() {
        topics = parsed;
        _loading = false;
      });
    } catch (e, st) {
      debugPrint('Error loading enggram.json: $e\n$st');
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
      return Scaffold(body: Center(child: Text('Error loading: $_error')));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('English Grammar')),
      body: topics.isEmpty
          ? const Center(child: Text('No topics in enggram.json'))
          : ListView.separated(
              itemCount: topics.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final topic = topics[index];
                final bgColor =
                    categoryColors[topic.category] ?? Colors.grey.shade100;
                final textColor =
                    categoryTextColors[topic.category] ?? Colors.black;

                return Container(
                  color: bgColor,
                  child: ListTile(
                    title: Text(
                      topic.theme,
                      style: TextStyle(
                        color: textColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    trailing: Icon(Icons.arrow_forward_ios,
                        size: 16, color: textColor),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => GrammarRuleEnScreen(topic: topic),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}
