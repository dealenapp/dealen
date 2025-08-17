import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/dictionary_entry.dart';
import '../widgets/game_timer.dart';
import '../widgets/lives_indicator.dart';

class GameArticlesScreen extends StatefulWidget {
  const GameArticlesScreen({super.key});

  @override
  State<GameArticlesScreen> createState() => _GameArticlesScreenState();
}

class _GameArticlesScreenState extends State<GameArticlesScreen> {
  final Random _random = Random();
  List<DictionaryEntry> nouns = [];
  DictionaryEntry? currentWord;
  int score = 0;
  int _lives = 3;
  bool _isProcessingAnswer = false; // Verhindert mehrfaches Antworten

  // Controller für den Timer
  final GlobalKey<GameTimerState> _timerKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    try {
      final jsonString = await rootBundle.loadString('lib/data/a1c1.json');
      final List<dynamic> data = json.decode(jsonString);
      final allWords = data.map((e) => DictionaryEntry.fromJson(e)).toList();

      setState(() {
        nouns = allWords
            .where((w) => w.partOfSpeech == "noun" && w.article != null)
            .toList();
        if (nouns.isNotEmpty) {
          _nextWord();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Fehler: Keine passenden Wörter gefunden")),
          );
        }
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Fehler beim Laden der Daten: $e")),
      );
    }
  }

  void _nextWord() {
    if (nouns.isEmpty) return;
    setState(() {
      currentWord = nouns[_random.nextInt(nouns.length)];
      _isProcessingAnswer = false; // Flag zurücksetzen
    });
    _timerKey.currentState?.restartTimer(); // Timer neustarten
  }

  void _checkAnswer(String article) {
    if (_isProcessingAnswer) return; // Doppelte Antworten ignorieren
    setState(() {
      _isProcessingAnswer = true; // Antworten blockieren
      _timerKey.currentState?.stopTimer(); // Timer stoppen
    });

    final isCorrect = article == currentWord!.article;

    setState(() {
      if (isCorrect) {
        score++;
        if (score % 10 == 0) {
          _lives = (_lives + 1).clamp(0, 5); // 1 Leben alle 10 richtige Antworten
        }
      } else {
        _lives--;
      }
    });

    // Dialog mit Übersetzung anzeigen
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: Text(isCorrect ? 'Richtig!' : 'Falsch'),
        content: Text(
          'Wort: ${currentWord!.deWord}\nArtikel: ${currentWord!.article}\nÜbersetzung: ${currentWord!.rusWord ?? "Keine Übersetzung vorhanden"}',
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Dialog schließen
              if (_lives <= 0) {
                _showGameOver();
              } else {
                _nextWord();
              }
            },
            child: const Text('Weiter'),
          ),
        ],
      ),
    );
  }

  void _onTimeUp() {
    if (_isProcessingAnswer) return; // Ignorieren, wenn bereits geantwortet

    setState(() {
      _isProcessingAnswer = true; // Antworten blockieren
      _lives--;
    });

    // Dialog bei Zeitablauf anzeigen
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text('Zeit ist abgelaufen!'),
        content: Text(
          'Wort: ${currentWord!.deWord}\nArtikel: ${currentWord!.article}\nÜbersetzung: ${currentWord!.rusWord ?? "Keine Übersetzung vorhanden"}',
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Dialog schließen
              if (_lives <= 0) {
                _showGameOver();
              } else {
                _nextWord();
              }
            },
            child: const Text('Weiter'),
          ),
        ],
      ),
    );
  }

  void _showGameOver() {
    _timerKey.currentState?.stopTimer(); // Timer stoppen
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text('Das Spiel ist aus'),
        content: Text('Punktzahl: $score'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Dialog schließen
              Navigator.pop(context); // Zurück gehen
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Color _colorForArticle(String article) {
    switch (article) {
      case 'der':
        return Colors.blue.shade700; // maskulin - blau
      case 'die':
        return Colors.pink.shade400; // feminin - rosa
      case 'das':
        return Colors.green.shade600; // neutral - grün
      default:
        return Colors.grey;
    }
  }

  String _cleanWord(String word) {
    final lower = word.toLowerCase();
    if (lower.startsWith('der ')) {
      return word.substring(4);
    }
    if (lower.startsWith('die ')) {
      return word.substring(4);
    }
    if (lower.startsWith('das ')) {
      return word.substring(4);
    }
    return word;
  }

  @override
  Widget build(BuildContext context) {
    if (currentWord == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Spiel: Artikel")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Obere Leiste — Leben und Timer
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                LivesIndicator(lives: _lives),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: GameTimer(
                      key: _timerKey,
                      totalSeconds: 15,
                      onTimeUp: _onTimeUp,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Punktestand
            Text("Punktzahl: $score", style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 20),
            // Wort anzeigen ohne Artikel
            Text(
              _cleanWord(currentWord!.deWord),
              style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            // Artikelauswahl Buttons (breit, farbig)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: ["der", "die", "das"].map((article) {
                return Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 6),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _colorForArticle(article),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      onPressed: _isProcessingAnswer ? null : () => _checkAnswer(article),
                      child: Text(
                        article,
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
