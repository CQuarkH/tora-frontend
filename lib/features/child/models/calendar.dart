import 'package:flutter/material.dart';
import 'package:tora_frontend/features/child/models/emotion_record.dart';
import 'package:tora_frontend/features/child/models/task.dart';

enum Period { MORNING, AFTERNOON, EVENING }

class Calendar {
  final String id;
  final String childId;
  final DateTime date;
  final List<CalendarBlock> blocks;

  Calendar({
    required this.id,
    required this.childId,
    required this.date,
    required this.blocks,
  });
}

class CalendarBlock {
  final String id;
  final String calendarId;
  final Period period;
  final List<Task> tasks;
  final EmotionRecord? emotion;

  CalendarBlock({
    required this.id,
    required this.calendarId,
    required this.period,
    required this.tasks,
    this.emotion,
  });

  CalendarBlock copyWith({
    String? id,
    String? calendarId,
    Period? period,
    List<Task>? tasks,
    EmotionRecord? emotion,
  }) {
    return CalendarBlock(
      id: id ?? this.id,
      calendarId: calendarId ?? this.calendarId,
      period: period ?? this.period,
      tasks: tasks ?? this.tasks,
      emotion: emotion ?? this.emotion,
    );
  }
}

extension PeriodExtension on Period {
  String get displayName {
    switch (this) {
      case Period.MORNING:
        return 'Mañana';
      case Period.AFTERNOON:
        return 'Tarde';
      case Period.EVENING:
        return 'Noche';
    }
  }

  String get emoji {
    switch (this) {
      case Period.MORNING:
        return '☀️';
      case Period.AFTERNOON:
        return '☀️';
      case Period.EVENING:
        return '🌙';
    }
  }

  Color get backgroundColor {
    switch (this) {
      case Period.MORNING:
        return Colors.orange[100]!;
      case Period.AFTERNOON:
        return Colors.orange[50]!;
      case Period.EVENING:
        return Colors.blue[100]!;
    }
  }

  Color get borderColor {
    switch (this) {
      case Period.MORNING:
        return Colors.orange;
      case Period.AFTERNOON:
        return Colors.orange[200]!;
      case Period.EVENING:
        return Colors.blue[200]!;
    }
  }
}
