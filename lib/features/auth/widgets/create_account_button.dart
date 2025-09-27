import 'package:flutter/material.dart';

class CreateAccountButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  final Color backgroundColor;
  final Color textColor;
  final Color borderColor;

  const CreateAccountButton({
    super.key,
    this.onPressed,
    this.text = '¿No tienes cuenta? Crear cuenta',
    this.backgroundColor = Colors.transparent,
    this.textColor = const Color(0xFF2196F3),
    this.borderColor = const Color(0xFF2196F3),
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: textColor,
          padding: const EdgeInsets.symmetric(vertical: 16),
         
        ),
        
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}