import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class RegisterUserStepOneScreen extends HookWidget {
  const RegisterUserStepOneScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final childNameController = useTextEditingController();
    final ageController = useTextEditingController();
    final gradeController = useTextEditingController();
    final childEmailController = useTextEditingController();
    final tutorEmailController = useTextEditingController();

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              
              // Tiger mascot
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.orange[100],
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Text(
                    '🐯',
                    style: TextStyle(fontSize: 80),
                  ),
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Welcome title
              const Text(
                'Bienvenido Tutor',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF333333),
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 12),
              
              // Subtitle
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Con Tora, cuidamos juntos el bienestar emocional de su pupilo',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF666666),
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              
              const SizedBox(height: 40),
              
              // Form section
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Section title
                    const Text(
                      'Datos Generales',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF333333),
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Child name field
                    _buildTextField(
                      controller: childNameController,
                      hintText: 'Nombre del niño',
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Age and Grade row
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField(
                            controller: ageController,
                            hintText: 'Edad',
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildTextField(
                            controller: gradeController,
                            hintText: 'Grado escolar',
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Child email field
                    _buildTextField(
                      controller: childEmailController,
                      hintText: 'Correo del Niño',
                      keyboardType: TextInputType.emailAddress,
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Tutor email field
                    _buildTextField(
                      controller: tutorEmailController,
                      hintText: 'Correo del Tutor',
                      keyboardType: TextInputType.emailAddress,
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 32),
              
              // Next button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _handleNext(
                    context,
                    childNameController.text,
                    ageController.text,
                    gradeController.text,
                    childEmailController.text,
                    tutorEmailController.text,
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF9800),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                  child: const Text(
                    'Siguiente',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    TextInputType? keyboardType,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: const Color(0xFFE9ECEF),
          width: 1,
        ),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(
            color: Color(0xFF999999),
            fontSize: 14,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
        ),
      ),
    );
  }

  void _handleNext(
    BuildContext context,
    String childName,
    String age,
    String grade,
    String childEmail,
    String tutorEmail,
  ) {
    // Basic validation
    if (childName.isEmpty ||
        age.isEmpty ||
        grade.isEmpty ||
        childEmail.isEmpty ||
        tutorEmail.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, completa todos los campos'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // Email validation
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(childEmail) || !emailRegex.hasMatch(tutorEmail)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, ingresa correos válidos'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Age validation
    final ageInt = int.tryParse(age);
    if (ageInt == null || ageInt < 3 || ageInt > 18) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, ingresa una edad válida (3-18 años)'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Success - navigate to next step
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('¡Datos guardados correctamente!'),
        backgroundColor: Colors.green,
      ),
    );

    // TODO: Navigate to step 2 or save data
    // Navigator.of(context).push(
    //   MaterialPageRoute(
    //     builder: (context) => const RegisterUserStepTwoScreen(),
    //   ),
    // );
  }
}
