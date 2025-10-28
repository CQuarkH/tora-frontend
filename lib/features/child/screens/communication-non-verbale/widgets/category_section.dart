import 'package:flutter/material.dart';
import 'package:tora_frontend/features/child/screens/communication-non-verbale/widgets/communication_option_card.dart';
import 'package:tora_frontend/features/child/screens/communication-non-verbale/widgets/focused_card_view.dart';

class CategorySection extends StatefulWidget {
  final String title;
  final Color color;
  final List<Map<String, dynamic>> items;
  final ValueNotifier<String?> selectedPhrase;

  const CategorySection({
    super.key,
    required this.title,
    required this.color,
    required this.items,
    required this.selectedPhrase,
  });

  @override
  State<CategorySection> createState() => _CategorySectionState();
}

class _CategorySectionState extends State<CategorySection>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true; 

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final screenWidth = MediaQuery.of(context).size.width;
    int crossAxisCount = 3;
    if (screenWidth < 380) crossAxisCount = 2;
    if (screenWidth > 700) crossAxisCount = 4;

    return Padding(
      padding: const EdgeInsets.only(bottom: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🔹 Título de categoría
          Container(
            margin: const EdgeInsets.only(bottom: 10, left: 4),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          
            child: Text(
              widget.title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w900,
                color: Colors.black87,
              ),
            ),
          ),

          // 🔹 Grilla de pictogramas
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 6),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 1,
            ),
            itemCount: widget.items.length,
            itemBuilder: (context, i) {
              final item = widget.items[i];
              final word = item['word'] as String;
              final imageUrl = item['imageUrl'] as String?;
              final heroTag = '${widget.title}-$word';

              return Hero(
                tag: heroTag,
                child: CommunicationOptionCard(
                  emoji: imageUrl != null ? '' : '❓',
                  text: word,
                  imageUrl: imageUrl,
                  color: widget.color,
                  isSelected: widget.selectedPhrase.value == word,
                  onTap: () async {
                    widget.selectedPhrase.value = word;

                    await Navigator.of(context).push(
                      PageRouteBuilder(
                        maintainState: true,
                        opaque: false,
                        barrierColor: Colors.black.withOpacity(0.6),
                        transitionDuration: const Duration(milliseconds: 350),
                        pageBuilder: (_, __, ___) => FocusedCardView(
                          text: word,
                          color: widget.color,
                          imageUrl: imageUrl,
                          heroTag: heroTag,
                        ),
                      ),
                    );

                    if (context.mounted) {
                      widget.selectedPhrase.value = null;
                    }
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
