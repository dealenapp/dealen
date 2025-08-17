import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/word_model.dart';
import '../widgets/game_timer.dart';
import '../widgets/lives_indicator.dart';

class GameEnTranslationScreen extends StatefulWidget {
  const GameEnTranslationScreen({super.key});

  @override
  State<GameEnTranslationScreen> createState() => _GameEnTranslationScreenState();
}

class _GameEnTranslationScreenState extends State<GameEnTranslationScreen> {
  final Random _random = Random();
  List<WordModel> words = [];
  WordModel? currentWord;
  List<String> options = [];
  int score = 0;
  int _lives = 3;
  bool _isProcessingAnswer = false; // Flag to prevent multiple answers

  // Controller to restart the timer
  final GlobalKey<GameTimerState> _timerKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    try {
      final jsonString = await rootBundle.loadString('lib/data/engwords.json');
      final List<dynamic> data = json.decode(jsonString);

      final allThemes = data.map((e) => ThemeModel.fromJson(e)).toList();
      final allWords = allThemes.expand((theme) => theme.words).toList();

      setState(() {
        words = allWords;
        if (words.isNotEmpty) {
          _nextWord();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Error: No available words")),
          );
        }
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error loading data: $e")),
      );
    }
  }

  void _nextWord() {
    if (words.isEmpty) return;
    setState(() {
      currentWord = words[_random.nextInt(words.length)];
      options = _generateOptions();
      _isProcessingAnswer = false; // Reset answer processing flag
    });
    _timerKey.currentState?.restartTimer(); // Restart timer
  }

  List<String> _generateOptions() {
    final correct = currentWord!.translation;
    final incorrect = words
        .where((w) => w != currentWord)
        .map((w) => w.translation)
        .toList()
      ..shuffle();
    return ([correct]..addAll(incorrect.take(3)))..shuffle();
  }

  void _checkAnswer(String answer) {
    if (_isProcessingAnswer) return; // Ignore repeated answers
    setState(() {
      _isProcessingAnswer = true; // Block new answers processing
      _timerKey.currentState?.stopTimer(); // Stop timer
    });

    final isCorrect = answer == currentWord!.translation;

    setState(() {
      if (isCorrect) {
        score++;
        if (score % 10 == 0) {
          _lives = (_lives + 1).clamp(0, 5); // Max lives limit
        }
      } else {
        _lives--;
      }
    });

    // Show dialog with translation
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: Text(isCorrect ? 'Correct!' : 'Incorrect'),
        content: Text(
          'Word: ${currentWord!.word}\nTranslation: ${currentWord!.translation ?? "No translation available"}',
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              if (_lives <= 0) {
                _showGameOver();
              } else {
                _nextWord();
              }
            },
            child: const Text('Continue'),
          ),
        ],
      ),
    );
  }

  void _onTimeUp() {
    if (_isProcessingAnswer) return; // Ignore if answer already processed

    setState(() {
      _isProcessingAnswer = true; // Block new answers processing
      _lives--;
    });

    // Show dialog when time is up
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text('Time is up!'),
        content: Text(
          'Word: ${currentWord!.word}\nTranslation: ${currentWord!.translation ?? "No translation available"}',
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              if (_lives <= 0) {
                _showGameOver();
              } else {
                _nextWord();
              }
            },
            child: const Text('Continue'),
          ),
        ],
      ),
    );
  }

  void _showGameOver() {
    _timerKey.currentState?.stopTimer(); // Stop timer
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text('Game Over'),
        content: Text('Score: $score'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Exit game
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
      appBar: AppBar(title: const Text("Game: Translation")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Top panel with lives and timer
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

            // Score
            Text("Score: $score", style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 20),

            // English word
            Text(
              currentWord!.word,
              style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),

            // Answer option buttons
            ...options.map((opt) {
              return Container(
                margin: const EdgeInsets.symmetric(vertical: 5),
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isProcessingAnswer ? null : () => _checkAnswer(opt),
                  child: Text(opt, textAlign: TextAlign.center),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
