import 'package:flutter/material.dart';

class CommunicationPlaybackBar extends StatelessWidget {
  final String? phrase;
  
  const CommunicationPlaybackBar({
    Key? key,
    this.phrase,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    // 🔹 Escala dinámica del tamaño del texto
    double baseFontSize = screenWidth * 0.05;
    if (baseFontSize > 20) baseFontSize = 20; // límite máximo para evitar overflow

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade300)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // 🔹 Texto flexible, multilinea y con ajuste automático
            Flexible(
              flex: 3,
              child: Text(
                phrase ?? 'Selecciona una frase',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: baseFontSize,
                  color: phrase != null ? Colors.black87 : Colors.grey,
                  fontWeight:
                      phrase != null ? FontWeight.w600 : FontWeight.normal,
                  height: 1.1,
                ),
                maxLines: 2, // ✅ Permite 2 líneas
                overflow: TextOverflow.ellipsis,
                softWrap: true,
              ),
            ),
            const SizedBox(width: 10),
            // 🔹 Botón flexible para no invadir espacio
            Flexible(
              flex: 2,
              child: ElevatedButton.icon(
                onPressed:
                    phrase != null ? () => debugPrint('🔊 $phrase') : null,
                icon: const Icon(Icons.volume_up, size: 20),
                label: const Text('Reproducir'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: phrase != null
                      ? Theme.of(context).colorScheme.primary
                      : Colors.grey,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.03,
                    vertical: screenWidth * 0.02,
                  ),
                  textStyle: TextStyle(
                    fontSize: screenWidth < 360 ? 12 : 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}