import 'package:flutter/material.dart';
import 'package:tora_frontend/features/child/models/calendar.dart';

class PeriodInfoSection extends StatelessWidget {
  final Period period;
  final String childName;
  final String blockId;

  const PeriodInfoSection({
    super.key,
    required this.period,
    required this.childName,
    required this.blockId,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: period.backgroundColor,
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Column(
        children: [
          Text(period.emoji, style: const TextStyle(fontSize: 32.0)),
          const SizedBox(height: 8.0),
          Text(
            '${period.displayName} - $childName',
            style: const TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4.0),
          Text(
            'Bloque ID: $blockId',
            style: TextStyle(fontSize: 12.0, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }
}
