import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../services/favorites_service.dart';
import '../services/tts_service.dart';

class DictionaryDeScreen extends StatefulWidget {
  @override
  _DictionaryDeScreenState createState() => _DictionaryDeScreenState();
}

class _DictionaryDeScreenState extends State<DictionaryDeScreen> {
  List<Map<String, dynamic>> words = [];
  List<Map<String, dynamic>> filtered = [];
  String query = '';

  @override
  void initState() {
    super.initState();
    loadWords();
  }

  Future<void> loadWords() async {
    final data = await rootBundle.loadString('lib/data/a1c1.json');
    final List parsed = jsonDecode(data);
    final loadedWords = parsed.map((e) => Map<String, dynamic>.from(e)).toList();

    loadedWords.sort((a, b) {
      return a['DeWord'].toString().toLowerCase()
          .compareTo(b['DeWord'].toString().toLowerCase());
    });

    setState(() {
      words = loadedWords;
      filtered = List.from(words);
    });
  }

  void search(String value) {
    setState(() {
      query = value.toLowerCase();

      filtered = words.where((word) {
        final de = (word['DeWord'] ?? '').toString().toLowerCase();
        final plural = (word['PluralForm'] ?? '').toString().toLowerCase();
        final pres = (word['PresentVerb'] ?? '').toString().toLowerCase();
        final past = (word['PastVerb'] ?? '').toString().toLowerCase();
        final perf = (word['PerfectVerb'] ?? '').toString().toLowerCase();
        final prep = (word['Prepositions'] ?? '').toString().toLowerCase();
        final art = (word['Article'] ?? '').toString().toLowerCase();
        final rus = (word['RusWord'] ?? '').toString().toLowerCase();

        return de.contains(query) ||
               plural.contains(query) ||
               pres.contains(query) ||
               past.contains(query) ||
               perf.contains(query) ||
               prep.contains(query) ||
               art.contains(query) ||
               rus.contains(query);
      }).toList();

      filtered.sort((a, b) {
        return a['DeWord'].toString().toLowerCase()
            .compareTo(b['DeWord'].toString().toLowerCase());
      });
    });
  }

  Widget buildWordCard(Map<String, dynamic> word) {
    return FutureBuilder<bool>(
      future: FavoritesService.isFavoriteDe(word['DeWord']),
      builder: (context, snapshot) {
        final isFav = snapshot.data ?? false;
        return Card(
          margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          child: ListTile(
            title: Text("🇩🇪 ${word['DeWord']} — ${word['RusWord']}"),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(" 🇺🇸 ${word['EngWord']}"),
                if (word['Example'] != null) Text("📖 ${word['Example']}"),
                if (word['Article'] != null) Text("Artikel: ${word['Article']}"),
                if (word['PluralForm'] != null) Text("Plural: ${word['PluralForm']}"),
                if (word['PresentVerb'] != null) Text("Präsens: ${word['PresentVerb']}"),
                if (word['PastVerb'] != null) Text("Präteritum: ${word['PastVerb']}"),
                if (word['PerfectVerb'] != null) Text("Perfekt: ${word['PerfectVerb']}"),
                if (word['Prepositions'] != null) Text("Präpositionen: ${word['Prepositions']}"),
              ],
            ),
            trailing: Wrap(
              spacing: 8,
              children: [
                IconButton(
                  icon: Icon(Icons.volume_up),
                  onPressed: () => TtsService.speak(word['DeWord']),
                ),
                IconButton(
                  icon: Icon(isFav ? Icons.star : Icons.star_border),
                  onPressed: () async {
                    await FavoritesService.toggleFavoriteDe(word);
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Wörterbuch'),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8),
            child: TextField(
              onChanged: search,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Suchen...',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filtered.length,
              itemBuilder: (context, index) {
                return buildWordCard(filtered[index]);
              },
            ),
          )
        ],
      ),
    );
  }
}
