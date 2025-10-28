import 'package:tora_frontend/features/child/models/child.dart';
import 'package:tora_frontend/features/child/models/emotion_record.dart';
import 'package:tora_frontend/features/parent/models/alert.dart';

class ParentDashboard {
  final Child child;
  final ParentDashboardSummary summary;
  final List<EmotionRecord> emotions;
  final List<Alert> alerts;

  ParentDashboard({
    required this.child,
    required this.summary,
    required this.emotions,
    required this.alerts,
  });

  factory ParentDashboard.fromJson(Map<String, dynamic> json) {
    return ParentDashboard(
      child: Child.fromJson(json['child']),
      summary: ParentDashboardSummary.fromJson(json['summary']),
      emotions: (json['emotions'] as List<dynamic>)
          .map((e) => EmotionRecord.fromJson(e))
          .toList(),
      alerts: (json['alerts'] as List<dynamic>)
          .map((a) => Alert.fromJson(a))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'child': child.toJson(),
    'summary': summary.toJson(),
    'emotions': emotions.map((e) => e.toJson()).toList(),
    'alerts': alerts.map((a) => a.toJson()).toList(),
  };
}

class ParentDashboardSummary {
  final double completedTasksPercentage;
  final int panicButtonCount;
  final int? totalTasks;
  final int? completedTasks;

  ParentDashboardSummary({
    required this.completedTasksPercentage,
    required this.panicButtonCount,
    this.totalTasks,
    this.completedTasks,
  });

  factory ParentDashboardSummary.fromJson(Map<String, dynamic> json) {
    return ParentDashboardSummary(
      completedTasksPercentage: (json['completedTasksPercentage'] ?? 0)
          .toDouble(),
      panicButtonCount: json['panicButtonCount'] ?? 0,
      totalTasks: json['totalTasks'],
      completedTasks: json['completedTasks'],
    );
  }

  Map<String, dynamic> toJson() => {
    'completedTasksPercentage': completedTasksPercentage,
    'panicButtonCount': panicButtonCount,
    'totalTasks': totalTasks,
    'completedTasks': completedTasks,
  };
}
