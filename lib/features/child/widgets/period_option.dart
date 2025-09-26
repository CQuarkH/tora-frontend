import 'package:flutter/material.dart';
import 'package:tora_frontend/features/child/models/calendar.dart';

class PeriodOption extends StatelessWidget {
  final Period period;
  final bool isSelected;
  final VoidCallback onTap;

  const PeriodOption({
    super.key,
    required this.period,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        decoration: BoxDecoration(
          color: period.backgroundColor,
          border: Border.all(
            color: isSelected
                ? period.borderColor
                : period.borderColor.withOpacity(0.3),
            width: isSelected ? 2.0 : 1.0,
          ),
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Column(
          children: [
            Text(period.emoji, style: const TextStyle(fontSize: 24.0)),
            const SizedBox(height: 8.0),
            Text(
              period.displayName,
              style: TextStyle(
                fontSize: 14.0,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
