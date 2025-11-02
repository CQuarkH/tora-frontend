import 'dart:convert';
import 'package:tora_frontend/core/services/api_client.dart';
import 'package:tora_frontend/features/child/models/child.dart';
import 'package:tora_frontend/features/child/models/emotion_record.dart';
import 'package:tora_frontend/features/parent/models/alert.dart';
import 'package:tora_frontend/features/parent/models/parent_dashboard.dart';
import 'package:tora_frontend/features/parent/services/notification_storage_service.dart';

class ParentService {
  static final _apiClient = ApiClient();

  /// Obtener dashboard del hijo
  static Future<ParentDashboard> getDashboard(String childId) async {
    final response = await _apiClient.get('/dashboard/parent/$childId');

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print('Dashboard data: $data');
      return _mapDashboardResponse(data);
    } else {
      throw Exception('Error al obtener el dashboard: ${response.body}');
    }
  }

  static Future<List<Alert>> getNotifications(String childId) async {
    try {
      // Primero intenta obtener del backend
      final response = await _apiClient.get('/notifications/user/$childId');

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        final backendNotifications = data
            .map((json) => Alert.fromJson(json))
            .toList();

        // Guardar en caché
        await NotificationStorageService.saveNotifications(
          backendNotifications,
        );

        return backendNotifications;
      }
    } catch (e) {
      print('Error obteniendo notificaciones del backend: $e');
    }

    // Si falla, usar caché local
    return await NotificationStorageService.getCachedNotifications();
  }

  /// Obtener solo las notificaciones del caché local (más rápido)
  static Future<List<Alert>> getCachedNotifications() async {
    return await NotificationStorageService.getCachedNotifications();
  }

  /// Marcar notificación como leída
  static Future<void> markNotificationAsRead(String notificationId) async {
    await NotificationStorageService.markAsRead(notificationId);

    // Opcional: sincronizar con backend
    try {
      await _apiClient.put('/notifications/$notificationId/read', {});
    } catch (e) {
      print('Error marcando como leída en backend: $e');
    }
  }

  /// Marcar todas como leídas
  static Future<void> markAllNotificationsAsRead() async {
    await NotificationStorageService.markAllAsRead();

    // Opcional: sincronizar con backend
    try {
      await _apiClient.post('/notifications/mark-all-read', {});
    } catch (e) {
      print('Error marcando todas como leídas en backend: $e');
    }
  }

  /// Obtener contador de notificaciones no leídas
  static Future<int> getUnreadNotificationCount() async {
    return await NotificationStorageService.getUnreadCount();
  }

  /// Obtener alertas recientes (si las quieres separar)
  static Future<List<Alert>> getAlerts(String childId) async {
    final dashboard = await getDashboard(childId);
    return dashboard.alerts;
  }

  /// Mapeo del JSON del backend (DashboardResponse → ParentDashboard)
  static ParentDashboard _mapDashboardResponse(Map<String, dynamic> data) {
    final childData = data['child'];
    final summaryData = data['summary'];
    final emotionsData = data['emotions'];
    final alertsData = data['alerts'] as List<dynamic>? ?? [];

    final lastTwoWeeks = emotionsData['lastTwoWeeks'] as List<dynamic>? ?? [];
    final monthlyVariation =
        emotionsData['monthlyVariation'] as List<dynamic>? ?? [];

    // Procesar emociones de lastTwoWeeks
    final emotionsFromLastTwoWeeks = lastTwoWeeks
        .map((e) {
          final date = e['date'] as String;

          // Buscar cualquier emoción que exista
          String? emotionStr = e['morning'] ?? e['afternoon'] ?? e['evening'];

          // 👇 Si no hay emoción, retorna null para filtrar después
          if (emotionStr == null) return null;

          final emotion = Emotion.fromString(emotionStr);

          // 👇 Si la emoción no es válida, también retorna null
          if (emotion == null) return null;

          return EmotionRecord(
            id: date,
            blockId: 'summary',
            emotion: emotion,
            createdAt: DateTime.tryParse(date) ?? DateTime.now(),
          );
        })
        .whereType<EmotionRecord>() // 👈 Filtra los nulls
        .toList();

    // Procesar emociones de monthlyVariation
    final emotionsFromMonthly = monthlyVariation
        .map((e) {
          final emotion = Emotion.fromString(e['emotion']);
          if (emotion == null) return null;

          return EmotionRecord(
            id: e['date'],
            blockId: 'summary',
            emotion: emotion,
            createdAt: DateTime.tryParse(e['date']) ?? DateTime.now(),
          );
        })
        .whereType<EmotionRecord>() // 👈 Filtra los nulls
        .toList();

    // Fusionar ambas listas
    final allEmotions = [...emotionsFromLastTwoWeeks, ...emotionsFromMonthly];

    return ParentDashboard(
      child: Child.fromJson(childData),
      summary: ParentDashboardSummary(
        completedTasksPercentage: (summaryData['completedTasksPercentage'] ?? 0)
            .toDouble(),
        panicButtonCount: summaryData['panicButtonCount'] ?? 0,
        totalTasks: summaryData['totalTasks'],
        completedTasks: summaryData['completedTasks'],
      ),
      emotions: allEmotions,
      alerts: alertsData.map((a) => Alert.fromJson(a)).toList(),
    );
  }
}
