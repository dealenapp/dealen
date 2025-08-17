import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import '../models/grammar_test_question.dart';
import 'dart:math';

class GrammarTestScreen extends StatefulWidget {
  final List<GrammarTestQuestion> questions;

  const GrammarTestScreen({super.key, required this.questions});

  @override
  State<GrammarTestScreen> createState() => _GrammarTestScreenState();
}

class _GrammarTestScreenState extends State<GrammarTestScreen> {
  int currentIndex = 0;
  int correctCount = 0;
  int wrongCount = 0;
  int? selectedIndex;
  late List<_Option> shuffledOptions;

  @override
  void initState() {
    super.initState();
    shuffleCurrentQuestion();
  }

  void shuffleCurrentQuestion() {
    final q = widget.questions[currentIndex];
    shuffledOptions = List.generate(q.options.length, (i) {
      return _Option(text: q.options[i], isCorrect: i == q.correctIndex);
    });
    shuffledOptions.shuffle(Random());
    selectedIndex = null;
  }

  void answerQuestion(int index) {
    if (selectedIndex != null) return;

    setState(() {
      selectedIndex = index;
      if (shuffledOptions[index].isCorrect) {
        correctCount++;
      } else {
        wrongCount++;
      }
    });

    if (!shuffledOptions[index].isCorrect) {
      final correctOption = shuffledOptions.firstWhere((opt) => opt.isCorrect);
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Row(
              children: [
                const Icon(Icons.info_outline, color: Colors.orange, size: 28),
                const SizedBox(width: 8),
                const Text(
                  "Richtige Antwort",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            content: Text(
              correctOption.text,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _continueToNextQuestion();
                },
                child: const Text(
                  "Verstanden",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          );
        },
      );
    } else {
      _continueToNextQuestion();
    }
  }

  void _continueToNextQuestion() {
    Future.delayed(const Duration(milliseconds: 500), () {
      if (!mounted) return;
      if (currentIndex < widget.questions.length - 1) {
        setState(() {
          currentIndex++;
          shuffleCurrentQuestion();
        });
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => _GrammarTestResultScreen(
              total: widget.questions.length,
              correct: correctCount,
              wrong: wrongCount,
              questions: widget.questions,
            ),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final q = widget.questions[currentIndex];
    final scheme = Theme.of(context).colorScheme;
    final total = widget.questions.length;
    final progress = (currentIndex + 1) / total;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Grammatiktest",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              scheme.primary.withOpacity(0.05),
              scheme.secondary.withOpacity(0.05),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Верхняя панель — прогресс и счёт
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Frage ${currentIndex + 1} von $total",
                  style: TextStyle(
                    fontSize: 16,
                    color: scheme.secondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  "Richtig: $correctCount  Falsch: $wrongCount",
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 10,
                backgroundColor: scheme.surfaceVariant,
                valueColor: AlwaysStoppedAnimation(Colors.blue.shade400),
              ),
            ),
            const SizedBox(height: 20),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      q.question,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 16),
                    ...List.generate(shuffledOptions.length, (i) {
                      final opt = shuffledOptions[i];
                      final isAnswered = selectedIndex != null;
                      final isSelected = selectedIndex == i;

                      Color bg;
                      Color fg;

                      if (!isAnswered) {
                        bg = scheme.primary;
                        fg = scheme.onPrimary;
                      } else {
                        if (opt.isCorrect) {
                          bg = Colors.green.shade600;
                          fg = Colors.white;
                        } else if (isSelected && !opt.isCorrect) {
                          bg = Colors.red.shade600;
                          fg = Colors.white;
                        } else {
                          bg = scheme.surfaceVariant;
                          fg = scheme.onSurfaceVariant;
                        }
                      }

                      return Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 56),
                            backgroundColor: bg,
                            foregroundColor: fg,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          onPressed: isAnswered ? null : () => answerQuestion(i),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              opt.text,
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
            const Spacer(),
            Text(
              selectedIndex == null
                  ? "Wählen Sie die richtige Antwort aus."
                  : "Weiter zur nächsten Frage...",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: scheme.onSurface.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class _Option {
  final String text;
  final bool isCorrect;
  _Option({required this.text, required this.isCorrect});
}

class _GrammarTestResultScreen extends StatelessWidget {
  final int total;
  final int correct;
  final int wrong;
  final List<GrammarTestQuestion> questions;

  const _GrammarTestResultScreen({
    required this.total,
    required this.correct,
    required this.wrong,
    required this.questions,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final percent = total == 0 ? 0 : (correct / total * 100.0);
    final dataMap = <String, double>{
      "Richtig": correct.toDouble(),
      "Falsch": wrong.toDouble(),
    };

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Testergebnis",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        automaticallyImplyLeading: false,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const Text(
                      "Auswertung",
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "Richtig: $correct   |   Falsch: $wrong   |   Gesamt: $total",
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Ergebnis: ${percent.toStringAsFixed(1)}%",
                      style: TextStyle(
                        fontSize: 18,
                        color: scheme.secondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 24),
                    AspectRatio(
                      aspectRatio: 1.2,
                      child: PieChart(
                        dataMap: dataMap,
                        chartType: ChartType.disc,
                        colorList: [Colors.green.shade500, Colors.red.shade500],
                        legendOptions: const LegendOptions(
                          showLegendsInRow: true,
                          legendPosition: LegendPosition.bottom,
                        ),
                        chartValuesOptions: const ChartValuesOptions(
                          showChartValues: true,
                          showChartValuesInPercentage: true,
                          decimalPlaces: 1,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 52),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text(
                      "Zurück",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => GrammarTestScreen(questions: questions),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 52),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text(
                      "Erneut versuchen",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
