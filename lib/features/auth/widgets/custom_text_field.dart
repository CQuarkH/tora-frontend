import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData prefixIcon;
  final Color backgroundColor;
  final Color borderColor;
  final Color iconColor;
  final TextInputType? keyboardType;
  final bool obscureText;
  final Widget? suffixIcon;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.prefixIcon,
    required this.backgroundColor,
    required this.borderColor,
    required this.iconColor,
    this.keyboardType,
    this.obscureText = false,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: borderColor,
          width: 1,
        ),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          hintText: hintText,
          prefixIcon: Icon(
            prefixIcon,
            color: iconColor,
          ),
          suffixIcon: suffixIcon,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(16),
          hintStyle: const TextStyle(
            color: Color(0xFF666666),
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}