
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tora_frontend/features/auth/screens/fork_users_screen.dart';
import 'package:tora_frontend/features/auth/screens/child_login_screen.dart';
import 'package:tora_frontend/features/auth/screens/parent_login_screen.dart';
import 'package:tora_frontend/features/auth/screens/registration/registration_flow_screen.dart';
import 'package:tora_frontend/features/child/screens/child_main_screen.dart';
import 'package:tora_frontend/features/child/screens/recommendation-child/recommendation_child_screen.dart';
import 'package:tora_frontend/features/parent/screens/parent_main_screen.dart';

// Enum para los tipos de usuario
enum UserType { child, parent }

// Clase para manejar el estado del usuario
class UserSession {
  static UserType? _currentUserType;
  static bool _isLoggedIn = false;

  static UserType? get currentUserType => _currentUserType;
  static bool get isLoggedIn => _isLoggedIn;

  static void setUserType(UserType type) {
    _currentUserType = type;
    _isLoggedIn = true;
  }

  static void logout() {
    _currentUserType = null;
    _isLoggedIn = false;
  }
}

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  debugLogDiagnostics: true,
  redirect: (BuildContext context, GoRouterState state) {
    final bool isLoggedIn = UserSession.isLoggedIn;
    final String location = state.uri.path;

    // Rutas de autenticación que no requieren redirección
    const authRoutes = ['/', '/child-login', '/parent-login', '/register'];
    
    // Si no está logueado y trata de acceder a rutas protegidas (pero no a rutas de auth)
    if (!isLoggedIn && !authRoutes.contains(location) && (location.startsWith('/child') || location.startsWith('/parent'))) {
      return '/';
    }

    // Si está logueado y trata de acceder a la pantalla inicial, redirigir según tipo de usuario
    if (isLoggedIn && location == '/') {
      if (UserSession.currentUserType == UserType.child) {
        return '/child';
      } else if (UserSession.currentUserType == UserType.parent) {
        return '/parent';
      }
    }

    return null; // No redirigir
  },
  routes: <RouteBase>[
    // ===== RUTAS DE AUTENTICACIÓN =====
    GoRoute(
      path: '/',
      name: 'fork-users',
      builder: (context, state) => const ForkUsersScreen(),
    ),
    
    GoRoute(
      path: '/child-login',
      name: 'child-login',
      builder: (context, state) => const ChildLoginScreen(),
    ),
    
    GoRoute(
      path: '/parent-login',
      name: 'parent-login',
      builder: (context, state) => const ParentLoginScreen(),
    ),
    
    GoRoute(
      path: '/register',
      name: 'register',
      builder: (context, state) => const RegistrationFlowScreen(),
    ),

    // ===== RUTAS DEL NIÑO =====
    ShellRoute(
      builder: (context, state, child) {
        return child; // Aquí puedes agregar un Scaffold común para niños si es necesario
      },
      routes: [
        GoRoute(
          path: '/child',
          name: 'child-home',
          builder: (context, state) => const ChildMainScreen(),
          routes: [
            GoRoute(
              path: '/calendar',
              name: 'child-calendar',
              builder: (context, state) => const ChildMainScreen(), // Navegará al tab del calendario
            ),
            GoRoute(
              path: '/recommendations',
              name: 'child-recommendations',
              builder: (context, state) => const ChildRecommendationScreen(),
            ),
            GoRoute(
              path: '/pet',
              name: 'child-pet',
              builder: (context, state) => const Scaffold(
                body: Center(child: Text('Mascota - En desarrollo')),
              ),
            ),
            GoRoute(
              path: '/communication',
              name: 'child-communication',
              builder: (context, state) => const Scaffold(
                body: Center(child: Text('Comunicación - En desarrollo')),
              ),
            ),
          ],
        ),
      ],
    ),

    // ===== RUTAS DEL PADRE/APODERADO =====
    ShellRoute(
      builder: (context, state, child) {
        return child; // Aquí puedes agregar un Scaffold común para padres si es necesario
      },
      routes: [
        GoRoute(
          path: '/parent',
          name: 'parent-home',
          builder: (context, state) => const ParentMainScreen(),
          routes: [
            GoRoute(
              path: '/dashboard',
              name: 'parent-dashboard',
              builder: (context, state) => const Scaffold(
                body: Center(child: Text('Dashboard del Apoderado - En desarrollo')),
              ),
            ),
            GoRoute(
              path: '/child-progress',
              name: 'parent-child-progress',
              builder: (context, state) => const Scaffold(
                body: Center(child: Text('Progreso del Niño - En desarrollo')),
              ),
            ),
            GoRoute(
              path: '/emergency-contacts',
              name: 'parent-emergency-contacts',
              builder: (context, state) => const Scaffold(
                body: Center(child: Text('Contactos de Emergencia - En desarrollo')),
              ),
            ),
            GoRoute(
              path: '/settings',
              name: 'parent-settings',
              builder: (context, state) => const Scaffold(
                body: Center(child: Text('Configuración - En desarrollo')),
              ),
            ),
          ],
        ),
      ],
    ),

    // ===== RUTA DE ERROR =====
    GoRoute(
      path: '/error',
      name: 'error',
      builder: (context, state) => Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              const Text('¡Oops! Algo salió mal'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => context.go('/'),
                child: const Text('Volver al inicio'),
              ),
            ],
          ),
        ),
      ),
    ),
  ],
  
  // Manejo de errores
  errorBuilder: (context, state) => Scaffold(
    appBar: AppBar(title: const Text('Página no encontrada')),
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.search_off, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          Text('No se encontró la página: ${state.uri.path}'),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => context.go('/'),
            child: const Text('Ir al inicio'),
          ),
        ],
      ),
    ),
  ),
);