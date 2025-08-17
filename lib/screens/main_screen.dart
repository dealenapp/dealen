import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'german_menu_screen.dart';
import 'english_menu_screen.dart';
import '../main.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _color1;
  late Animation<Color?> _color2;
  late Animation<Color?> _color3;

  final int _particleCount = 40;
  late List<_Particle> _particles;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 12),
      vsync: this,
    )..repeat();

    _color1 = TweenSequence<Color?>([
      TweenSequenceItem(tween: ColorTween(begin: Colors.blue.shade300, end: Colors.lightBlue.shade300), weight: 1),
      TweenSequenceItem(tween: ColorTween(begin: Colors.lightBlue.shade300, end: Colors.cyan.shade200), weight: 1),
      TweenSequenceItem(tween: ColorTween(begin: Colors.cyan.shade200, end: Colors.blue.shade300), weight: 1),
    ]).animate(_controller);

    _color2 = TweenSequence<Color?>([
      TweenSequenceItem(tween: ColorTween(begin: Colors.teal.shade300, end: Colors.greenAccent.shade400), weight: 1),
      TweenSequenceItem(tween: ColorTween(begin: Colors.greenAccent.shade400, end: Colors.lightGreen.shade300), weight: 1),
      TweenSequenceItem(tween: ColorTween(begin: Colors.lightGreen.shade300, end: Colors.teal.shade300), weight: 1),
    ]).animate(_controller);

    _color3 = TweenSequence<Color?>([
      TweenSequenceItem(tween: ColorTween(begin: Colors.blue.shade200, end: Colors.green.shade300), weight: 1),
      TweenSequenceItem(tween: ColorTween(begin: Colors.green.shade300, end: Colors.teal.shade300), weight: 1),
      TweenSequenceItem(tween: ColorTween(begin: Colors.teal.shade300, end: Colors.blue.shade200), weight: 1),
    ]).animate(_controller);

    // Генерация частиц
    _particles = List.generate(_particleCount, (index) => _Particle.random());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final colors = [_color1.value!, _color2.value!, _color3.value!];

        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: const Text('DEALEN'),
            backgroundColor: colors[0],
            actions: [
              IconButton(
                icon: Icon(isDark ? Icons.wb_sunny : Icons.nightlight_round),
                onPressed: () => MyApp.of(context)?.toggleTheme(),
              ),
            ],
          ),
          body: Stack(
            children: [
              // Градиентный фон
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: colors,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
              // Плавающие шарики
              ..._particles.map((p) => AnimatedBuilder(
                animation: _controller,
                builder: (_, __) {
                  final dx = p.x + math.sin(_controller.value * 2 * math.pi * p.speed) * p.amplitude;
                  final dy = p.y + math.cos(_controller.value * 2 * math.pi * p.speed) * p.amplitude;
                  return Positioned(
                    left: dx,
                    top: dy,
                    child: Container(
                      width: p.size,
                      height: p.size,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(p.opacity),
                        shape: BoxShape.circle,
                      ),
                    ),
                  );
                },
              )),
              // Основной контент
              Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 350),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildLangButton(
                        context,
                        label: 'Deutsch',
                        gradientColors: isDark
                            ? [Colors.pink.shade700, Colors.red.shade700]
                            : [Colors.redAccent.shade200, Colors.redAccent.shade700],
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const GermanMenuScreen()),
                        ),
                      ),
                      const SizedBox(height: 20),
                      _buildLangButton(
                        context,
                        label: 'English',
                        gradientColors: isDark
                            ? [Colors.green.shade800, Colors.green.shade900]
                            : [Colors.greenAccent.shade400, Colors.lightGreen.shade700],
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const EnglishMenuScreen()),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLangButton(
    BuildContext context, {
    required String label,
    required List<Color> gradientColors,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: gradientColors),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: gradientColors.last.withOpacity(0.6),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            textStyle: const TextStyle(
              fontFamily: 'RobotoCondensed',
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          onPressed: onTap,
          child: Text(label),
        ),
      ),
    );
  }
}

class _Particle {
  double x;
  double y;
  double size;
  double opacity;
  double speed;
  double amplitude;

  _Particle({
    required this.x,
    required this.y,
    required this.size,
    required this.opacity,
    required this.speed,
    required this.amplitude,
  });

  factory _Particle.random() {
    final random = math.Random();
    return _Particle(
      x: random.nextDouble() * 400,
      y: random.nextDouble() * 800,
      size: 4 + random.nextDouble() * 6,
      opacity: 0.2 + random.nextDouble() * 0.5,
      speed: 0.5 + random.nextDouble(),
      amplitude: 10 + random.nextDouble() * 20,
    );
  }
}
