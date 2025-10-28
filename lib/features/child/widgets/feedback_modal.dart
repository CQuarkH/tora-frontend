import 'package:flutter/material.dart';
import 'package:tora_frontend/core/theme/tora_theme.dart';
import 'package:tora_frontend/features/child/models/regulation_strategy.dart';

class FeedbackModal extends StatelessWidget {
  final RegulationStrategy strategy;
  final VoidCallback onYes;
  final VoidCallback onNo;

  const FeedbackModal({
    super.key,
    required this.strategy,
    required this.onYes,
    required this.onNo,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.5,
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
          const SizedBox(height: 32),

          // Emoji pregunta
          const Text('🤔', style: TextStyle(fontSize: 80)),

          const SizedBox(height: 24),

          // Pregunta
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              '¿Te ayudó esta estrategia?',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: ToraTheme.darkText,
              ),
            ),
          ),

          const SizedBox(height: 12),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              'Queremos saber si te sientes mejor',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: ToraTheme.mediumText,
                height: 1.5,
              ),
            ),
          ),

          const Spacer(),

          // Botones
          Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: onNo,
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(
                        color: Color(0xFFE91E63),
                        width: 2,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 18),
                    ),
                    child: const Column(
                      children: [
                        Icon(Icons.close, color: Color(0xFFE91E63), size: 32),
                        SizedBox(height: 4),
                        Text(
                          'No',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFFE91E63),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: onYes,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4CAF50),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      elevation: 2,
                    ),
                    child: const Column(
                      children: [
                        Icon(Icons.check, size: 32),
                        SizedBox(height: 4),
                        Text(
                          'Sí',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
