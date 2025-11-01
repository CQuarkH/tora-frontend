import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:tora_frontend/core/theme/tora_theme.dart';
import 'package:tora_frontend/features/auth/screens/registration/child_data_screen.dart';
import 'package:tora_frontend/features/auth/screens/registration/tutor_data_screen.dart';
import 'package:tora_frontend/features/auth/screens/registration/password_setup_screen.dart';
import 'package:tora_frontend/features/auth/screens/registration/emergency_contacts_screen.dart';
import 'package:tora_frontend/features/auth/services/registration_service.dart';

class RegistrationFlowScreen extends HookWidget {
  const RegistrationFlowScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final pageController = usePageController();
    final currentStep = useState(0);
    final registrationData = useState<Map<String, dynamic>>({});
    final isLoading = useState(false);

    void nextStep(Map<String, dynamic> stepData) {
      registrationData.value = {...registrationData.value, ...stepData};

      if (currentStep.value < 3) {
        currentStep.value++;
        pageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    }

    void previousStep() {
      if (currentStep.value > 0) {
        currentStep.value--;
        pageController.previousPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    }

    Future<void> completeRegistration(Map<String, dynamic> finalData) async {
      // Combinar todos los datos
      final allData = {...registrationData.value, ...finalData};

      isLoading.value = true;

      try {
        final registrationService = RegistrationService();

        // Llamar al servicio de registro
        final result = await registrationService.registerParentAndChild(
          // Datos del padre
          parentName: allData['parentName'] ?? '',
          parentEmail: allData['parentEmail'] ?? '',
          parentPhone: allData['parentPhone'] ?? '',
          password: allData['password'] ?? '',
          // Datos del hijo
          childName: allData['childName'] ?? '',
          childEmail: allData['childEmail'] ?? '',
          childAge: allData['childAge'] ?? 0,
          childGrade: allData['childGrade'] ?? '',
          // Contactos de emergencia
          emergencyContacts: allData['emergencyContacts'] != null
              ? List<Map<String, String>>.from(allData['emergencyContacts'])
              : null,
        );

        isLoading.value = false;

        if (result.success) {
          // Mostrar mensaje de éxito
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('¡Registro completado exitosamente!'),
                backgroundColor: Colors.green,
                duration: Duration(seconds: 2),
              ),
            );

            // Pequeño delay para que se vea el mensaje
            await Future.delayed(const Duration(seconds: 1));

            // Navegar al dashboard del padre (ya está logueado automáticamente)
            context.go('/parent');
          }
        } else {
          // Mostrar error
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error: ${result.error}'),
                backgroundColor: Colors.red,
                duration: const Duration(seconds: 4),
              ),
            );
          }
        }
      } catch (e) {
        isLoading.value = false;
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error inesperado: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(color: Color(0xFFFFFBEF)),
            child: SafeArea(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            IconButton(
                              onPressed: () => context.go('/parent-login'),
                              icon: Icon(
                                Icons.arrow_back,
                                color: context.darkText,
                              ),
                              tooltip: 'Volver al Login del Padre',
                            ),
                            Expanded(
                              child: Text(
                                'Registro Tora',
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineMedium
                                    ?.copyWith(
                                      color: context.darkText,
                                      fontWeight: FontWeight.bold,
                                    ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            const SizedBox(width: 48),
                          ],
                        ),
                        const SizedBox(height: 16),
                        SmoothPageIndicator(
                          controller: pageController,
                          count: 4,
                          effect: WormEffect(
                            dotHeight: 8,
                            dotWidth: 8,
                            spacing: 16,
                            activeDotColor: context.warmYellow,
                            dotColor: context.lightGray,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Paso ${currentStep.value + 1} de 4',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: context.mediumText),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: PageView(
                      controller: pageController,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        ChildDataScreen(
                          onNext: nextStep,
                          onBack: () => context.go('/parent-login'),
                          initialData: registrationData.value,
                        ),
                        TutorDataScreen(
                          onNext: nextStep,
                          onPrevious: previousStep,
                          initialData: registrationData.value,
                        ),
                        PasswordSetupScreen(
                          onNext: nextStep,
                          onPrevious: previousStep,
                          initialData: registrationData.value,
                        ),
                        EmergencyContactsScreen(
                          onComplete: completeRegistration,
                          onPrevious: previousStep,
                          initialData: registrationData.value,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Loading overlay
          if (isLoading.value)
            Container(
              color: Colors.black54,
              child: Center(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const CircularProgressIndicator(),
                        const SizedBox(height: 24),
                        Text(
                          'Creando tu cuenta...',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Esto puede tomar unos segundos',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
