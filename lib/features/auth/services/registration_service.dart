import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:tora_frontend/core/services/api_client.dart';
import 'package:tora_frontend/features/auth/models/registration_result.dart';
import 'package:tora_frontend/features/auth/services/auth_service.dart';

class RegistrationService {
  String get baseUrl => dotenv.env['API_URL'] ?? 'http://localhost:3000';

  /// Registro completo: Padre + Hijo en una sola transacción
  Future<RegistrationResult> registerParentAndChild({
    // Datos del padre
    required String parentName,
    required String parentEmail,
    required String parentPhone,
    required String password,
    // Datos del hijo
    required String childName,
    required String childEmail,
    required int childAge,
    required String childGrade,
    // Contactos de emergencia (opcional por ahora)
    List<Map<String, String>>? emergencyContacts,
  }) async {
    try {
      // PASO 1: Registrar al padre
      print('📝 Registrando padre...');
      final parentResponse = await http.post(
        Uri.parse('$baseUrl/auth/register/parent'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'name': parentName,
          'email': parentEmail,
          'password': password,
          'phone': parentPhone,
        }),
      );

      if (parentResponse.statusCode != 200 &&
          parentResponse.statusCode != 201) {
        final error = json.decode(parentResponse.body);
        throw Exception(error['message'] ?? 'Error al registrar padre');
      }

      final parentData = json.decode(parentResponse.body);
      final parentId = parentData['user']['id'];
      print('✅ Padre registrado con ID: $parentId');

      // PASO 2: Registrar al hijo usando el parentId
      print('📝 Registrando hijo...');
      final childResponse = await http.post(
        Uri.parse('$baseUrl/auth/register/child'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'parentId': parentId,
          'name': childName,
          'email': childEmail,
          'password': password, // Misma contraseña
          'age': childAge,
          'grade': childGrade,
        }),
      );

      if (childResponse.statusCode != 200 && childResponse.statusCode != 201) {
        final error = json.decode(childResponse.body);
        throw Exception(error['message'] ?? 'Error al registrar hijo');
      }

      final childData = json.decode(childResponse.body);
      print('✅ Hijo registrado con ID: ${childData['user']['id']}');

      // PASO 4: Hacer login automático con la cuenta del padre
      print('🔐 Iniciando sesión automática...');
      final authService = AuthService();
      final loginResponse = await authService.login(
        email: parentEmail,
        password: password,
      );

      print('✅ Registro completo exitoso');

      // PASO 3: Guardar contactos de emergencia (si se implementa en el backend)
      if (emergencyContacts != null && emergencyContacts.isNotEmpty) {
        print(
          '📝 Guardando ${emergencyContacts.length} contactos de emergencia...',
        );
        await _saveEmergencyContacts(
          childId: childData['user']['id'],
          contacts: emergencyContacts,
        );
      }

      return RegistrationResult(
        success: true,
        parentId: parentId,
        childId: childData['user']['id'],
        loginResponse: loginResponse,
      );
    } catch (e) {
      print('❌ Error en registro: $e');
      return RegistrationResult(success: false, error: e.toString());
    }
  }

  /// Guardar contactos de emergencia (para cuando esté implementado en backend)
  Future<void> _saveEmergencyContacts({
    required String childId,
    required List<Map<String, String>> contacts,
  }) async {
    final apiClient = ApiClient();

    for (var contact in contacts) {
      try {
        final response = await apiClient
            .post('/self-regulation/emergency-contacts', {
              'name': contact['name'],
              'phone': contact['phone'],
              'email': contact['email'] ?? 'test@gmail.com',
              'relationship': contact['relation'] ?? 'Contacto de emergencia',
              'receiveAlerts': true,
              'priority': 1,
            });
        if (response.statusCode == 200 || response.statusCode == 201) {
          print('✅ Contacto ${contact['name']} guardado correctamente.');
        } else {
          print(
            '❌ Error guardando contacto ${contact['name']}: ${response.body}',
          );
        }
      } catch (e) {
        print('Error guardando contacto ${contact['name']}: $e');
      }
    }
  }
}
