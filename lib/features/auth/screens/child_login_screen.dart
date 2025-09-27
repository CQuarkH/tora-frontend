import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:tora_frontend/features/auth/widgets/login_card.dart';

class ChildLoginScreen extends HookWidget {
  const ChildLoginScreen({super.key});

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
              Colors.blue[100]!,
              Colors.blue[50]!,
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
                const SizedBox(height: 40),
                
                // Título específico para niños
                Text(
                  '¡Pequeño explorador!',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[800],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Inicia sesión para continuar tu aventura',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.blue[600],
                  ),
                  textAlign: TextAlign.center,
                ),
                
                const SizedBox(height: 30),
                LoginCard(
                  emailController: emailController,
                  passwordController: passwordController,
                  obscureText: obscureText,
                  onLogin: () => _handleChildLogin(context, emailController.text, passwordController.text),
                  showCreateAccount: false, // No mostrar opción de registro para niños
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleChildLogin(BuildContext context, String email, String password) {
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

    // Lógica específica para login de niños
    // Aquí puedes agregar validaciones específicas para niños
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('¡Bienvenido de vuelta, pequeño aventurero!'),
        backgroundColor: Colors.green,
      ),
    );

    // Navegación específica para niños después del login exitoso
    // TODO: Agregar lógica de autenticación real
    // context.go('/child');
  }
}