// ignore_for_file: prefer_interpolation_to_compose_strings

import 'package:flutter/material.dart';

enum Emotion { HAPPY, SAD, SO_SO, ANGRY, CONTENT }

class EmotionRecord {
  final String id;
  final String blockId;
  final Emotion emotion;
  final DateTime createdAt;

  EmotionRecord({
    required this.id,
    required this.blockId,
    required this.emotion,
    required this.createdAt,
  });

  factory EmotionRecord.fromJson(Map<String, dynamic> json) {
    return EmotionRecord(
      id: json['id'],
      blockId: json['blockId'],
      emotion: Emotion.values.firstWhere(
        (e) => e.toString() == 'Emotion.' + json['emotion'],
      ),
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'blockId': blockId,
    'emotion': emotion.toString().split('.').last,
    'createdAt': createdAt.toIso8601String(),
  };
}

extension EmotionExtension on Emotion {
  String get displayName {
    switch (this) {
      case Emotion.HAPPY:
        return 'Feliz';
      case Emotion.SAD:
        return 'Triste';
      case Emotion.SO_SO:
        return 'Más o menos';
      case Emotion.ANGRY:
        return 'Enojado';
      case Emotion.CONTENT:
        return 'Contento';
    }
  }

  String get emoji {
    switch (this) {
      case Emotion.HAPPY:
        return '😊';
      case Emotion.SAD:
        return '😢';
      case Emotion.SO_SO:
        return '😐';
      case Emotion.ANGRY:
        return '😠';
      case Emotion.CONTENT:
        return '😌';
    }
  }

  Color get backgroundColor {
    switch (this) {
      case Emotion.HAPPY:
        return Colors.green[100]!;
      case Emotion.SAD:
        return Colors.blue[100]!;
      case Emotion.SO_SO:
        return Colors.grey[100]!;
      case Emotion.ANGRY:
        return Colors.red[100]!;
      case Emotion.CONTENT:
        return Colors.purple[100]!;
    }
  }
}
