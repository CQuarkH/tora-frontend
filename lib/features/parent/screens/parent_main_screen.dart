import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:tora_frontend/core/widgets/logout_helper.dart';
import 'package:tora_frontend/features/parent/screens/parent_dashboard_screen.dart';

class ParentMainScreen extends HookWidget {
  const ParentMainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final selectedIndex = useState(0);

    final Map<String, Widget> pages = {
      'Dashboard - María': const ParentDashboardScreen(childId: 'child_001'),
      'Contactos de Emergencia': const Center(
        child: Text('Contactos de Emergencia - En desarrollo'),
      ),
      'Configuración': const Center(
        child: Text('Configuración - En desarrollo'),
      ),
    };

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        elevation: 0,
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
            customMessage: '¿Está seguro de que desea cerrar sesión?',
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: pages.entries.elementAt(selectedIndex.value).value,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.contacts),
            label: 'Contactos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Configuración',
          ),
        ],
        currentIndex: selectedIndex.value,
        onTap: (index) {
          selectedIndex.value = index;
        },
        selectedItemColor: Colors.green[700],
        unselectedItemColor: Colors.grey[600],
      ),
    );
  }
}
