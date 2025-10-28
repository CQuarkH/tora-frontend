import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tora_frontend/features/auth/models/user.dart';
import 'package:tora_frontend/features/child/models/child.dart';
import 'package:tora_frontend/features/parent/models/parent.dart';

class SecureStorageService {
  static final SecureStorageService _instance =
      SecureStorageService._internal();
  factory SecureStorageService() => _instance;
  SecureStorageService._internal();

  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  // Keys
  static const String _tokenKey = 'auth_token';
  static const String _userKey = 'user_data';
  static const String _userRoleKey = 'user_role';
  static const String _isLoggedInKey = 'is_logged_in';

  // Guardar token
  Future<void> saveToken(String token) async {
    await _secureStorage.write(key: _tokenKey, value: token);
  }

  // Obtener token
  Future<String?> getToken() async {
    return await _secureStorage.read(key: _tokenKey);
  }

  // Guardar usuario
  Future<void> saveUser(User user) async {
    String jsonString;
    String role;

    if (user is Child) {
      jsonString = user.toJsonString();
      role = 'CHILD';
    } else if (user is Parent) {
      jsonString = user.toJsonString();
      role = 'PARENT';
    } else {
      throw Exception('Tipo de usuario no reconocido');
    }

    await _secureStorage.write(key: _userKey, value: jsonString);
    await _secureStorage.write(key: _userRoleKey, value: role);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isLoggedInKey, true);
  }

  // Obtener usuario
  Future<User?> getUser() async {
    final userJson = await _secureStorage.read(key: _userKey);
    final userRole = await _secureStorage.read(key: _userRoleKey);

    if (userJson != null && userRole != null) {
      if (userRole == 'CHILD') {
        return Child.fromJsonString(userJson);
      } else if (userRole == 'PARENT') {
        return Parent.fromJsonString(userJson);
      }
    }
    return null;
  }

  // Obtener solo el rol del usuario
  Future<UserRole?> getUserRole() async {
    final userRole = await _secureStorage.read(key: _userRoleKey);
    if (userRole == 'CHILD') return UserRole.CHILD;
    if (userRole == 'PARENT') return UserRole.PARENT;
    return null;
  }

  // Verificar si está logueado
  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isLoggedInKey) ?? false;
  }

  // Limpiar todo (logout)
  Future<void> clearAll() async {
    await _secureStorage.deleteAll();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_isLoggedInKey);
  }
}
