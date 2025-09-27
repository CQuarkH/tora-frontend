import 'package:flutter/material.dart';

class DotsIndicator extends StatelessWidget {
  final List<Color> colors;
  final double dotSize;
  final double spacing;

  const DotsIndicator({
    super.key,
    this.colors = const [
      Color(0xFFFF9800),
      Color(0xFF4CAF50),
      Color(0xFF2196F3),
    ],
    this.dotSize = 12.0,
    this.spacing = 8.0,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: colors
          .asMap()
          .entries
          .map((entry) {
            final isLast = entry.key == colors.length - 1;
            return Row(
              children: [
                _buildDot(entry.value),
                if (!isLast) SizedBox(width: spacing),
              ],
            );
          })
          .toList(),
    );
  }

  Widget _buildDot(Color color) {
    return Container(
      width: dotSize,
      height: dotSize,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}