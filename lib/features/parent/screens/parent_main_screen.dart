import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:tora_frontend/core/services/api_client.dart';
import 'package:tora_frontend/core/theme/tora_theme.dart';
import 'package:tora_frontend/core/widgets/logout_helper.dart';
import 'package:tora_frontend/features/parent/screens/parent_dashboard_screen.dart';
import 'package:tora_frontend/features/parent/screens/parent_notifications_screen.dart';
import 'package:tora_frontend/features/parent/screens/parent_tips_screen.dart';

class ParentMainScreen extends HookWidget {
  const ParentMainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final selectedIndex = useState(0);
    final childName = useState('');

    Future<void> fetchParentProfile() async {
      try {
        final _apiClient = ApiClient();
        final response = await _apiClient.get('/users/profile');
        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          final children = data['children'] as List<dynamic>? ?? [];
          if (children.isNotEmpty) {
            childName.value = children[0]['name'].split(' ')[0] ?? 'Tu hijo';
          }
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al cargar el perfil: $e')),
        );
      }
    }

    final Map<String, Widget> pages = {
      'Dashboard - ${childName.value}': const ParentDashboardScreen(),
      'Consejos para ti': const ParentTipsScreen(),
    };

    return FutureBuilder(
      future: fetchParentProfile(),
      builder: (context, asyncSnapshot) {
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
              IconButton(
                icon: const Icon(
                  Icons.notifications,
                  color: ToraTheme.warmYellow,
                ),
                onPressed: () {
                  // Navegar a la pantalla de notificaciones
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          const ParentNotificationsScreen(childId: 'child_001'),
                    ),
                  );
                },
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
                icon: Icon(Icons.lightbulb),
                label: 'Tips',
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
      },
    );
  }
}
