// period_selector_section.dart
import 'package:flutter/material.dart';
import 'package:tora_frontend/features/child/models/calendar.dart';
import 'package:tora_frontend/features/child/widgets/period_option.dart';

class PeriodSelectorSection extends StatelessWidget {
  final Period selectedPeriod;
  final ValueChanged<Period> onPeriodChanged;

  const PeriodSelectorSection({
    super.key,
    required this.selectedPeriod,
    required this.onPeriodChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10.0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '¿Qué momento del día es?',
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16.0),
          Row(
            children: Period.values.map((period) {
              final isSelected = selectedPeriod == period;
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: PeriodOption(
                    period: period,
                    isSelected: isSelected,
                    onTap: () => onPeriodChanged(period),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
