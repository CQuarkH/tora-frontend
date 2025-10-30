import 'dart:convert';
import 'package:tora_frontend/core/services/api_client.dart';
import 'package:tora_frontend/features/child/models/child.dart';
import 'package:tora_frontend/features/child/models/emotion_record.dart';
import 'package:tora_frontend/features/parent/models/alert.dart';
import 'package:tora_frontend/features/parent/models/parent_dashboard.dart';

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
    return [];
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

    // 🧠 Tu backend separa emociones en `lastTwoWeeks` y `monthlyVariation`
    final lastTwoWeeks = emotionsData['lastTwoWeeks'] as List<dynamic>? ?? [];
    final monthlyVariation =
        emotionsData['monthlyVariation'] as List<dynamic>? ?? [];

    // Procesar emociones de lastTwoWeeks
    final emotionsFromLastTwoWeeks = lastTwoWeeks.map((e) {
      final date = e['date'] as String;

      // Buscar cualquier emoción que exista (morning, afternoon, evening)
      String? emotionStr = e['morning'] ?? e['afternoon'] ?? e['evening'];

      return EmotionRecord(
        id: date,
        blockId: 'summary',
        emotion: Emotion.fromString(emotionStr),
        createdAt: DateTime.tryParse(date) ?? DateTime.now(),
      );
    }).toList();

    // Procesar emociones de monthlyVariation
    final emotionsFromMonthly = monthlyVariation.map((e) {
      return EmotionRecord(
        id: e['date'],
        blockId: 'summary',
        emotion: Emotion.fromString(e['emotion']),
        createdAt: DateTime.tryParse(e['date']) ?? DateTime.now(),
      );
    }).toList();

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
