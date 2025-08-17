import 'package:flutter/material.dart';
import '../services/favorites_service.dart';
import '../services/tts_service.dart';

class FavoritesDeScreen extends StatefulWidget {
  @override
  _FavoritesDeScreenState createState() => _FavoritesDeScreenState();
}

class _FavoritesDeScreenState extends State<FavoritesDeScreen> {
  List<Map<String, dynamic>> favorites = [];
  List<Map<String, dynamic>> filtered = [];
  String query = '';

  @override
  void initState() {
    super.initState();
    loadFavorites();
  }

  Future<void> loadFavorites() async {
    final favs = await FavoritesService.getFavoritesDe();
    setState(() {
      favorites = favs;
      filtered = List.from(favs);
    });
  }

  void search(String value) {
    setState(() {
      query = value.toLowerCase();

      filtered = favorites.where((word) {
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
    });
  }

  Widget buildWordCard(Map<String, dynamic> word) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: ListTile(
        title: Text("${word['DeWord']} — ${word['RusWord']}"),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("🇺🇸 ${word['EngWord']}", style: const TextStyle(fontStyle: FontStyle.italic)),
            if (word['Example'] != null) Text("📖 ${word['Example']}"),
            if (word['Article'] != null) Text("Artikel: ${word['Article']}"),
            if (word['PluralForm'] != null) Text("Pluralform: ${word['PluralForm']}"),
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
              icon: const Icon(Icons.volume_up),
              onPressed: () => TtsService.speak(word['DeWord']),
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () async {
                await FavoritesService.toggleFavoriteDe(word);
                await loadFavorites();
              },
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorisierte Wörter'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextField(
              onChanged: search,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Suchen...',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: filtered.isEmpty
                ? const Center(child: Text('Keine Favoriten vorhanden'))
                : ListView.builder(
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
