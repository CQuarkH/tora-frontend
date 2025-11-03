// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:tora_frontend/features/auth/models/user.dart';
import 'package:tora_frontend/features/auth/services/auth_service.dart';
import 'package:tora_frontend/features/auth/widgets/login_card.dart';

class ChildLoginScreen extends HookWidget {
  const ChildLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();
    final obscureText = useState(true);
    final _authService = useMemoized(() => AuthService());

    Future<void> _handleLogin() async {
      if (emailController.text.isNotEmpty &&
          passwordController.text.isNotEmpty) {
        try {
          final loginResponse = await _authService.login(
            email: emailController.text.trim(),
            password: passwordController.text,
          );

          // Verificar que sea un niño
          if (loginResponse.user.role != UserRole.CHILD) {
            await _authService.logout();
            return;
          }

          context.go('/child');
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error de inicio de sesión: $e')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Por favor, completa todos los campos')),
        );
      }
    }

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue[100]!, Colors.blue[50]!, Colors.white],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back),
                    color: Colors.blue[800],
                    iconSize: 30,
                    onPressed: () => context.go('/'),
                  ),
                ),
                const SizedBox(height: 30),

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
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(color: Colors.blue[600]),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 30),
                LoginCard(
                  emailController: emailController,
                  passwordController: passwordController,
                  obscureText: obscureText,
                  onLogin: () => _handleLogin(),
                  showCreateAccount:
                      false, // No mostrar opción de registro para niños
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}