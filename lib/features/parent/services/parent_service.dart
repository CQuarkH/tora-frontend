import 'dart:async';
import 'package:tora_frontend/features/child/models/child.dart';
import 'package:tora_frontend/features/child/models/emotion_record.dart';
import 'package:tora_frontend/features/parent/models/alert.dart';
import 'package:tora_frontend/features/parent/models/parent_dashboard.dart';

class ParentService {
  Future<ParentDashboard> getDashboard(String parentId) async {
    await Future.delayed(const Duration(seconds: 1));
    final child = Child.createSampleChild();

    final summary = ParentDashboardSummary(
      completedTasksPercentage: 85.0,
      panicButtonCount: 2,
    );

    final now = DateTime.now();
    final emotions = [
      EmotionRecord(
        id: 'em1',
        blockId: 'morning',
        emotion: Emotion.HAPPY,
        createdAt: now.subtract(const Duration(days: 1)),
      ),
      EmotionRecord(
        id: 'em2',
        blockId: 'afternoon',
        emotion: Emotion.SO_SO,
        createdAt: now.subtract(const Duration(days: 1)),
      ),
      EmotionRecord(
        id: 'em3',
        blockId: 'evening',
        emotion: Emotion.CONTENT,
        createdAt: now.subtract(const Duration(days: 1)),
      ),
      EmotionRecord(
        id: 'em4',
        blockId: 'morning',
        emotion: Emotion.SAD,
        createdAt: now.subtract(const Duration(days: 2)),
      ),
      EmotionRecord(
        id: 'em5',
        blockId: 'afternoon',
        emotion: Emotion.ANGRY,
        createdAt: now.subtract(const Duration(days: 2)),
      ),
    ];

    final alerts = [
      Alert(
        id: 'alert_001',
        type: 'DYSREGULATION',
        description: 'Desregulación en recreo',
        timestamp: DateTime.now()
            .subtract(const Duration(hours: 20))
            .toIso8601String(),
      ),
      Alert(
        id: 'alert_002',
        type: 'PANIC_BUTTON',
        description: 'Botón de pánico activado',
        timestamp: DateTime.now()
            .subtract(const Duration(days: 2, hours: 3))
            .toIso8601String(),
      ),
    ];

    return ParentDashboard(
      child: child,
      summary: summary,
      emotions: emotions,
      alerts: alerts,
    );
  }

  Future<List<Alert>> getAlerts(String parentId) async {
    await Future.delayed(const Duration(milliseconds: 600));

    return [
      Alert(
        id: 'alert_003',
        type: 'PANIC_BUTTON',
        description: 'Botón de pánico activado durante la clase',
        timestamp: DateTime.now()
            .subtract(const Duration(hours: 4))
            .toIso8601String(),
      ),
      Alert(
        id: 'alert_004',
        type: 'DYSREGULATION',
        description: 'Desregulación durante el almuerzo',
        timestamp: DateTime.now()
            .subtract(const Duration(days: 1, hours: 3))
            .toIso8601String(),
      ),
    ];
  }
}
