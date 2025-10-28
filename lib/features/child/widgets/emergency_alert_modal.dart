import 'package:flutter/material.dart';
import 'package:tora_frontend/core/theme/tora_theme.dart';

class EmergencyAlertModal extends StatelessWidget {
  final VoidCallback onClose;

  const EmergencyAlertModal({super.key, required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      decoration: BoxDecoration(
        color: ToraTheme.pureWhite,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: Column(
        children: [
          // Handle
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: ToraTheme.lightGray,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 32),

          // Ícono de alerta
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFFFF5252).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.emergency,
              color: Color(0xFFFF5252),
              size: 64,
            ),
          ),

          const SizedBox(height: 24),

          // Título
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              'Alerta de Emergencia',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: ToraTheme.darkText,
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Mensaje
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFFF5252).withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: const Color(0xFFFF5252).withOpacity(0.3),
                  width: 2,
                ),
              ),
              child: const Column(
                children: [
                  Text(
                    'Se ha enviado una notificación a tu tutor y docente. Alguien vendrá a ayudarte pronto.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: ToraTheme.darkText,
                      height: 1.5,
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Mantén la calma, la ayuda está en camino.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: ToraTheme.mediumText,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const Spacer(),

          // Botón cerrar
          Padding(
            padding: const EdgeInsets.all(24),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onClose,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF5252),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  elevation: 2,
                ),
                child: const Text(
                  'Cerrar',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
