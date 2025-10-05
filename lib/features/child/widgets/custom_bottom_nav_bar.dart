import 'package:flutter/material.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const CustomBottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
      height: 75,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            offset: const Offset(0, 8),
            blurRadius: 20,
            spreadRadius: 0,
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, 2),
            blurRadius: 6,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        children: [
          const SizedBox(height: 20),
          // Botones de navegación con botón central grande
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildNavItem(
                    index: 0,
                    pngPath: 'assets/images/icons/calendar.png',
                  ),
                  _buildNavItem(
                    index: 1,
                    pngPath: 'assets/images/icons/topic.png',
                  ),
                  // Botón central especial
                  _buildCentralButton(),
                  _buildNavItem(
                    index: 2,
                    pngPath: 'assets/images/icons/paw.png',
                  ),
                  _buildNavItem(
                    index: 3,
                    pngPath: 'assets/images/icons/speaker.png',
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    IconData? iconData,
    String? pngPath,
  }) {
    final isSelected = selectedIndex == index;
    
    // Validación: debe tener iconData O pngPath, pero no ambos
    assert((iconData != null) ^ (pngPath != null), 
           'Debes proporcionar iconData O pngPath, pero no ambos');
    
    return GestureDetector(
      onTap: () => onItemTapped(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        width: 60,
        height: 60,
        child: Center(
          child: _buildIconWidget(
            iconData: iconData,
            pngPath: pngPath,
            size: isSelected ? 36 : 32,
          ),
        ),
      ),
    );
  }

  Widget _buildCentralButton() {
    return GestureDetector(
      onTap: () => (){
        
      },
      child:  Image.asset(
          'assets/images/icons/alert.png',
          width: 56,
          height: 56,
          fit: BoxFit.contain,
        ),
      
    );
  }

  Widget _buildIconWidget({
    IconData? iconData,
    String? pngPath,
    required double size,
  }) {
    if (pngPath != null) {
      // Renderizar PNG sin color filter
      return Image.asset(
        pngPath,
        width: size,
        height: size,
        fit: BoxFit.contain,
      );
    } else {
      // Renderizar icono Material
      return Icon(
        iconData,
        size: size,
        color: Colors.grey[700],
      );
    }
  }
}