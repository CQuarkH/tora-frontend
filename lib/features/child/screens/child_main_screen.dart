import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:tora_frontend/features/child/screens/calendar/child_calendar_screen.dart';

class ChildMainScreen extends HookWidget {
  const ChildMainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final selectedIndex = useState(0);
    final List<Widget> pages = [
      const ChildCalendarScreen(), // CalendarScreen(),
      const Placeholder(), // RecommendationsScreen(),
      const Placeholder(), // PetScreen(),
      const Placeholder(), // CommunicationScreen(),
    ];

    return Scaffold(
      body: pages[selectedIndex.value],
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Calendario'),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Recomendaciones',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Mascota'),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Comunicación',
          ),
        ],
        currentIndex: selectedIndex.value,
        onTap: (index) {
          selectedIndex.value = index;
        },
      ),
    );
  }
}
