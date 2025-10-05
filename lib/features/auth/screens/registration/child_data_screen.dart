import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:tora_frontend/core/theme/tora_theme.dart';

class ChildDataScreen extends HookWidget {
  final Function(Map<String, dynamic>) onNext;
  final VoidCallback? onBack;
  final Map<String, dynamic> initialData;

  const ChildDataScreen({
    super.key,
    required this.onNext,
    this.onBack,
    required this.initialData,
  });

  @override
  Widget build(BuildContext context) {
    final formKey = useMemoized(() => GlobalKey<FormState>());
    final childNameController = useTextEditingController(
      text: initialData['childName'] ?? '',
    );
    final ageController = useTextEditingController(
      text: initialData['childAge']?.toString() ?? '',
    );
    final gradeController = useTextEditingController(
      text: initialData['childGrade'] ?? '',
    );
    final childEmailController = useTextEditingController(
      text: initialData['childEmail'] ?? '',
    );

    void handleNext() {
      // if (formKey.currentState?.validate() ?? false) {
        final data = {
          'childName': childNameController.text.trim(),
          'childAge': int.tryParse(ageController.text.trim()) ?? 0,
          'childGrade': gradeController.text.trim(),
          'childEmail': childEmailController.text.trim(),
        };
        onNext(data);
      // }
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icono y descripción
            Center(
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: context.softBlue.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.child_care,
                  size: 50,
                  color: context.darkText,
                ),
              ),
            ),
            const SizedBox(height: 24),
            
            Center(
              child: Text(
                'Datos del Niño/a',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: context.darkText,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 8),
            
            Center(
              child: Text(
                'Información básica del menor',
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
                    controller: childNameController,
                    decoration: InputDecoration(
                      hintText: 'Ej: María José González',
                      prefixIcon: Icon(Icons.person, color: context.mediumText),
                    ),
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'El nombre es obligatorio';
                      }
                      if (value!.length < 2) {
                        return 'El nombre debe tener al menos 2 caracteres';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  // Edad y Grado
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Edad',
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: context.darkText,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextFormField(
                              controller: ageController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                hintText: '8',
                                prefixIcon: Icon(Icons.cake, color: context.mediumText),
                              ),
                              validator: (value) {
                                if (value?.isEmpty ?? true) {
                                  return 'La edad es obligatoria';
                                }
                                final age = int.tryParse(value!);
                                if (age == null || age < 3 || age > 18) {
                                  return 'Edad: 3-18 años';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Grado Escolar',
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: context.darkText,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextFormField(
                              controller: gradeController,
                              decoration: InputDecoration(
                                hintText: '3° Básico',
                                prefixIcon: Icon(Icons.school, color: context.mediumText),
                              ),
                              validator: (value) {
                                if (value?.isEmpty ?? true) {
                                  return 'El grado es obligatorio';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Email del niño
                  Text(
                    'Correo Electrónico',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: context.darkText,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: childEmailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      hintText: 'maria.gonzalez@email.com',
                      prefixIcon: Icon(Icons.email, color: context.mediumText),
                    ),
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'El correo es obligatorio';
                      }
                      final emailRegex = RegExp(r'^[\\w-\\.]+@([\\w-]+\\.)+[\\w-]{2,4}$');
                      if (!emailRegex.hasMatch(value!)) {
                        return 'Ingresa un correo válido';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Botones de navegación
            Row(
              children: [
                if (onBack != null) ...[
                  Expanded(
                    child: OutlinedButton(
                      onPressed: onBack,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: context.mediumText,
                        side: BorderSide(color: context.lightGray),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Volver',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: context.mediumText,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                ],
                Expanded(
                  flex: onBack != null ? 2 : 1,
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
                      'Siguiente',
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
    );
  }
}