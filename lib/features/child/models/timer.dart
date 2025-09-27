enum TimerStatus { stopped, running, paused, completed }

class TimerModel {
  final String id;
  final String name;
  final Duration duration;
  final Duration remainingTime;
  final TimerStatus status;
  final DateTime? startTime;
  final DateTime? endTime;
  final String? description;
  final bool hasSound;
  final bool hasVibration;

  const TimerModel({
    required this.id,
    required this.name,
    required this.duration,
    required this.remainingTime,
    required this.status,
    this.startTime,
    this.endTime,
    this.description,
    this.hasSound = true,
    this.hasVibration = true,
  });

  TimerModel copyWith({
    String? id,
    String? name,
    Duration? duration,
    Duration? remainingTime,
    TimerStatus? status,
    DateTime? startTime,
    DateTime? endTime,
    String? description,
    bool? hasSound,
    bool? hasVibration,
  }) {
    return TimerModel(
      id: id ?? this.id,
      name: name ?? this.name,
      duration: duration ?? this.duration,
      remainingTime: remainingTime ?? this.remainingTime,
      status: status ?? this.status,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      description: description ?? this.description,
      hasSound: hasSound ?? this.hasSound,
      hasVibration: hasVibration ?? this.hasVibration,
    );
  }

  // Formatear tiempo para mostrar
  String get formattedRemainingTime {
    final hours = remainingTime.inHours;
    final minutes = remainingTime.inMinutes % 60;
    final seconds = remainingTime.inSeconds % 60;

    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    } else {
      return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    }
  }

  String get formattedDuration {
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;
    final seconds = duration.inSeconds % 60;

    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    } else {
      return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    }
  }

  double get progress {
    if (duration.inSeconds == 0) return 0.0;
    return 1.0 - (remainingTime.inSeconds / duration.inSeconds);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TimerModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
