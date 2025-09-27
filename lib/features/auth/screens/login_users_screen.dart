import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:tora_frontend/features/auth/widgets/login_card.dart';

class LoginUsersScreen extends HookWidget {
  final bool showCreateAccount;
  
  const LoginUsersScreen({
    super.key,
    this.showCreateAccount = true,
  });

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
                    onCreateAccount: showCreateAccount ? () => _handleCreateAccount(context) : null,
                    showCreateAccount: showCreateAccount,
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

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('¡Iniciando sesión...!'),
        backgroundColor: Colors.green,
      ),
    );

  }

  void _handleCreateAccount(BuildContext context) {
    context.go('/register-step-one');

   
  }
}
