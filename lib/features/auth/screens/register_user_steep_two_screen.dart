import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';

class RegisterUserStepTwoScreen extends HookWidget {
  const RegisterUserStepTwoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final nameController = useTextEditingController();
    final phoneController = useTextEditingController();
    final emergencyContacts = useState<List<Map<String, String>>>([]);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              
              // Emergency contacts icon
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Family icon with heart
                      Icon(
                        Icons.favorite,
                        color: Color(0xFFE91E63),
                        size: 24,
                      ),
                      SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 12,
                            backgroundColor: Color(0xFFE91E63),
                            child: Icon(Icons.person, size: 16, color: Colors.white),
                          ),
                          SizedBox(width: 4),
                          CircleAvatar(
                            radius: 12,
                            backgroundColor: Color(0xFF2196F3),
                            child: Icon(Icons.person, size: 16, color: Colors.white),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      CircleAvatar(
                        radius: 10,
                        backgroundColor: Color(0xFFFF9800),
                        child: Icon(Icons.child_care, size: 14, color: Colors.white),
                      ),
                      SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Icon(Icons.favorite, color: Color(0xFFE91E63), size: 16),
                          Icon(Icons.favorite, color: Color(0xFFE91E63), size: 16),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Title
              const Text(
                'Contactos de Emergencia',
                style: TextStyle(
                  fontSize: 20,
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
                  'Estos contactos serán alertados cuando su pupilo active el botón de emergencia',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF666666),
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              
              const SizedBox(height: 32),
              
              // Add new contact section
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Agregar Nuevo Contacto',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF333333),
                      ),
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // Name field
                    _buildTextField(
                      controller: nameController,
                      hintText: 'Nombre (ej: Profesora Paola)',
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Phone field
                    _buildTextField(
                      controller: phoneController,
                      hintText: 'Número WhatsApp (ej: +569 XXXX XXXX)',
                      keyboardType: TextInputType.phone,
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // Add button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => _addEmergencyContact(
                          context,
                          nameController,
                          phoneController,
                          emergencyContacts,
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4CAF50),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 1,
                        ),
                        child: const Text(
                          'Agregar',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Emergency contacts list (if any)
              if (emergencyContacts.value.isNotEmpty) ...[
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Contactos Agregados',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF333333),
                        ),
                      ),
                      const SizedBox(height: 12),
                      ...emergencyContacts.value.asMap().entries.map((entry) {
                        final index = entry.key;
                        final contact = entry.value;
                        return Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.grey[50],
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: Colors.grey[200]!,
                              width: 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      contact['name']!,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Text(
                                      contact['phone']!,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                onPressed: () => _removeContact(index, emergencyContacts),
                                icon: const Icon(
                                  Icons.delete_outline,
                                  color: Colors.red,
                                  size: 18,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
              ],
              
              // Create account button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _createAccount(context, emergencyContacts.value),
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
                    'Crear Cuenta',
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

  void _addEmergencyContact(
    BuildContext context,
    TextEditingController nameController,
    TextEditingController phoneController,
    ValueNotifier<List<Map<String, String>>> emergencyContacts,
  ) {
    final name = nameController.text.trim();
    final phone = phoneController.text.trim();

    if (name.isEmpty || phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, completa todos los campos'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // Basic phone validation
    if (phone.length < 8) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, ingresa un número válido'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Add contact to list
    final newContact = {'name': name, 'phone': phone};
    emergencyContacts.value = [...emergencyContacts.value, newContact];

    // Clear fields
    nameController.clear();
    phoneController.clear();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Contacto agregado exitosamente'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _removeContact(
    int index,
    ValueNotifier<List<Map<String, String>>> emergencyContacts,
  ) {
    final updatedList = [...emergencyContacts.value];
    updatedList.removeAt(index);
    emergencyContacts.value = updatedList;
  }

  void _createAccount(BuildContext context, List<Map<String, String>> contacts) {

    context.go('/login');
    
    if (contacts.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, agrega al menos un contacto de emergencia'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // Success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('¡Cuenta creada exitosamente con ${contacts.length} contacto(s)!'),
        backgroundColor: Colors.green,
      ),
    );

    context.go('/login');

    
  }
}
