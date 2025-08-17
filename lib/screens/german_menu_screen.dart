import 'package:flutter/material.dart';

class GermanMenuScreen extends StatelessWidget {
  const GermanMenuScreen({super.key});

  // Liste der Menüpunkte mit Titeln und Routen
  final List<Map<String, dynamic>> options = const [
    {'title': 'Wörterbuch', 'route': '/dictionary_de', 'icon': Icons.book},
    {'title': 'Grammatik', 'route': '/grammar_de', 'icon': Icons.menu_book},
    {'title': 'Artikel (Spiel)', 'route': '/game_articles', 'icon': Icons.gamepad},
    {'title': 'Übersetzung (Spiel)', 'route': '/game_translation', 'icon': Icons.translate},
    {'title': 'Favorisierte Wörter', 'route': '/favorites_de', 'icon': Icons.favorite},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Deutsches Menü'),
        centerTitle: true,
        backgroundColor: Colors.redAccent,
        elevation: 4,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        itemCount: options.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final item = options[index];
          return Card(
            elevation: 2,
            margin: const EdgeInsets.symmetric(vertical: 6),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              leading: Icon(item['icon'], color: Colors.redAccent),
              title: Text(
                item['title']!,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              trailing: const Icon(Icons.arrow_forward_ios, size: 18),
              onTap: () {
                Navigator.pushNamed(context, item['route']!);
              },
              contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          );
        },
      ),
    );
  }
}
