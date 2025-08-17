import 'package:flutter/material.dart';

class EnglishMenuScreen extends StatelessWidget {
  const EnglishMenuScreen({super.key});

  // List of menu items with titles and routes
  final List<Map<String, dynamic>> options = const [
    {'title': 'Dictionary', 'route': '/dictionary_en', 'icon': Icons.book},
    {'title': 'Grammar', 'route': '/grammar_en', 'icon': Icons.menu_book},
    {'title': 'Translation (Game)', 'route': '/game_en_translation', 'icon': Icons.gamepad},
    {'title': 'Favorite Words', 'route': '/favorites_en', 'icon': Icons.favorite},
    {'title': 'Themes', 'route': '/theme_list', 'icon': Icons.list},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('English Menu'),
        centerTitle: true,
        backgroundColor: Colors.greenAccent,
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
              leading: Icon(item['icon'], color: Colors.greenAccent),
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
