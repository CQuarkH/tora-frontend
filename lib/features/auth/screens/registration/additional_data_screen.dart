import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:tora_frontend/core/theme/tora_theme.dart';

class AdditionalDataScreen extends HookWidget {
  final Function(Map<String, dynamic>) onNext;
  final VoidCallback onPrevious;
  final Map<String, dynamic> initialData;

  const AdditionalDataScreen({
    super.key,
    required this.onNext,
    required this.onPrevious,
    required this.initialData,
  });

  @override
  Widget build(BuildContext context) {
    final formKey = useMemoized(() => GlobalKey<FormState>());
    final relationshipController = useTextEditingController(
      text: initialData['relationship'] ?? '',
    );
    final occupationController = useTextEditingController(
      text: initialData['occupation'] ?? '',
    );
    final medicalInfoController = useTextEditingController(
      text: initialData['medicalInfo'] ?? '',
    );
    final allergiesController = useTextEditingController(
      text: initialData['allergies'] ?? '',
    );
    final emergencyInstructionsController = useTextEditingController(
      text: initialData['emergencyInstructions'] ?? '',
    );

    void handleNext() {
      if (formKey.currentState?.validate() ?? false) {
        final data = {
          'relationship': relationshipController.text.trim(),
          'occupation': occupationController.text.trim(),
          'medicalInfo': medicalInfoController.text.trim(),
          'allergies': allergiesController.text.trim(),
          'emergencyInstructions': emergencyInstructionsController.text.trim(),
        };
        onNext(data);
      }
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
                  color: context.warmYellow.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.info,
                  size: 50,
                  color: context.darkText,
                ),
              ),
            ),
            const SizedBox(height: 24),
            
            Center(
              child: Text(
                'Información Adicional',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: context.darkText,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 8),
            
            Center(
              child: Text(
                'Datos importantes para el cuidado y bienestar del menor',
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
                  // Relación con el menor
                  Text(
                    'Relación con el Menor',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: context.darkText,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: relationshipController.text.isEmpty ? null : relationshipController.text,
                    decoration: InputDecoration(
                      hintText: 'Selecciona la relación',
                      prefixIcon: Icon(Icons.family_restroom, color: context.mediumText),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'Padre', child: Text('Padre')),
                      DropdownMenuItem(value: 'Madre', child: Text('Madre')),
                      DropdownMenuItem(value: 'Tutor Legal', child: Text('Tutor Legal')),
                      DropdownMenuItem(value: 'Abuelo/a', child: Text('Abuelo/a')),
                      DropdownMenuItem(value: 'Tío/a', child: Text('Tío/a')),
                      DropdownMenuItem(value: 'Otro', child: Text('Otro')),
                    ],
                    onChanged: (value) {
                      relationshipController.text = value ?? '';
                    },
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'La relación es obligatoria';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  // Ocupación
                  Text(
                    'Ocupación',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: context.darkText,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: occupationController,
                    decoration: InputDecoration(
                      hintText: 'Ej: Profesor, Ingeniero, Médico, etc.',
                      prefixIcon: Icon(Icons.work, color: context.mediumText),
                    ),
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'La ocupación es obligatoria';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  // Información médica relevante
                  Text(
                    'Información Médica Relevante',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: context.darkText,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Condiciones médicas, medicamentos, o tratamientos importantes',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: context.lightText,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: medicalInfoController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: 'Ej: Asma, toma inhalador azul, TDAH en tratamiento...',
                      prefixIcon: Padding(
                        padding: const EdgeInsets.only(bottom: 40),
                        child: Icon(Icons.medical_services, color: context.mediumText),
                      ),
                    ),
                    // No es obligatorio pero es importante
                  ),
                  const SizedBox(height: 20),

                  // Alergias
                  Text(
                    'Alergias',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: context.darkText,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Alergias alimentarias, a medicamentos, o del ambiente',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: context.lightText,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: allergiesController,
                    maxLines: 2,
                    decoration: InputDecoration(
                      hintText: 'Ej: Alérgico a nueces, polen, penicilina...',
                      prefixIcon: Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: Icon(Icons.warning, color: context.mediumText),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Instrucciones de emergencia
                  Text(
                    'Instrucciones de Emergencia',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: context.darkText,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Qué hacer en caso de emergencia, números importantes, etc.',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: context.lightText,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: emergencyInstructionsController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: 'Ej: En caso de crisis, llamar al Dr. Pérez (123456789)...',
                      prefixIcon: Padding(
                        padding: const EdgeInsets.only(bottom: 40),
                        child: Icon(Icons.emergency, color: context.mediumText),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Botones de navegación
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