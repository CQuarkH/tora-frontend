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

  static Calendar createSampleCalendar(String childId, {DateTime? date}) {
    final now = date ?? DateTime.now();
    final calendarId = 'cal_${now.millisecondsSinceEpoch}';

    return Calendar(
      id: calendarId,
      childId: childId,
      date: DateTime(now.year, now.month, now.day),
      blocks: [
        CalendarBlock(
          id: 'block_morning_$calendarId',
          calendarId: calendarId,
          period: Period.MORNING,
          tasks: [
            Task(
              id: 'task_1',
              blockId: 'block_morning_$calendarId',
              title: 'Lavarme los dientes',
              description: 'Cepillarse los dientes por 2 minutos',
              status: TaskStatus.PENDING,
              createdAt: now,
            ),
            Task(
              id: 'task_2',
              blockId: 'block_morning_$calendarId',
              title: 'Vestirme',
              description: 'Ponerme el uniforme escolar',
              status: TaskStatus.PENDING,
              createdAt: now,
            ),
            Task(
              id: 'task_3',
              blockId: 'block_morning_$calendarId',
              title: 'Desayunar',
              description: 'Tomar desayuno saludable',
              status: TaskStatus.PENDING,
              createdAt: now,
            ),
          ],
        ),
        CalendarBlock(
          id: 'block_afternoon_$calendarId',
          calendarId: calendarId,
          period: Period.AFTERNOON,
          tasks: [
            Task(
              id: 'task_4',
              blockId: 'block_afternoon_$calendarId',
              title: 'Hacer tareas',
              description: 'Completar las tareas del colegio',
              status: TaskStatus.PENDING,
              createdAt: now,
            ),
            Task(
              id: 'task_5',
              blockId: 'block_afternoon_$calendarId',
              title: 'Jugar',
              description: 'Tiempo libre para jugar',
              status: TaskStatus.PENDING,
              createdAt: now,
            ),
          ],
        ),
        CalendarBlock(
          id: 'block_evening_$calendarId',
          calendarId: calendarId,
          period: Period.EVENING,
          tasks: [
            Task(
              id: 'task_6',
              blockId: 'block_evening_$calendarId',
              title: 'Cenar',
              description: 'Cenar en familia',
              status: TaskStatus.PENDING,
              createdAt: now,
            ),
            Task(
              id: 'task_7',
              blockId: 'block_evening_$calendarId',
              title: 'Preparar mochila',
              description: 'Preparar materiales para mañana',
              status: TaskStatus.PENDING,
              createdAt: now,
            ),
          ],
        ),
      ],
    );
  }
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
