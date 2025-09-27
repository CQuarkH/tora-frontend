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
          // Líneas decorativas superiores (rayitas)
          Container(
            margin: const EdgeInsets.only(top: 8),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 12),
          // Botones de navegación
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildNavItem(
                    index: 0,
                    icon: Icons.calendar_today_rounded,
                    iconColor: Colors.blue[700]!,
                  ),
                  _buildNavItem(
                    index: 1,
                    icon: Icons.lightbulb_rounded,
                    iconColor: Colors.orange[700]!,
                  ),
                  _buildNavItem(
                    index: 2,
                    icon: Icons.pets_rounded,
                    iconColor: Colors.orange[700]!,
                  ),
                  _buildNavItem(
                    index: 3,
                    icon: Icons.forum_rounded,
                    iconColor: Colors.cyan[700]!,
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
    required IconData icon,
    required Color iconColor,
  }) {
    final isSelected = selectedIndex == index;
    
    return GestureDetector(
      onTap: () => onItemTapped(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        width: 50,
        height: 50,
        child: Center(
          child: Icon(
            icon,
            color: isSelected ? iconColor : iconColor.withOpacity(0.5),
            size: isSelected ? 28 : 24,
          ),
        ),
      ),
    );
  }
}