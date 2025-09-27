import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:tora_frontend/features/auth/widgets/login_card.dart';

class LoginUsersScreen extends HookWidget {
  const LoginUsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();
    final obscureText = useState(true);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFE8F5E8),
              Color(0xFFF0F8FF),
              Color(0xFFFFF8E1),
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 60),
                  LoginCard(
                    emailController: emailController,
                    passwordController: passwordController,
                    obscureText: obscureText,
                    onLogin: () => _handleLogin(context, emailController.text, passwordController.text),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _handleLogin(BuildContext context, String email, String password) {
    // Basic validation
    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, completa todos los campos'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // For now, just show a success message
    // In a real app, you would validate credentials with your backend
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('¡Iniciando sesión...!'),
        backgroundColor: Colors.green,
      ),
    );

    // TODO: Navigate to the appropriate screen after successful login
    // Navigator.of(context).pushReplacement(
    //   MaterialPageRoute(builder: (context) => const ForkUsersScreen()),
    // );
  }
}
