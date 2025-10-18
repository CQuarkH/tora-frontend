import 'package:flutter/material.dart';
import '../../../../../core/theme/tora_theme.dart';

class SearchBarWidget extends StatelessWidget {
  final String hintText;
  final Function(String)? onChanged;
  final TextEditingController? controller;

  const SearchBarWidget({
    Key? key,
    this.hintText = 'Buscar tema...',
    this.onChanged,
    this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: ToraTheme.pureWhite,
        borderRadius: BorderRadius.circular(25),
        boxShadow: ToraTheme.cardShadow,
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            color: ToraTheme.lightText,
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
          prefixIcon: const Padding(
            padding: EdgeInsets.only(left: 20, right: 12),
            child: Text(
              '🔍',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
          ),
          prefixIconConstraints: const BoxConstraints(
            minWidth: 0,
            minHeight: 0,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: ToraTheme.pureWhite,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),
        ),
        style: const TextStyle(
          fontSize: 16,
          color: ToraTheme.darkText,
        ),
      ),
    );
  }
}