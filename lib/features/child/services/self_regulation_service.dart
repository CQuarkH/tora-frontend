import 'package:flutter/material.dart';
import 'package:tora_frontend/core/theme/tora_theme.dart';
import 'package:tora_frontend/features/child/models/regulation_strategy.dart';
import 'package:tora_frontend/features/child/widgets/emergency_alert_modal.dart';
import 'package:tora_frontend/features/child/widgets/feedback_modal.dart';
import 'package:tora_frontend/features/child/widgets/strategy_modal.dart';

class SelfRegulationService {
  static void showRegulationFlow(BuildContext context) {
    _showStrategyModal(context, attemptNumber: 0);
  }

  static void _showStrategyModal(
    BuildContext context, {
    required int attemptNumber,
  }) {
    if (attemptNumber >= 3) {
      _showEmergencyAlert(context);
      return;
    }

    final strategy = RegulationStrategiesData.getStrategy(attemptNumber);

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      isDismissible: false,
      enableDrag: false,
      builder: (modalContext) => StrategyModal(
        strategy: strategy,
        attemptNumber: attemptNumber,
        onCompleted: () {
          Navigator.of(modalContext).pop();
          _showFeedbackModal(context, strategy, attemptNumber);
        },
      ),
    );
  }

  static void _showFeedbackModal(
    BuildContext context,
    RegulationStrategy strategy,
    int attemptNumber,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      isDismissible: false,
      enableDrag: false,
      builder: (modalContext) => FeedbackModal(
        strategy: strategy,
        onYes: () {
          Navigator.of(modalContext).pop();
          _showSuccessDialog(context);
        },
        onNo: () {
          Navigator.of(modalContext).pop();
          _showStrategyModal(context, attemptNumber: attemptNumber + 1);
        },
      ),
    );
  }

  static void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF4CAF50).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle,
                  color: Color(0xFF4CAF50),
                  size: 64,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                '¡Muy bien!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: ToraTheme.darkText,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Me alegra que te sientas mejor. Recuerda que siempre puedes volver a usar estas estrategias.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: ToraTheme.mediumText,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4CAF50),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: const Text(
                    'Continuar',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static void _showEmergencyAlert(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      isDismissible: false,
      enableDrag: false,
      builder: (modalContext) =>
          EmergencyAlertModal(onClose: () => Navigator.of(modalContext).pop()),
    );
  }
}
