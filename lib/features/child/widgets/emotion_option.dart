import 'package:flutter/material.dart';
import 'package:tora_frontend/features/child/models/emotion_record.dart';

class EmotionOption extends StatelessWidget {
  final Emotion emotion;
  final bool isSelected;
  final VoidCallback onTap;

  const EmotionOption({
    super.key,
    required this.emotion,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8.0), // Reducido el padding
        decoration: BoxDecoration(
          color: emotion.backgroundColor,
          border: isSelected
              ? Border.all(color: Colors.grey[700]!, width: 3.0)
              : null,
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min, // Añadido para mejor control del espacio
          children: [
            Text(emotion.emoji, style: const TextStyle(fontSize: 22.0)), // Reducido ligeramente
            const SizedBox(height: 4.0),
            Flexible( // Añadido Flexible para manejar overflow
              child: Text(
                emotion.displayName,
                style: TextStyle(
                  fontSize: 10.0, // Reducido el tamaño de fuente
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
                maxLines: 2, // Permitir hasta 2 líneas
                overflow: TextOverflow.ellipsis, // Truncar si es necesario
              ),
            ),
          ],
        ),
      ),
    );
  }
}
