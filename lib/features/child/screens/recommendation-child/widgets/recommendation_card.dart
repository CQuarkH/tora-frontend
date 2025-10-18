import 'package:flutter/material.dart';
import '../../../../../core/theme/tora_theme.dart';

class RecommendationCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color cardColor;
  final Color iconColor;
  final VoidCallback? onTap;

  const RecommendationCard({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.cardColor,
    this.iconColor = ToraTheme.darkText,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: ToraTheme.cardShadow,
        ),
        child: Row(
          children: [
            // Icono
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: ToraTheme.pureWhite.withOpacity(0.8),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Icon(
                icon,
                color: iconColor,
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            // Contenido de texto
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: ToraTheme.darkText,
                      letterSpacing: 0.3,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: ToraTheme.darkText.withOpacity(0.7),
                      letterSpacing: 0.2,
                    ),
                  ),
                ],
              ),
            ),
            // Flecha
            Icon(
              Icons.arrow_forward_ios,
              color: ToraTheme.darkText.withOpacity(0.6),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}