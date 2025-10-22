import 'package:flutter/material.dart';

class CommunicationOptionCard extends StatelessWidget {
  final String emoji;
  final String text;
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  const CommunicationOptionCard({
    Key? key,
    required this.emoji,
    required this.text,
    required this.color,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    // 🔹 Ajustar tamaño de emoji y texto según el ancho
    final emojiSize = screenWidth < 360 ? 30.0 : 40.0;
    final textSize = screenWidth < 360 ? 13.0 : 15.0;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.amber[100] : color,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isSelected ? Colors.amber : Colors.transparent,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    emoji,
                    style: TextStyle(fontSize: emojiSize),
                  ),
                ),
                const SizedBox(height: 6),
                Flexible(
                  child: Text(
                    text,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: textSize,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                      height: 1.1,
                    ),
                    softWrap: true,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
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