class Alert {
  final String id;
  final String type;
  final String description;
  final String message;
  final String timestamp;
  final bool resolved;
  final bool read; // Nuevo campo
  final Map<String, dynamic>? data; // Nuevo campo para datos extras

  Alert({
    required this.id,
    required this.type,
    required this.description,
    required this.message,
    required this.timestamp,
    required this.resolved,
    this.read = false,
    this.data,
  });

  factory Alert.fromJson(Map<String, dynamic> json) {
    return Alert(
      id: json['id'] ?? json['_id'] ?? '',
      type: json['type'] ?? 'general',
      description: json['description'] ?? json['message'] ?? '',
      message: json['message'] ?? json['description'] ?? '',
      timestamp: json['timestamp'] ?? DateTime.now().toIso8601String(),
      resolved: json['resolved'] ?? false,
      read: json['read'] ?? false,
      data: json['data'],
    );
  }

  // Crear Alert desde RemoteMessage de Firebase
  factory Alert.fromFirebaseMessage(
    Map<String, dynamic> data,
    String? title,
    String? body,
  ) {
    return Alert(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: data['type'] ?? 'NOTIFICATION',
      description: body ?? '',
      message: body ?? '',
      timestamp: DateTime.now().toIso8601String(),
      resolved: false,
      read: false,
      data: data,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'type': type,
    'description': description,
    'message': message,
    'timestamp': timestamp,
    'resolved': resolved,
    'read': read,
    'data': data,
  };

  Alert copyWith({
    String? id,
    String? type,
    String? description,
    String? message,
    String? timestamp,
    bool? resolved,
    bool? read,
    Map<String, dynamic>? data,
  }) {
    return Alert(
      id: id ?? this.id,
      type: type ?? this.type,
      description: description ?? this.description,
      message: message ?? this.message,
      timestamp: timestamp ?? this.timestamp,
      resolved: resolved ?? this.resolved,
      read: read ?? this.read,
      data: data ?? this.data,
    );
  }
}
