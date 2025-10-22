import 'package:flutter/material.dart';
import 'package:tora_frontend/core/theme/tora_theme.dart';
import 'package:tora_frontend/features/parent/models/parent_tip.dart';
import 'package:tora_frontend/features/parent/widgets/parent_tip_card.dart';

class ParentTipsScreen extends StatelessWidget {
  const ParentTipsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ToraTheme.pureWhite,
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: ParentTipsData.tips.length,
        itemBuilder: (context, index) {
          final tip = ParentTipsData.tips[index];
          return ParentTipCard(tip: tip);
        },
      ),
    );
  }
}
