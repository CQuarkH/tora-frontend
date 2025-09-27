import 'package:flutter/material.dart';

class WelcomeText extends StatelessWidget {
  final String title;
  final String subtitle;
  final Color titleColor;
  final Color subtitleColor;

  const WelcomeText({
    super.key,
    this.title = '¡Hola de nuevo!',
    this.subtitle = 'Estoy feliz de tenerte de vuelta',
    this.titleColor = const Color(0xFF2196F3),
    this.subtitleColor = const Color(0xFF666666),
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: titleColor,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          subtitle,
          style: TextStyle(
            fontSize: 16,
            color: subtitleColor,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}