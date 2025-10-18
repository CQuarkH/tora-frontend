import 'package:flutter/material.dart';
import '../../../../../core/theme/tora_theme.dart';

class CommunicationHeader extends StatelessWidget {
  const CommunicationHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // 🔹 Escalar tamaños según ancho de pantalla
    final titleFontSize = screenWidth < 360 ? 20.0 : 24.0;
    final subtitleFontSize = screenWidth < 360 ? 14.0 : 16.0;
    final emojiSize = screenWidth < 360 ? 22.0 : 26.0;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.05,
        vertical: screenHeight * 0.02,
      ),
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            ToraTheme.softBlue,
            ToraTheme.softBlue.withOpacity(0.85),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: ToraTheme.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🔹 Título y emoji alineados
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  '¡Comunicación!',
                  style: TextStyle(
                    fontSize: titleFontSize,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              Text(
                '💬',
                style: TextStyle(fontSize: emojiSize),
              ),
            ],
          ),

          const SizedBox(height: 6),

          // 🔹 Subtítulo adaptativo
          Text(
            'Expresa cómo te sientes o lo que necesitas',
            style: TextStyle(
              fontSize: subtitleFontSize,
              fontWeight: FontWeight.w400,
              color: Colors.white.withOpacity(0.95),
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }
}
