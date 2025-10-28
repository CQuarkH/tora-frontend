import 'package:flutter/material.dart';
import 'package:tora_frontend/core/theme/tora_theme.dart';
import 'package:tora_frontend/features/child/models/regulation_strategy.dart';

class StrategyModal extends StatelessWidget {
  final RegulationStrategy strategy;
  final int attemptNumber;
  final VoidCallback onCompleted;

  const StrategyModal({
    required this.strategy,
    required this.attemptNumber,
    required this.onCompleted,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.65,
      decoration: BoxDecoration(
        color: ToraTheme.pureWhite,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: Column(
        children: [
          // Handle
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: ToraTheme.lightGray,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),

          // Header
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 24),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  strategy.color.withOpacity(0.2),
                  strategy.color.withOpacity(0.1),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Icon(strategy.icon, color: strategy.color, size: 32),
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Text(
                    'Estrategia de Regulación',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: ToraTheme.darkText,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Pictograma emoji
          Text(strategy.pictogramEmoji, style: const TextStyle(fontSize: 100)),

          const SizedBox(height: 24),

          // Título
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              strategy.title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: ToraTheme.darkText,
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Descripción
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: strategy.color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: strategy.color.withOpacity(0.3),
                  width: 2,
                ),
              ),
              child: Text(
                strategy.description,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  color: ToraTheme.darkText,
                  height: 1.5,
                ),
              ),
            ),
          ),

          const Spacer(),

          // Botón completado
          Padding(
            padding: const EdgeInsets.all(24),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onCompleted,
                style: ElevatedButton.styleFrom(
                  backgroundColor: strategy.color,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  elevation: 2,
                ),
                child: const Text(
                  'Entendido',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
