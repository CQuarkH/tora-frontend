import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:tora_frontend/features/child/screens/calendar/child_calendar_screen.dart';

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
      ),
      body: pages.entries.elementAt(selectedIndex.value).value,
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month),
            label: 'Calendario',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.psychology),
            label: 'Recomendaciones',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.pets), label: 'Mascota'),
          BottomNavigationBarItem(
            icon: Icon(Icons.record_voice_over),
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
