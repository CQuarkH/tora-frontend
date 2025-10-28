import 'package:flutter/material.dart';

class FocusedCardView extends StatelessWidget {
  final String text;
  final Color color;
  final String? imageUrl;
  final String heroTag;

  const FocusedCardView({
    required this.text,
    required this.color,
    required this.imageUrl,
    required this.heroTag,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double cardSize = size.width * 0.8;

    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.6),
      body: GestureDetector(
        onTap: () => Navigator.of(context).pop(),
        behavior: HitTestBehavior.opaque,
        child: Center(
          child: Hero(
            tag: heroTag,
            child: Material(
              color: Colors.transparent,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 350),
                  
                  curve: Curves.easeOutBack,
                  width: cardSize,
                  height: cardSize,
                  decoration: BoxDecoration(
                    color: color,
                    border: Border.all(
                      color: Colors.orangeAccent,
                      width: 2.5,
                    ),
                  ),
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (imageUrl != null)
                          Image.network(
                            imageUrl!,
                            fit: BoxFit.contain,
                            width: cardSize * 0.6,
                          )
                        else
                          const Text('❓', style: TextStyle(fontSize: 80)),
                        const SizedBox(height: 5),
                        Text(
                          text,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: cardSize * 0.15,
                            fontWeight: FontWeight.w800,
                            color:  Theme.of(context).colorScheme.primary,
                           
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
