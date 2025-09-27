import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class TigerMascot extends StatelessWidget {
  const TigerMascot({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: Colors.orange[100],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Center(
        child: SvgPicture.asset(
          'assets/images/characters/a.svg',
          width: 48,
          height: 48,
          fit: BoxFit.contain,
          // Agregar un placeholder en caso de error
          placeholderBuilder: (context) => const Icon(
            Icons.pets,
            size: 48,
            color: Colors.orange,
          ),
        ),
      ),
    );
  }
}