import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../services/favorites_service.dart';
import '../services/tts_service_en.dart';

class DictionaryEnScreen extends StatefulWidget {
  @override
  _DictionaryEnScreenState createState() => _DictionaryEnScreenState();
}

class _DictionaryEnScreenState extends State<DictionaryEnScreen> {
  List<Map<String, dynamic>> allWords = [];
  String query = '';

  @override
  void initState() {
    super.initState();
    loadWords();
  }

  Future<void> loadWords() async {
    final data = await rootBundle.loadString('lib/data/engwords.json');
    final List<dynamic> themes = jsonDecode(data);

    // Собираем все слова из всех тем в один список с полем темы
    final List<Map<String, dynamic>> combined = [];
    for (var theme in themes) {
      final String themeName = theme['theme'] ?? '';
      final List<dynamic> words = theme['words'] ?? [];
      for (var word in words) {
        final Map<String, dynamic> wordMap = Map<String, dynamic>.from(word);
        wordMap['theme'] = themeName; // Добавляем название темы
        combined.add(wordMap);
      }
    }

    // Сортируем по алфавиту
    combined.sort((a, b) =>
        a['word'].toString().toLowerCase().compareTo(b['word'].toString().toLowerCase()));

    setState(() {
      allWords = combined;
    });
  }

  void search(String value) {
    setState(() {
      query = value.toLowerCase();
    });
  }

  Widget buildWordCard(Map<String, dynamic> word) {
    return FutureBuilder<bool>(
      future: FavoritesService.isFavoriteEn(word['word']),
      builder: (context, snapshot) {
        final isFav = snapshot.data ?? false;
        return Card(
          margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          child: ListTile(
            title: Text("${word['word']} — ${word['translation']}"),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if ((word['example'] ?? '').toString().isNotEmpty)
                  Text(word['example']),
                Text(
                  "Topic: ${word['theme']}",
                  style: TextStyle(fontStyle: FontStyle.italic, fontSize: 12),
                ),
              ],
            ),
            trailing: Wrap(
              spacing: 8,
              children: [
                IconButton(
                  icon: Icon(Icons.volume_up),
                  onPressed: () => TtsServiceEn.speak(
                      word['wordForSound'] ?? word['word']),
                ),
                IconButton(
                  icon: Icon(isFav ? Icons.star : Icons.star_border),
                  onPressed: () async {
                    await FavoritesService.toggleFavoriteEn(word);
                    setState(() {});
                  },
                )
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredWords = allWords.where((word) {
      final w = word['word'].toString().toLowerCase();
      final translation = (word['translation'] ?? '').toString().toLowerCase();
      final forms = (word['forms'] as List<dynamic>?)
              ?.map((f) => f.toString().toLowerCase())
              .toList() ??
          [];

      return w.contains(query) || translation.contains(query) || forms.any((f) => f.contains(query));
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Dictionary'),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8),
            child: TextField(
              onChanged: search,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Search...',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredWords.length,
              itemBuilder: (context, index) {
                return buildWordCard(filteredWords[index]);
              },
            ),
          )
        ],
      ),
    );
  }
}
