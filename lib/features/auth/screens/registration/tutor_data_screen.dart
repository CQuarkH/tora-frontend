import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:tora_frontend/core/theme/tora_theme.dart';

class TutorDataScreen extends HookWidget {
  final Function(Map<String, dynamic>) onNext;
  final VoidCallback onPrevious;
  final Map<String, dynamic> initialData;

  const TutorDataScreen({
    super.key,
    required this.onNext,
    required this.onPrevious,
    required this.initialData,
  });

  @override
  Widget build(BuildContext context) {
    final formKey = useMemoized(() => GlobalKey<FormState>());
    final parentNameController = useTextEditingController(
      text: initialData['parentName'] ?? '',
    );
    final phoneController = useTextEditingController(
      text: initialData['parentPhone'] ?? '+56 9 ',
    );
    final emailController = useTextEditingController(
      text: initialData['parentEmail'] ?? '',
    );

    void handleNext() {
      // if (formKey.currentState?.validate() ?? false) {
        final data = {
          'parentName': parentNameController.text.trim(),
          'parentPhone': phoneController.text.trim(),
          'parentEmail': emailController.text.trim(),
        };
        onNext(data);
      // }
    }

    String? validatePhone(String? value) {
      if (value?.isEmpty ?? true) return 'El teléfono es obligatorio';
      
      // Verificar que tenga el prefijo correcto
      if (!value!.startsWith('+56 9 ')) return 'Debe comenzar con +56 9';
      
      // Verificar longitud mínima (prefijo + al menos 8 dígitos)
      if (value.length < 14) return 'Número incompleto';
      
      return null;
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
                  color: context.mintGreen.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.person,
                  size: 50,
                  color: context.mintGreen,
                ),
              ),
            ),
            const SizedBox(height: 24),
            
            Center(
              child: Text(
                'Datos del Padre/Tutor',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: context.darkText,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 8),
            
            Center(
              child: Text(
                'Información del responsable del niño',
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
                  // Nombre completo
                  Text(
                    'Nombre Completo',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: context.darkText,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: parentNameController,
                    decoration: InputDecoration(
                      hintText: 'Ej: María González',
                      prefixIcon: Icon(Icons.person_outline, color: context.mediumText),
                    ),
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'El nombre es obligatorio';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  // Teléfono con prefijo protegido
                  Text(
                    'Teléfono',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: context.darkText,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    onChanged: (value) {
                      // Proteger el prefijo +56 9 
                      if (!value.startsWith('+56 9 ')) {
                        phoneController.text = '+56 9 ';
                        phoneController.selection = TextSelection.fromPosition(
                          TextPosition(offset: phoneController.text.length),
                        );
                      }
                    },
                    decoration: InputDecoration(
                      hintText: '+56 9 12345678',
                      prefixIcon: Icon(Icons.phone, color: context.mediumText),
                    ),
                    validator: validatePhone,
                  ),
                  const SizedBox(height: 20),

                  // Email
                  Text(
                    'Correo Electrónico',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: context.darkText,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      hintText: 'ejemplo@correo.com',
                      prefixIcon: Icon(Icons.email_outlined, color: context.mediumText),
                    ),
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'El correo es obligatorio';
                      }
                      if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value!)) {
                        return 'Ingresa un correo válido';
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