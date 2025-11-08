// lib/features/tora-pet/services/tora_coins_service.dart
import 'dart:convert';

import 'package:tora_frontend/core/services/api_client.dart';
import 'package:tora_frontend/features/auth/services/auth_service.dart';
import 'package:tora_frontend/features/tora-pet/models/coin.dart';

/// Servicio para consultar y actualizar monedas en el backend.
/// Importante: `ApiClient` debe retornar `res.body` como `Map` o `String` JSON.
class ToraCoinsService {
  static final ApiClient _apiClient = ApiClient();

  /// Obtiene el saldo actual de monedas para el usuario autenticado.
  static Future<Coin> getCoins() async {
    final auth = AuthService();
    final user = await auth.getCurrentUser();
    if (user?.id == null) {
      throw StateError('No authenticated user');
    }

    final res = await _apiClient.get('/coins/${user!.id}');
    if (res.statusCode != 200) {
      throw Exception('Failed to load coins: HTTP ${res.statusCode}');
    }

    final map = _decodeBodyToMap(res.body);
    return Coin.fromJson(map);
  }

  static Future<Coin> addCoins(int amount) async {
    final auth = AuthService();
    final user = await auth.getCurrentUser();
    if (user?.id == null) {
      throw StateError('No authenticated user');
    }

    final res = await _apiClient.post('/coins/${user!.id}/add', {'amount': amount});
    
    if (res.statusCode != 201) {
      throw Exception('Failed to add coins: HTTP ${res.statusCode}');
    }

    final map = _decodeBodyToMap(res.body);
    return Coin.fromJson(map);
  }

  /// Establece el nuevo valor de monedas a [newAmount] (p. ej., tras un descuento).
  static Future<Coin> deductCoins(int newAmount) async {
    final auth = AuthService();
    final user = await auth.getCurrentUser();
    if (user?.id == null) {
      throw StateError('No authenticated user');
    }

    final res = await _apiClient.patch('/coins/${user!.id}', {'coins': newAmount});
    if (res.statusCode != 200) {
      throw Exception('Failed to deduct coins: HTTP ${res.statusCode}');
    }

    final map = _decodeBodyToMap(res.body);
    return Coin.fromJson(map);
  }

  /// Decodifica `res.body` a `Map<String, dynamic>` aceptando `Map` o `String` JSON.
  static Map<String, dynamic> _decodeBodyToMap(Object? body) {
    if (body is Map<String, dynamic>) return body;
    if (body is String) {
      final decoded = json.decode(body);
      if (decoded is Map<String, dynamic>) return decoded;
    }
    throw const FormatException('Unexpected response body type');
  }
}
