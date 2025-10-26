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
    final emojiSize = screenWidth < 360 ? 28.0 : 38.0;
    final baseTextSize = screenWidth < 360 ? 12.5 : 14.5;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedScale(
        scale: isSelected ? 1.1 : 1.0,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutBack,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? Colors.amber[100] : color,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: isSelected ? Colors.amber : Colors.transparent,
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: isSelected ? 10 : 4,
                offset: const Offset(0, 4),
              ),
            ],
          ),

          // 🔹 Evita overflow ajustando internamente el tamaño del texto
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    emoji,
                    style: TextStyle(fontSize: emojiSize),
                  ),
                  const SizedBox(height: 6),

                  // ✅ FittedBox evita overflow sin recortar texto
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: constraints.maxHeight * 0.35,
                      maxWidth: constraints.maxWidth * 0.9,
                    ),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.center,
                      child: Text(
                        text,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: baseTextSize,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                          height: 1.1,
                        ),
                        softWrap: true,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
