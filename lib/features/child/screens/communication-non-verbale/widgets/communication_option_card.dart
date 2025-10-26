import 'package:flutter/material.dart';

class CommunicationOptionCard extends StatelessWidget {
  final String emoji;
  final String text;
  final String? imageUrl;
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  const CommunicationOptionCard({
    Key? key,
    required this.emoji,
    required this.text,
    this.imageUrl,
    required this.color,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? Colors.orangeAccent : Colors.transparent,
            width: 2,
          ),
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: Colors.orangeAccent.withOpacity(0.3),
                blurRadius: 8,
                spreadRadius: 2,
              ),
          ],
        ),
        padding: const EdgeInsets.all(8),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final double cardWidth = constraints.maxWidth;
            final double imageSize = cardWidth * 0.45;
            final double textMaxHeight = constraints.maxHeight * 0.3;

            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 🔹 Imagen o emoji proporcional
                if (imageUrl != null)
                  Image.network(
                    imageUrl!,
                    width: imageSize,
                    height: imageSize,
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => const Icon(Icons.broken_image, size: 40),
                  )
                else
                  Text(emoji, style: TextStyle(fontSize: cardWidth * 0.25)),

                const SizedBox(height: 8),

                // 🔹 Texto responsivo
                SizedBox(
                  height: textMaxHeight,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.center,
                    child: Text(
                      text,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: cardWidth * 0.12, // Escala automática
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[800],
                        height: 1.1,
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
