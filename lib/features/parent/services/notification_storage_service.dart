import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tora_frontend/features/parent/models/alert.dart';

class NotificationStorageService {
  static const String _notificationsKey = 'cached_notifications';
  static const String _unreadCountKey = 'unread_notification_count';

  /// Guardar notificaciones en caché local
  static Future<void> saveNotifications(List<Alert> notifications) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = notifications.map((n) => n.toJson()).toList();
    await prefs.setString(_notificationsKey, json.encode(jsonList));
  }

  /// Obtener notificaciones del caché local
  static Future<List<Alert>> getCachedNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_notificationsKey);

    if (jsonString == null) return [];

    final List<dynamic> jsonList = json.decode(jsonString);
    return jsonList.map((json) => Alert.fromJson(json)).toList();
  }

  /// Agregar nueva notificación al caché
  static Future<void> addNotification(Alert notification) async {
    final current = await getCachedNotifications();

    // Evitar duplicados
    if (!current.any((n) => n.id == notification.id)) {
      current.insert(0, notification); // Agregar al inicio

      // Mantener solo las últimas 50 notificaciones
      if (current.length > 50) {
        current.removeLast();
      }

      await saveNotifications(current);
      await incrementUnreadCount();
    }
  }

  /// Marcar notificación como leída
  static Future<void> markAsRead(String notificationId) async {
    final notifications = await getCachedNotifications();
    final index = notifications.indexWhere((n) => n.id == notificationId);

    if (index != -1 && !notifications[index].read) {
      notifications[index] = notifications[index].copyWith(read: true);
      await saveNotifications(notifications);
      await decrementUnreadCount();
    }
  }

  /// Marcar todas como leídas
  static Future<void> markAllAsRead() async {
    final notifications = await getCachedNotifications();
    final updated = notifications.map((n) => n.copyWith(read: true)).toList();
    await saveNotifications(updated);
    await setUnreadCount(0);
  }

  /// Obtener contador de no leídas
  static Future<int> getUnreadCount() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_unreadCountKey) ?? 0;
  }

  /// Establecer contador de no leídas
  static Future<void> setUnreadCount(int count) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_unreadCountKey, count);
  }

  /// Incrementar contador
  static Future<void> incrementUnreadCount() async {
    final current = await getUnreadCount();
    await setUnreadCount(current + 1);
  }

  /// Decrementar contador
  static Future<void> decrementUnreadCount() async {
    final current = await getUnreadCount();
    if (current > 0) {
      await setUnreadCount(current - 1);
    }
  }

  /// Limpiar todas las notificaciones
  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_notificationsKey);
    await prefs.remove(_unreadCountKey);
  }
}
