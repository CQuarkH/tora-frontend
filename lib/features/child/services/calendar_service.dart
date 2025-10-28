import 'dart:convert';
import 'package:tora_frontend/core/services/api_client.dart';
import 'package:tora_frontend/features/child/models/calendar.dart';
import 'package:tora_frontend/features/child/models/emotion_record.dart';
import 'package:tora_frontend/features/child/models/task.dart';

class CalendarService {
  static final _apiClient = ApiClient();

  /// Obtener calendario diario
  static Future<Calendar> getDailyCalendar({
    required String childId,
    DateTime? date,
  }) async {
    final query =
        '?childId=$childId${date != null ? '&date=${date.toIso8601String()}' : ''}';
    final response = await _apiClient.get('/calendar/daily$query');

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return Calendar.fromJson(data);
    } else {
      throw Exception('Error al obtener calendario diario: ${response.body}');
    }
  }

  /// Agregar nueva tarea a un bloque
  static Future<Task> addTaskToBlock({
    required String blockId,
    required String title,
    String? description,
  }) async {
    final response = await _apiClient.post('/calendar/blocks/$blockId/tasks', {
      'title': title,
      if (description != null) 'description': description,
    });

    if (response.statusCode == 201 || response.statusCode == 200) {
      final data = json.decode(response.body);
      return Task.fromJson(data);
    } else {
      throw Exception('Error al agregar tarea: ${response.body}');
    }
  }

  /// Actualizar o completar tarea
  static Future<Task> updateTask({
    required String taskId,
    required Map<String, dynamic> updateData,
  }) async {
    final response = await _apiClient.put(
      '/calendar/tasks/$taskId',
      updateData,
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return Task.fromJson(data);
    } else {
      throw Exception('Error al actualizar tarea: ${response.body}');
    }
  }

  /// Eliminar tarea
  static Future<void> deleteTask(String taskId) async {
    final response = await _apiClient.delete('/calendar/tasks/$taskId');
    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Error al eliminar tarea: ${response.body}');
    }
  }

  /// Registrar emoción
  static Future<EmotionRecord> recordEmotion({
    required String blockId,
    required Emotion emotion,
  }) async {
    final response = await _apiClient.post(
      '/calendar/blocks/$blockId/emotion',
      {
        'emotion': emotion.name, // Enum convertido a string
      },
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      final data = json.decode(response.body);
      return EmotionRecord.fromJson(data);
    } else {
      throw Exception('Error al registrar emoción: ${response.body}');
    }
  }
}
