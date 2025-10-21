import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:tora_frontend/features/child/screens/communication-non-verbale/widgets/communication_header.dart';
import 'package:tora_frontend/features/child/screens/communication-non-verbale/widgets/communication_option_card.dart';

class ChildCommunicationNonVerbaleScreen extends HookWidget {
  const ChildCommunicationNonVerbaleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final selectedPhrase = useState<String?>(null);

    final items = [
      // 🔹 Emociones
      {'emoji': '😊', 'text': 'Estoy bien', 'color': const Color(0xFFFFE8D6)},
      {'emoji': '😢', 'text': 'Estoy triste', 'color': const Color(0xFFFFE8D6)},
      {
        'emoji': '😡',
        'text': 'Estoy enojado',
        'color': const Color(0xFFFFE8D6),
      },
      {
        'emoji': '🤢',
        'text': 'Me siento mal',
        'color': const Color(0xFFFFE8D6),
      },

      // 🔹 Necesidades
      {'emoji': '🍎', 'text': 'Tengo hambre', 'color': const Color(0xFFD6EAF8)},
      {'emoji': '💧', 'text': 'Tengo sed', 'color': const Color(0xFFD6EAF8)},
      {
        'emoji': '🚽',
        'text': 'Necesito ir al baño',
        'color': const Color(0xFFD6EAF8),
      },
      {
        'emoji': '🏠',
        'text': 'Quiero ir a casa',
        'color': const Color(0xFFD6EAF8),
      },

      // 🔹 Acciones
      {
        'emoji': '🗣️',
        'text': 'Quiero hablar',
        'color': const Color(0xFFE8DAEF),
      },
    ];

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // 🔹 Calcular columnas dinámicamente
    int crossAxisCount = 3;
    if (screenWidth < 380) crossAxisCount = 2;
    if (screenWidth > 700) crossAxisCount = 4;

    // 🔹 Ajustar relación ancho/alto de los cuadros
    final aspectRatio = screenHeight < 700 ? 0.95 : 1.1;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Column(
          children: [
            CommunicationHeader(),

            Expanded(
              child: GridView.builder(
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.06,
                  vertical: screenHeight * 0.02,
                ),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: aspectRatio,
                ),
                itemCount: items.length,
                itemBuilder: (context, i) {
                  final item = items[i];
                  return CommunicationOptionCard(
                    emoji: item['emoji'] as String,
                    text: item['text'] as String,
                    color: item['color'] as Color,
                    isSelected: selectedPhrase.value == item['text'],
                    onTap: () => selectedPhrase.value = item['text'] as String,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
