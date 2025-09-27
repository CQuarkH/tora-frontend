// EJEMPLO DE USO DE GO_ROUTER EN TUS PANTALLAS
// Copia estos ejemplos en tus pantallas correspondientes

// ===== EN LOGIN_USERS_SCREEN.dart =====
/*
import 'package:tora_frontend/core/router/app_navigation.dart';

// En el método _handleLogin después de validar credenciales:
void _handleLogin(BuildContext context, String email, String password) {
  // ... validaciones ...
  
  // Determinar el tipo de usuario basado en el email o respuesta del servidor
  if (email.contains('child') || email.contains('estudiante')) {
    AppNavigation.loginAsChild(context);
  } else {
    AppNavigation.loginAsParent(context);
  }
}

// En el método _handleCreateAccount:
void _handleCreateAccount(BuildContext context) {
  AppNavigation.goToRegister(context);
}
*/

// ===== EN REGISTER_USER_STEP_ONE_SCREEN.dart =====
/*
import 'package:tora_frontend/core/router/app_navigation.dart';

// En el método _handleNext:
void _handleNext(BuildContext context, ...) {
  // ... validaciones ...
  
  // Ir al siguiente paso del registro
  AppNavigation.goToRegisterStepTwo(context);
}
*/

// ===== EN REGISTER_USER_STEP_TWO_SCREEN.dart =====
/*
import 'package:tora_frontend/core/router/app_navigation.dart';

// En el método _createAccount:
void _createAccount(BuildContext context, List<Map<String, String>> contacts) {
  // ... validaciones ...
  
  // Después de crear la cuenta exitosamente, ir al login
  AppNavigation.goToLogin(context);
  // O si quieres que se loguee automáticamente:
  // AppNavigation.loginAsParent(context); // Asumiendo que el registro es para padres
}
*/

// ===== EN CHILD_MAIN_SCREEN.dart =====
/*
import 'package:tora_frontend/core/router/app_navigation.dart';

// Para navegación entre tabs del niño:
void _navigateToTab(String tab) {
  switch (tab) {
    case 'calendar':
      AppNavigation.goToChildCalendar(context);
      break;
    case 'recommendations':
      AppNavigation.goToChildRecommendations(context);
      break;
    case 'pet':
      AppNavigation.goToChildPet(context);
      break;
    case 'communication':
      AppNavigation.goToChildCommunication(context);
      break;
  }
}

// Para logout:
void _logout() {
  AppNavigation.logout(context);
}
*/

// ===== PANTALLA DE APODERADO (cuando la crees) =====
/*
import 'package:tora_frontend/core/router/app_navigation.dart';

class ParentMainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard Apoderado'),
        actions: [
          IconButton(
            onPressed: () => AppNavigation.logout(context),
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Column(
        children: [
          ListTile(
            title: const Text('Dashboard'),
            onTap: () => AppNavigation.goToParentDashboard(context),
          ),
          ListTile(
            title: const Text('Progreso del Niño'),
            onTap: () => AppNavigation.goToChildProgress(context),
          ),
          ListTile(
            title: const Text('Contactos de Emergencia'),
            onTap: () => AppNavigation.goToEmergencyContacts(context),
          ),
          ListTile(
            title: const Text('Configuración'),
            onTap: () => AppNavigation.goToParentSettings(context),
          ),
        ],
      ),
    );
  }
}
*/