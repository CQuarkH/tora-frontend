enum TaskStatus { PENDING, DONE }

class Task {
  final String id;
  final String blockId;
  final String title;
  final String? description;
  final TaskStatus status;
  final DateTime? startTime;
  final DateTime? endTime;
  final DateTime createdAt;

  Task({
    required this.id,
    required this.blockId,
    required this.title,
    this.description,
    required this.status,
    this.startTime,
    this.endTime,
    required this.createdAt,
  });

  Task copyWith({
    String? id,
    String? blockId,
    String? title,
    String? description,
    TaskStatus? status,
    DateTime? startTime,
    DateTime? endTime,
    DateTime? createdAt,
  }) {
    return Task(
      id: id ?? this.id,
      blockId: blockId ?? this.blockId,
      title: title ?? this.title,
      description: description ?? this.description,
      status: status ?? this.status,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
