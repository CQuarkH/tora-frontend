import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tora_frontend/features/auth/models/login_response.dart';
import 'package:tora_frontend/features/auth/models/user.dart';
import 'package:tora_frontend/features/auth/services/secure_storage_service.dart';

class AuthService {
  static const String baseUrl = 'http://172.29.193.93:3000';
  final SecureStorageService _storageService = SecureStorageService();

  // Login
  Future<LoginResponse> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final loginResponse = LoginResponse.fromJson(
          json.decode(response.body),
        );

        // Guardar token y usuario
        await _storageService.saveToken(loginResponse.accessToken);
        await _storageService.saveUser(loginResponse.user);

        return loginResponse;
      } else {
        final error = json.decode(response.body);
        throw Exception(error['message'] ?? 'Error en login');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  // Logout
  Future<void> logout() async {
    await _storageService.clearAll();
  }

  // Obtener usuario actual
  Future<User?> getCurrentUser() async {
    return await _storageService.getUser();
  }

  // Obtener rol del usuario actual
  Future<UserRole?> getCurrentUserRole() async {
    return await _storageService.getUserRole();
  }

  // Verificar si está autenticado
  Future<bool> isAuthenticated() async {
    return await _storageService.isLoggedIn();
  }

  // Obtener token para requests
  Future<String?> getAuthToken() async {
    return await _storageService.getToken();
  }
}
