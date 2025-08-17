import 'package:flutter/material.dart';

class GameTimer extends StatefulWidget {
  final int totalSeconds;
  final VoidCallback onTimeUp;

  const GameTimer({
    Key? key,
    required this.totalSeconds,
    required this.onTimeUp,
  }) : super(key: key);

  @override
  GameTimerState createState() => GameTimerState();
}

class GameTimerState extends State<GameTimer> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _hasTriggeredTimeUp = false; // Флаг для предотвращения множественных вызовов onTimeUp

  double get progress => _controller.value;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: widget.totalSeconds),
    );

    _controller.reverse(from: 1.0);
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.dismissed && !_hasTriggeredTimeUp) {
        _hasTriggeredTimeUp = true; // Устанавливаем флаг
        widget.onTimeUp();
      }
    });
  }

  /// Перезапускает таймер
  void restartTimer() {
    _controller.stop();
    _controller.reset();
    _hasTriggeredTimeUp = false; // Сбрасываем флаг
    _controller.reverse(from: 1.0);
  }

  /// Останавливает таймер
  void stopTimer() {
    _controller.stop();
    _hasTriggeredTimeUp = true; // Предотвращаем вызов onTimeUp после остановки
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, __) {
        final progressValue = _controller.value; // от 1.0 до 0.0
        return SizedBox(
          height: 10,
          child: LinearProgressIndicator(
            value: progressValue,
            backgroundColor: Colors.grey.shade300,
            valueColor: AlwaysStoppedAnimation<Color>(
              progressValue > 0.3 ? Colors.green : Colors.red,
            ),
          ),
        );
      },
    );
  }
}