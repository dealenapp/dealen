import 'package:flutter/material.dart';

class LivesIndicator extends StatelessWidget {
  final int lives; // текущие жизни
  final int maxLives; // максимум жизней

  const LivesIndicator({
    super.key,
    required this.lives,
    this.maxLives = 3,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(maxLives, (index) {
        return Icon(
          index < lives ? Icons.favorite : Icons.favorite_border,
          color: Colors.red,
        );
      }),
    );
  }
}
