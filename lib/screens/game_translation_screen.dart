import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/dictionary_entry.dart';
import '../widgets/game_timer.dart';
import '../widgets/lives_indicator.dart';

class GameTranslationScreen extends StatefulWidget {
  const GameTranslationScreen({super.key});

  @override
  State<GameTranslationScreen> createState() => _GameTranslationScreenState();
}

class _GameTranslationScreenState extends State<GameTranslationScreen> {
  final Random _random = Random();
  List<DictionaryEntry> words = [];
  DictionaryEntry? currentWord;
  List<String> options = [];
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
        words = allWords;
        if (words.isNotEmpty) {
          _nextWord();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Fehler: Keine verfügbaren Wörter")),
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
    if (words.isEmpty) return;
    setState(() {
      currentWord = words[_random.nextInt(words.length)];
      options = _generateOptions();
      _isProcessingAnswer = false; // Flag zurücksetzen
    });
    _timerKey.currentState?.restartTimer(); // Timer neu starten
  }

  List<String> _generateOptions() {
    final correct = currentWord!.rusWord;
    final incorrect = words
        .where((w) => w != currentWord)
        .map((w) => w.rusWord)
        .toList()
      ..shuffle();
    return ([correct]..addAll(incorrect.take(3)))..shuffle();
  }

  void _checkAnswer(String answer) {
    if (_isProcessingAnswer) return; // Doppelte Antworten ignorieren
    setState(() {
      _isProcessingAnswer = true; // Antworten blockieren
      _timerKey.currentState?.stopTimer(); // Timer stoppen
    });

    final isCorrect = answer == currentWord!.rusWord;

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

    // Zeige Dialog mit Übersetzung
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: Text(isCorrect ? 'Richtig!' : 'Falsch'),
        content: Text(
          'Wort: ${currentWord!.deWord}\nÜbersetzung: ${currentWord!.rusWord}',
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
    if (_isProcessingAnswer) return; // Ignoriere, wenn schon geantwortet wurde

    setState(() {
      _isProcessingAnswer = true; // Antworten blockieren
      _lives--;
    });

    // Zeige Dialog bei Zeitablauf
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text('Zeit ist abgelaufen!'),
        content: Text(
          'Wort: ${currentWord!.deWord}\nÜbersetzung: ${currentWord!.rusWord}',
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
              Navigator.pop(context); // Spiel verlassen
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (currentWord == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Spiel: Übersetzung")),
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

            // Deutsches Wort
            Text(
              currentWord!.deWord,
              style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),

            // Antwortoptionen
            ...options.map((opt) {
              return Container(
                margin: const EdgeInsets.symmetric(vertical: 5),
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isProcessingAnswer ? null : () => _checkAnswer(opt),
                  child: Text(opt),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
