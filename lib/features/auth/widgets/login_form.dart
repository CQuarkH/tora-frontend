import 'package:flutter/material.dart';
import 'package:tora_frontend/features/auth/widgets/custom_text_field.dart';

class LoginForm extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final ValueNotifier<bool> obscureText;

  const LoginForm({
    super.key,
    required this.emailController,
    required this.passwordController,
    required this.obscureText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomTextField(
          controller: emailController,
          hintText: 'Correo',
          prefixIcon: Icons.email_outlined,
          keyboardType: TextInputType.emailAddress,
          backgroundColor: const Color(0xFFE3F2FD),
          borderColor: const Color(0xFFBBDEFB),
          iconColor: const Color(0xFF2196F3),
        ),
        const SizedBox(height: 16),
        ValueListenableBuilder<bool>(
          valueListenable: obscureText,
          builder: (context, isObscured, _) {
            return CustomTextField(
              controller: passwordController,
              hintText: 'Contraseña',
              prefixIcon: Icons.lock_outline,
              obscureText: isObscured,
              backgroundColor: const Color(0xFFE8F5E8),
              borderColor: const Color(0xFFC8E6C9),
              iconColor: const Color(0xFF4CAF50),
              suffixIcon: IconButton(
                icon: Icon(
                  isObscured
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: const Color(0xFF4CAF50),
                ),
                onPressed: () {
                  obscureText.value = !obscureText.value;
                },
              ),
            );
          },
        ),
      ],
    );
  }
}