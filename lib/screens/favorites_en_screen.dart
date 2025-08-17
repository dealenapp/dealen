import 'package:flutter/material.dart';
import '../services/favorites_service.dart';
import '../services/tts_service_en.dart';

class FavoritesEnScreen extends StatefulWidget {
  @override
  _FavoritesEnScreenState createState() => _FavoritesEnScreenState();
}

class _FavoritesEnScreenState extends State<FavoritesEnScreen> {
  List<Map<String, dynamic>> favorites = [];
  List<Map<String, dynamic>> filtered = [];
  String query = '';

  @override
  void initState() {
    super.initState();
    loadFavorites();
  }

  Future<void> loadFavorites() async {
    final favs = await FavoritesService.getFavoritesEn(); // English method
    setState(() {
      favorites = favs;
      filtered = List.from(favs);
    });
  }

  void search(String value) {
    setState(() {
      query = value.toLowerCase();

      filtered = favorites.where((word) {
        final w = word['word'].toString().toLowerCase();
        final translation = (word['translation'] ?? '').toString().toLowerCase();
        final forms = (word['forms'] as List<dynamic>?)
                ?.map((f) => f.toString().toLowerCase())
                .toList() ??
            [];

        return w.contains(query) ||
               translation.contains(query) ||
               forms.any((f) => f.contains(query));
      }).toList();
    });
  }

  Widget buildWordCard(Map<String, dynamic> word) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: ListTile(
        title: Text("${word['word']} — ${word['translation']}"),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (word['example'] != null && word['example'].isNotEmpty)
              Text("📖 ${word['example']}"),
          ],
        ),
        trailing: Wrap(
          spacing: 8,
          children: [
            IconButton(
              icon: const Icon(Icons.volume_up),
              onPressed: () => TtsServiceEn.speak(word['wordForSound'] ?? word['word']),
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () async {
                await FavoritesService.toggleFavoriteEn(word); // English method
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
        title: const Text('Favorites'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextField(
              onChanged: search,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Search...',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: filtered.isEmpty
                ? const Center(child: Text('No favorite words'))
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
