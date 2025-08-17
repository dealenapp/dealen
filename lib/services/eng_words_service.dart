import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class EngWordsService {
  static Future<List<Map<String, dynamic>>> loadThemes() async {
    final jsonString = await rootBundle.loadString('lib/data/engwords.json');
    final List<dynamic> data = json.decode(jsonString);
    return data.map((e) => e as Map<String, dynamic>).toList();
  }
}
