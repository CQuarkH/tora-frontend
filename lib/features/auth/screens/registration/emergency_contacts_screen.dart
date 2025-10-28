import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:tora_frontend/core/theme/tora_theme.dart';

class EmergencyContactsScreen extends HookWidget {
  final Function(Map<String, dynamic>) onComplete;
  final VoidCallback onPrevious;
  final Map<String, dynamic> initialData;

  const EmergencyContactsScreen({
    super.key,
    required this.onComplete,
    required this.onPrevious,
    required this.initialData,
  });

  @override
  Widget build(BuildContext context) {
    final nameController = useTextEditingController();
    final phoneController = useTextEditingController(text: '+56 9 ');
    final selectedRelation = useState<String?>('Padre/Madre');

    // Opciones de relación predefinidas
    final relationOptions = [
      'Padre/Madre',
      'Familiar cercano/a',
      'Vecino/a',
      'Cuidador/a',
      'Otro/a',
    ];

    final emergencyContacts = useState<List<Map<String, String>>>(
      initialData['emergencyContacts'] != null
          ? List<Map<String, String>>.from(initialData['emergencyContacts'])
          : [],
    );

    void addEmergencyContact() {
      final name = nameController.text.trim();
      final phone = phoneController.text.trim();
      final relation = selectedRelation.value ?? '';

      if (name.isEmpty || phone.isEmpty || relation.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Por favor, completa todos los campos'),
            backgroundColor: context.warmYellow,
          ),
        );
        return;
      }

      // Validación básica de teléfono
      final cleanPhone = phone.replaceAll(RegExp(r'[\\s\\-\\(\\)\\+]'), '');
      if (cleanPhone.length < 8) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Por favor, ingresa un número válido'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // Agregar contacto
      final newContact = {'name': name, 'phone': phone, 'relation': relation};
      emergencyContacts.value = [...emergencyContacts.value, newContact];

      // Limpiar campos
      nameController.clear();
      phoneController.text = '+56 9 ';
      selectedRelation.value = 'Familiar cercano/a';

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Contacto agregado exitosamente'),
          backgroundColor: Colors.green,
        ),
      );
    }

    void removeContact(int index) {
      final updatedList = [...emergencyContacts.value];
      updatedList.removeAt(index);
      emergencyContacts.value = updatedList;
    }

    void handleComplete() {
      // if (emergencyContacts.value.isEmpty) {
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     SnackBar(
      //       content: const Text('Por favor, agrega al menos un contacto de emergencia'),
      //       backgroundColor: context.warmYellow,
      //     ),
      //   );
      //   return;
      // }

      // Pasar los datos de contactos de emergencia
      onComplete({'emergencyContacts': emergencyContacts.value});
    }

    return Container(
      color: const Color(0xFFFFFBEF), // Fondo crema cálido
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icono y descripción
            Center(
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.emergency, size: 50, color: Colors.red[700]),
              ),
            ),
            const SizedBox(height: 24),

            Center(
              child: Text(
                'Contactos de Emergencia',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: context.darkText,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 8),

            Center(
              child: Text(
                'Estos contactos serán alertados cuando se active el botón de emergencia',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: context.mediumText),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: Text(
                'Se recomienda agregar contactos presentes en el colegio, como profesores o personal de apoyo',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: context.mediumText.withOpacity(0.7),
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 32),

            // Formulario para agregar contacto
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
                  Text(
                    'Agregar Nuevo Contacto',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: context.darkText,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Nombre
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: 'Nombre Completo',
                      hintText: 'Ej: Profesora María Pérez',
                      prefixIcon: Icon(Icons.person, color: context.mediumText),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Teléfono
                  TextField(
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
                      labelText: 'Número WhatsApp',
                      hintText: '+56 9 1234 5678',
                      prefixIcon: Icon(Icons.phone, color: context.mediumText),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Relación - Dropdown
                  DropdownButtonFormField<String>(
                    value: selectedRelation.value,
                    decoration: InputDecoration(
                      labelText: 'Relación/Cargo',
                      prefixIcon: Icon(Icons.people, color: context.mediumText),
                    ),
                    items: relationOptions.map((String relation) {
                      return DropdownMenuItem<String>(
                        value: relation,
                        child: Text(relation),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      selectedRelation.value = newValue;
                    },
                  ),
                  const SizedBox(height: 20),

                  // Botón agregar
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: addEmergencyContact,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Agregar Contacto',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Lista de contactos agregados
            if (emergencyContacts.value.isNotEmpty) ...[
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
                    Text(
                      'Contactos Agregados (${emergencyContacts.value.length})',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: context.darkText,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ...emergencyContacts.value.asMap().entries.map((entry) {
                      final index = entry.key;
                      final contact = entry.value;
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: context.lightGray.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: context.lightGray,
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: context.softBlue,
                              child: Text(
                                contact['name']![0].toUpperCase(),
                                style: TextStyle(
                                  color: context.darkText,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    contact['name']!,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(
                                          color: context.darkText,
                                          fontWeight: FontWeight.w600,
                                        ),
                                  ),
                                  Text(
                                    contact['phone']!,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(color: context.mediumText),
                                  ),
                                  Text(
                                    contact['relation']!,
                                    style: Theme.of(context).textTheme.bodySmall
                                        ?.copyWith(color: context.lightText),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              onPressed: () => removeContact(index),
                              icon: const Icon(
                                Icons.delete_outline,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ],
                ),
              ),
              const SizedBox(height: 32),
            ],

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
                    onPressed: handleComplete,
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
                      'Completar Registro',
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
