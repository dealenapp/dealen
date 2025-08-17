import 'package:flutter/material.dart';
import '../services/tts_service_en.dart';

class ThemeWordsScreen extends StatelessWidget {
  final String themeTitle;
  final List<dynamic> words;

  ThemeWordsScreen({required this.themeTitle, required this.words});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(themeTitle)),
      body: ListView.builder(
        itemCount: words.length,
        itemBuilder: (context, index) {
          final word = words[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            child: ListTile(
              title: Text("${word['word']} — ${word['translation']}"),
              subtitle: word['example'] != null
                  ? Text("📖 ${word['example']}")
                  : null,
              trailing: IconButton(
                icon: const Icon(Icons.volume_up),
                onPressed: () =>
                    TtsServiceEn.speak(word['wordForSound'] ?? word['word']),
              ),
            ),
          );
        },
      ),
    );
  }
}
