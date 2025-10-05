import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:tora_frontend/core/theme/tora_theme.dart';

class PasswordSetupScreen extends HookWidget {
  final Function(Map<String, dynamic>) onNext;
  final VoidCallback onPrevious;
  final Map<String, dynamic> initialData;

  const PasswordSetupScreen({
    super.key,
    required this.onNext,
    required this.onPrevious,
    required this.initialData,
  });

  @override
  Widget build(BuildContext context) {
    final formKey = useMemoized(() => GlobalKey<FormState>());
    
    // Una sola contraseña para ambos usuarios
    final passwordController = useTextEditingController(
      text: initialData['password'] ?? '',
    );
    final confirmPasswordController = useTextEditingController();

    void handleNext() {
      // if (formKey.currentState?.validate() ?? false) {
        // Validar que las contraseñas coincidan
        // if (passwordController.text != confirmPasswordController.text) {
        //   ScaffoldMessenger.of(context).showSnackBar(
        //     const SnackBar(
        //       content: Text('Las contraseñas no coinciden'),
        //       backgroundColor: Colors.red,
        //     ),
        //   );
        //   return;
        // }

        final data = {
          'password': passwordController.text.trim(),
        };
        onNext(data);
      // }
    }

    return Container(
      color: const Color(0xFFFFFBEF), // Fondo crema cálido
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Ícono y título
            Center(
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.security,
                  size: 50,
                  color: Colors.blue[700],
                ),
              ),
            ),
            const SizedBox(height: 24),
            
            Center(
              child: Text(
                'Configurar Contraseña',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: context.darkText,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 8),
            
            Center(
              child: Text(
                'Esta contraseña será usada para ambas cuentas',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: context.mediumText,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 32),

            // Formulario
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: context.pureWhite,
                borderRadius: BorderRadius.circular(16),
                boxShadow: ToraTheme.cardShadow,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Contraseña
                  Text(
                    'Contraseña',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: context.darkText,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: 'Mínimo 6 caracteres',
                      prefixIcon: Icon(Icons.lock, color: context.mediumText),
                    ),
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'La contraseña es obligatoria';
                      }
                      if (value!.length < 6) {
                        return 'Mínimo 6 caracteres';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Confirmar contraseña
                  Text(
                    'Confirmar Contraseña',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: context.darkText,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: confirmPasswordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: 'Confirma tu contraseña',
                      prefixIcon: Icon(Icons.lock_outline, color: context.mediumText),
                    ),
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Debes confirmar la contraseña';
                      }
                      if (value != passwordController.text) {
                        return 'Las contraseñas no coinciden';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Botones
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: onPrevious,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: context.mediumText,
                      side: BorderSide(color: context.lightGray),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Anterior',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: context.mediumText,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: handleNext,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: context.warmYellow,
                      foregroundColor: context.darkText,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                    ),
                    child: Text(
                      'Continuar',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: context.darkText,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ));
  }
}