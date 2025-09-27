import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:tora_frontend/features/auth/widgets/login_card.dart';
import 'package:tora_frontend/core/router/router.dart';

class ParentLoginScreen extends HookWidget {
  const ParentLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();
    final obscureText = useState(true);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.green[100]!,
              Colors.green[50]!,
              Colors.white,
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                //icono para volver a la pantalla anterior
                Container(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  color: Colors.green[800],
                  iconSize: 30,
                  onPressed: () => context.go('/'),
                ),
                ),
                const SizedBox(height: 30),
                
               
                Text(
                  'Bienvenido, Tutor',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.green[800],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Gestiona y supervisa el progreso de tu hijo/a',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.green[600],
                  ),
                  textAlign: TextAlign.center,
                ),
                
                const SizedBox(height: 30),
                LoginCard(
                  emailController: emailController,
                  passwordController: passwordController,
                  obscureText: obscureText,
                  onLogin: () => _handleParentLogin(context, emailController.text, passwordController.text),
                  onCreateAccount: () => _handleCreateAccount(context),
                  showCreateAccount: true, // Mostrar opción de registro para padres
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleParentLogin(BuildContext context, String email, String password) {
    // Validación básica
    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, completa todos los campos'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // Lógica específica para login de padres
    // Actualizar el estado del usuario
    UserSession.setUserType(UserType.parent);
    
    // Mostrar mensaje de éxito
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('¡Bienvenido! Iniciando sesión...'),
        backgroundColor: Colors.green,
      ),
    );

    // Navegar a la vista principal del padre
    context.go('/parent');
  }

  void _handleCreateAccount(BuildContext context) {
    // Navegar al proceso de registro
    context.go('/register-step-one');
  }
}