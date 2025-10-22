import 'package:flutter/material.dart';
import 'package:tora_frontend/core/theme/tora_theme.dart';
import 'package:tora_frontend/features/parent/models/parent_tip.dart';

class ParentTipCard extends StatelessWidget {
  final ParentTip tip;

  const ParentTipCard({super.key, required this.tip});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [tip.color.withOpacity(0.1), tip.color.withOpacity(0.05)],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: tip.color.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(tip.icon, color: tip.color, size: 28),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      tip.title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: ToraTheme.darkText,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                tip.description,
                style: TextStyle(
                  fontSize: 15,
                  color: ToraTheme.darkText.withOpacity(0.8),
                  height: 1.5,
                ),
              ),
              if (tip.actionText != null) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: tip.color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: tip.color.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.lightbulb_outline, color: tip.color, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          tip.actionText!,
                          style: TextStyle(
                            fontSize: 14,
                            color: tip.color,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
