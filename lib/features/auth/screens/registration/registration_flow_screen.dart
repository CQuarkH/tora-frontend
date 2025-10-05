import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:tora_frontend/core/theme/tora_theme.dart';
import 'package:tora_frontend/features/auth/screens/registration/child_data_screen.dart';
import 'package:tora_frontend/features/auth/screens/registration/tutor_data_screen.dart';
import 'package:tora_frontend/features/auth/screens/registration/password_setup_screen.dart';
import 'package:tora_frontend/features/auth/screens/registration/emergency_contacts_screen.dart';

class RegistrationFlowScreen extends HookWidget {
  const RegistrationFlowScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final pageController = usePageController();
    final currentStep = useState(0);
    final registrationData = useState<Map<String, dynamic>>({});

    final steps = [
      'Datos del Niño',
      'Datos del Padre/Tutor',
      'Configurar Contraseñas',
      'Contactos de Emergencia',
    ];

    void nextStep(Map<String, dynamic> stepData) {
      // Guardar datos del paso actual
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

    void completeRegistration() {
      // Aquí procesarías todos los datos de registro
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('¡Registro completado exitosamente!'),
          backgroundColor: Colors.green,
        ),
      );

      // Navegar a la raíz
      context.go('/');
    }

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: const Color(
            0xFFFFFBEF,
          ), // Fondo crema cálido para todas las vistas
        ),
        child: SafeArea(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    // Header con botón de volver y título en la misma línea
                    Row(
                      children: [
                        IconButton(
                          onPressed: () => context.go('/parent-login'),
                          icon: Icon(Icons.arrow_back, color: context.darkText),
                          tooltip: 'Volver al Login del Padre',
                        ),
                        Expanded(
                          child: Text(
                            'Registro Tora',
                            style: Theme.of(context).textTheme.headlineMedium
                                ?.copyWith(
                                  color: context.darkText,
                                  fontWeight: FontWeight.bold,
                                ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        // Espacio invisible para balancear el diseño
                        const SizedBox(width: 48),
                      ],
                    ),
                    const SizedBox(height: 16),
                  

                    // Indicador de progreso
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

                    // Progreso en texto
                    Text(
                      'Paso ${currentStep.value + 1} de 4',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: context.mediumText,
                      ),
                    ),
                  ],
                ),
              ),

              // Contenido de los pasos
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
                      onComplete: (data) {
                        // Guardar datos y completar registro
                        registrationData.value = {
                          ...registrationData.value,
                          ...data,
                        };
                        completeRegistration();
                      },
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
    );
  }
}
