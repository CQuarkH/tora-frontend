import 'package:flutter/material.dart';
import 'package:tora_frontend/features/auth/widgets/tiger_mascot.dart';
import 'package:tora_frontend/features/auth/widgets/welcome_text.dart';
import 'package:tora_frontend/features/auth/widgets/login_form.dart';
import 'package:tora_frontend/features/auth/widgets/login_button.dart';
import 'package:tora_frontend/features/auth/widgets/create_account_button.dart';

class LoginCard extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final ValueNotifier<bool> obscureText;
  final VoidCallback onLogin;
  final VoidCallback? onCreateAccount;
  final bool showCreateAccount;

  const LoginCard({
    super.key,
    required this.emailController,
    required this.passwordController,
    required this.obscureText,
    required this.onLogin,
    this.onCreateAccount,
    this.showCreateAccount = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          const TigerMascot(),
          const SizedBox(height: 24),
          const WelcomeText(),
          const SizedBox(height: 32),
          LoginForm(
            emailController: emailController,
            passwordController: passwordController,
            obscureText: obscureText,
          ),
          const SizedBox(height: 32),
          LoginButton(onPressed: onLogin),
          if (showCreateAccount) ...[
            const SizedBox(height: 24),
            CreateAccountButton(
              onPressed: onCreateAccount,
            ),
          ],
        ],
      ),
    );
  }
}