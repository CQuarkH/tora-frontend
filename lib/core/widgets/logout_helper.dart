import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tora_frontend/features/auth/services/auth_service.dart';

class LogoutHelper {
  static void showLogoutDialog(
    BuildContext parentContext, {
    String? customMessage,
  }) async {
    showDialog(
      context: parentContext,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('¿Cerrar sesión?'),
          content: Text(
            customMessage ?? '¿Estás seguro de que quieres cerrar sesión?',
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(dialogContext).pop();
                await _performLogout(parentContext);
              },
              child: const Text(
                'Cerrar sesión',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  static Future<void> _performLogout(BuildContext context) async {
    final authService = AuthService();
    await authService.logout();
    if (context.mounted) {
      context.go('/'); // Navegar a la pantalla de inicio de sesión
    }
  }

  /// Widget para botón de logout en AppBar
  static Widget logoutAppBarAction(
    BuildContext context, {
    String? customMessage,
  }) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert),
      onSelected: (value) {
        if (value == 'logout') {
          showLogoutDialog(context, customMessage: customMessage);
        }
      },
      itemBuilder: (BuildContext context) => [
        const PopupMenuItem<String>(
          value: 'logout',
          child: Row(
            children: [
              Icon(Icons.logout, color: Colors.red),
              SizedBox(width: 8),
              Text('Cerrar sesión', style: TextStyle(color: Colors.red)),
            ],
          ),
        ),
      ],
    );
  }

  /// Widget para botón directo de logout
  static Widget logoutButton(
    BuildContext context, {
    String? customMessage,
    String? buttonText,
  }) {
    return ElevatedButton.icon(
      onPressed: () => showLogoutDialog(context, customMessage: customMessage),
      icon: const Icon(Icons.logout),
      label: Text(buttonText ?? 'Cerrar sesión'),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red[100],
        foregroundColor: Colors.red[800],
        elevation: 0,
      ),
    );
  }

  /// Widget para opción en drawer/menú lateral
  static Widget logoutDrawerTile(
    BuildContext context, {
    String? customMessage,
  }) {
    return ListTile(
      leading: const Icon(Icons.logout, color: Colors.red),
      title: const Text('Cerrar sesión', style: TextStyle(color: Colors.red)),
      onTap: () {
        Navigator.of(context).pop(); // Cerrar drawer primero
        showLogoutDialog(context, customMessage: customMessage);
      },
    );
  }
}
