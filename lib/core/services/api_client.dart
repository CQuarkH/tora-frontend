import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:tora_frontend/core/router/router.dart';
import 'package:tora_frontend/features/auth/services/secure_storage_service.dart';

class ApiClient {
  String get baseUrl => dotenv.env['API_URL'] ?? 'http://localhost:3000';
  final SecureStorageService _storageService = SecureStorageService();

  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  Future<Map<String, String>> _getHeaders() async {
    final token = await _storageService.getToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  // ✅ NUEVO: Validar token usando el endpoint /users/profile
  Future<bool> validateToken() async {
    try {
      final token = await _storageService.getToken();

      if (token == null) {
        print('❌ No hay token guardado');
        return false;
      }

      print('🔍 Validando token con /users/profile...');

      final response = await http
          .get(
            Uri.parse('$baseUrl/users/profile'),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            },
          )
          .timeout(
            const Duration(seconds: 10),
            onTimeout: () {
              throw Exception('Timeout validando token');
            },
          );

      if (response.statusCode == 200) {
        print('✅ Token válido - Usuario autenticado');
        return true;
      } else if (response.statusCode == 401) {
        print('❌ Token inválido o expirado (401)');
        return false;
      } else {
        print('⚠️ Respuesta inesperada: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('❌ Error validando token: $e');
      return false;
    }
  }

  Future<http.Response> _handleResponse(http.Response response) async {
    if (response.statusCode == 401) {
      print(
        '🚨 Token expirado o inválido (401) - Cerrando sesión automáticamente',
      );
      await _handleTokenExpiration();
    }
    return response;
  }

  Future<void> _handleTokenExpiration() async {
    await _storageService.clearAll();

    final context = navigatorKey.currentContext;

    if (context != null && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Tu sesión ha expirado. Por favor, inicia sesión nuevamente.',
          ),
          backgroundColor: Colors.orange,
          duration: Duration(seconds: 3),
        ),
      );

      // Con go_router usamos go en lugar de pushNamedAndRemoveUntil
      // El redirect del router se encargará de llevarlo a '/'
      if (context.mounted) {
        // Limpiar cualquier estado adicional si es necesario
        UserSession.logout();
      }
    }
  }

  // GET request
  Future<http.Response> get(String endpoint) async {
    final headers = await _getHeaders();
    final response = await http.get(
      Uri.parse('$baseUrl$endpoint'),
      headers: headers,
    );
    return await _handleResponse(response);
  }

  // POST request
  Future<http.Response> post(String endpoint, Map<String, dynamic> body) async {
    final headers = await _getHeaders();
    final response = await http.post(
      Uri.parse('$baseUrl$endpoint'),
      headers: headers,
      body: json.encode(body),
    );
    return await _handleResponse(response);
  }

  // PUT request
  Future<http.Response> put(String endpoint, Map<String, dynamic> body) async {
    final headers = await _getHeaders();
    final response = await http.put(
      Uri.parse('$baseUrl$endpoint'),
      headers: headers,
      body: json.encode(body),
    );
    return await _handleResponse(response);
  }

  // DELETE request
  Future<http.Response> delete(String endpoint) async {
    final headers = await _getHeaders();
    final response = await http.delete(
      Uri.parse('$baseUrl$endpoint'),
      headers: headers,
    );
    return await _handleResponse(response);
  }

  // PATCH request
  Future<http.Response> patch(
    String endpoint,
    Map<String, dynamic> body,
  ) async {
    final headers = await _getHeaders();
    final response = await http.patch(
      Uri.parse('$baseUrl$endpoint'),
      headers: headers,
      body: json.encode(body),
    );
    return await _handleResponse(response);
  }
}
