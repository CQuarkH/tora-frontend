import 'package:flutter/material.dart';

class RegulationStrategy {
  final String id;
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final String pictogramEmoji;

  RegulationStrategy({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.pictogramEmoji,
  });
}

// ==================== DATA ====================

class RegulationStrategiesData {
  static final List<RegulationStrategy> strategies = [
    RegulationStrategy(
      id: 'breathing',
      title: 'Respiración profunda',
      description:
          'Respira profundo 3 veces. Inhala por la nariz, exhala por la boca lentamente.',
      icon: Icons.air,
      color: const Color(0xFF2196F3),
      pictogramEmoji: '🧘',
    ),
    RegulationStrategy(
      id: 'counting',
      title: 'Cuenta hasta 10',
      description:
          'Cuenta hasta 10 despacio mientras imaginas tu lugar favorito.',
      icon: Icons.filter_1,
      color: const Color(0xFF9C27B0),
      pictogramEmoji: '🔢',
    ),
    RegulationStrategy(
      id: 'water',
      title: 'Toma agua',
      description:
          'Toma un vaso de agua fría lentamente. Siente cómo te refresca.',
      icon: Icons.local_drink,
      color: const Color(0xFF00BCD4),
      pictogramEmoji: '💧',
    ),
    RegulationStrategy(
      id: 'stretch',
      title: 'Estira tu cuerpo',
      description:
          'Levántate y estira tus brazos hacia arriba. Mueve tu cuello suavemente.',
      icon: Icons.accessibility_new,
      color: const Color(0xFF4CAF50),
      pictogramEmoji: '🤸',
    ),
    RegulationStrategy(
      id: 'colors',
      title: 'Mira colores calmantes',
      description:
          'Observa colores suaves y respira tranquilo mientras los ves cambiar.',
      icon: Icons.palette,
      color: const Color(0xFFFF9800),
      pictogramEmoji: '🌈',
    ),
  ];

  static RegulationStrategy getStrategy(int index) {
    return strategies[index % strategies.length];
  }
}
