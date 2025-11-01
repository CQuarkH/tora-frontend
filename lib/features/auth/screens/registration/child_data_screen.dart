import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';
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
    final grades = ['3° Básico', '4° Básico', '5° Básico'];

    // Asegurar que el valor inicial sea válido o null
    final initialGrade = initialData['childGrade'] as String?;
    final validInitialGrade = grades.contains(initialGrade)
        ? initialGrade
        : null;
    final selectedGrade = useState<String?>(validInitialGrade);
    final childEmailController = useTextEditingController(
      text: initialData['childEmail'] ?? '',
    );

    void handleNext() {
      // Validar nombre
      if (childNameController.text.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Por favor ingresa el nombre del niño'),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }

      // Validar edad
      final age = int.tryParse(ageController.text.trim());
      if (age == null || age < 7 || age > 12) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('La edad debe estar entre 7 y 12 años'),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }

      // Validar grado
      if (selectedGrade.value == null || selectedGrade.value!.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Por favor selecciona el grado escolar'),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }

      // Validar email
      final email = childEmailController.text.trim();
      if (email.isEmpty || !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Por favor ingresa un email válido para el niño'),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }

      final data = {
        'childName': childNameController.text.trim(),
        'childAge': age,
        'childGrade': selectedGrade.value,
        'childEmail': email,
      };
      onNext(data);
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final isTablet = constraints.maxWidth > 600;
        final horizontalPadding = isTablet ? 48.0 : 16.0;
        final maxWidth = isTablet ? 600.0 : double.infinity;
        final isSmallScreen = constraints.maxWidth < 450;

        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: 24,
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxWidth),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: SvgPicture.asset(
                        'assets/images/characters/tora_mano_arriba_saludo.svg',
                        height: isTablet ? 250 : 180,
                        width: isTablet ? 250 : 180,
                      ),
                    ),
                    const SizedBox(height: 16),

                    Center(
                      child: Text(
                        'Cuéntanos sobre tu \nhijo o hija',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: isTablet ? 36 : 28,
                          fontWeight: FontWeight.w900,
                          color: context.darkText,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),

                    Center(
                      child: Text(
                        'Completa algunos datos para personalizar su experiencia',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: isTablet ? 18 : 16,
                          fontWeight: FontWeight.w400,
                          color: context.mediumText,
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),

                    Container(
                      padding: EdgeInsets.all(isTablet ? 32 : 20),
                      decoration: BoxDecoration(
                        color: context.pureWhite,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: ToraTheme.cardShadow,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Nombre Completo',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(
                                  color: context.darkText,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: childNameController,
                            decoration: InputDecoration(
                              hintText: 'Ej: María José González',
                              prefixIcon: Icon(
                                Icons.person,
                                color: context.mediumText,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),

                          if (isSmallScreen) ...[
                            Text(
                              'Edad',
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(
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
                                prefixIcon: Icon(
                                  Icons.cake,
                                  color: context.mediumText,
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Text(
                              'Grado Escolar',
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(
                                    color: context.darkText,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                            const SizedBox(height: 8),
                            DropdownButtonFormField<String>(
                              value: selectedGrade.value,
                              decoration: InputDecoration(
                                hintText: 'Selecciona uno',
                                prefixIcon: Icon(
                                  Icons.school,
                                  color: context.mediumText,
                                ),
                              ),
                              items: grades.map((String grade) {
                                return DropdownMenuItem<String>(
                                  value: grade,
                                  child: Text(grade),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                selectedGrade.value = newValue;
                              },
                            ),
                          ] else ...[
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Edad',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium
                                            ?.copyWith(
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
                                          prefixIcon: Icon(
                                            Icons.cake,
                                            color: context.mediumText,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Grado Escolar',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium
                                            ?.copyWith(
                                              color: context.darkText,
                                              fontWeight: FontWeight.w600,
                                            ),
                                      ),
                                      const SizedBox(height: 8),
                                      DropdownButtonFormField<String>(
                                        value: selectedGrade.value,
                                        decoration: InputDecoration(
                                          hintText: 'Selecciona uno',
                                          prefixIcon: Icon(
                                            Icons.school,
                                            color: context.mediumText,
                                          ),
                                        ),
                                        items: grades.map((String grade) {
                                          return DropdownMenuItem<String>(
                                            value: grade,
                                            child: Text(grade),
                                          );
                                        }).toList(),
                                        onChanged: (String? newValue) {
                                          selectedGrade.value = newValue;
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                          const SizedBox(height: 20),

                          Text(
                            'Correo Electrónico',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(
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
                              prefixIcon: Icon(
                                Icons.email,
                                color: context.mediumText,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),

                    if (isSmallScreen && onBack != null) ...[
                      Column(
                        children: [
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton(
                              onPressed: onBack,
                              child: Text('Volver'),
                            ),
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: handleNext,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: context.warmYellow,
                              ),
                              child: Text('Siguiente'),
                            ),
                          ),
                        ],
                      ),
                    ] else ...[
                      Row(
                        children: [
                          if (onBack != null) ...[
                            Expanded(
                              child: OutlinedButton(
                                onPressed: onBack,
                                child: Text('Volver'),
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
                              ),
                              child: Text('Siguiente'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
