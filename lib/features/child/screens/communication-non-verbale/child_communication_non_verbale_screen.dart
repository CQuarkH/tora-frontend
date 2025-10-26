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
      {'emoji': '😊', 'text': 'Estoy bien', 'color': const Color(0xFFFFE8D6)},
      {'emoji': '😢', 'text': 'Estoy triste', 'color': const Color(0xFFFFE8D6)},
      {'emoji': '😡', 'text': 'Estoy enojado', 'color': const Color(0xFFFFE8D6)},
      {'emoji': '🤢', 'text': 'Me siento mal', 'color': const Color(0xFFFFE8D6)},
      {'emoji': '🍎', 'text': 'Tengo hambre', 'color': const Color(0xFFD6EAF8)},
      {'emoji': '💧', 'text': 'Tengo sed', 'color': const Color(0xFFD6EAF8)},
      {'emoji': '🚽', 'text': 'Necesito ir al baño', 'color': const Color(0xFFD6EAF8)},
      {'emoji': '🏠', 'text': 'Quiero ir a casa', 'color': const Color(0xFFD6EAF8)},
      {'emoji': '🗣️', 'text': 'Quiero hablar', 'color': const Color(0xFFE8DAEF)},
    ];

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    int crossAxisCount = 3;
    if (screenWidth < 380) crossAxisCount = 2;
    if (screenWidth > 700) crossAxisCount = 4;

    final aspectRatio = screenHeight < 700 ? 0.95 : 1.1;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Stack(
          children: [
            // 🔹 Vista principal
            Column(
              children: [
                const CommunicationHeader(),
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
                      final text = item['text'] as String;

                      return Hero(
                        tag: text,
                        child: CommunicationOptionCard(
                          emoji: item['emoji'] as String,
                          text: text,
                          color: item['color'] as Color,
                          isSelected: selectedPhrase.value == text,
                          onTap: () {
                            selectedPhrase.value = text;
                            Navigator.of(context).push(
                              PageRouteBuilder(
                                opaque: false,
                                barrierColor: Colors.black.withOpacity(0.6),
                                transitionDuration: const Duration(milliseconds: 400),
                                pageBuilder: (_, __, ___) => _FocusedCardView(
                                  emoji: item['emoji'] as String,
                                  text: text,
                                  color: item['color'] as Color,
                                  onClose: () => Navigator.of(context).pop(),
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// 🔹 Pantalla que muestra la tarjeta centrada y agrandada
class _FocusedCardView extends StatelessWidget {
  final String emoji;
  final String text;
  final Color color;
  final VoidCallback onClose;

  const _FocusedCardView({
    required this.emoji,
    required this.text,
    required this.color,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onClose,
      child: Scaffold(
        backgroundColor: Colors.black.withOpacity(0.6),
        body: Center(
          child: Hero(
            tag: text,
            child: Material(
              color: Colors.transparent,
              child: AnimatedScale(
                scale: 1.5,
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeOutBack,
                child: CommunicationOptionCard(
                  emoji: emoji,
                  text: text,
                  color: color,
                  isSelected: true,
                  onTap: onClose,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
