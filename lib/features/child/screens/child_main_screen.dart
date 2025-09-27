import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:tora_frontend/features/child/screens/calendar/child_calendar_screen.dart';
import 'package:tora_frontend/features/child/widgets/custom_bottom_nav_bar.dart';
import 'package:tora_frontend/core/widgets/logout_helper.dart';

class ChildMainScreen extends HookWidget {
  const ChildMainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final selectedIndex = useState(0);

    final Map<String, Widget> pages = {
      'Calendario': ChildCalendarScreen(),
      'Recomendaciones': const Placeholder(),
      'Mascota': const Placeholder(),
      'Comunicación': const Placeholder(),
    };

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        elevation: 0,
        leadingWidth: 40,
        leading: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Image.asset(
            'assets/images/icons/tora.png',
            fit: BoxFit.contain,
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              pages.entries.elementAt(selectedIndex.value).key,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ],
        ),
        actions: [
          LogoutHelper.logoutAppBarAction(
            context,
            customMessage: '¿Estás seguro de que quieres salir de tu aventura?',
          ),
        ],
      ),
      body: Stack(
        children: [
          // Contenido principal con padding inferior para evitar superposición
          Padding(
            padding: const EdgeInsets.only(
              bottom: 100,
            ), // Espacio para la navbar
            child: pages.entries.elementAt(selectedIndex.value).value,
          ),
          // Navbar flotante
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: CustomBottomNavBar(
              selectedIndex: selectedIndex.value,
              onItemTapped: (index) {
                selectedIndex.value = index;
              },
            ),
          ),
        ],
      ),
    );
  }
}
