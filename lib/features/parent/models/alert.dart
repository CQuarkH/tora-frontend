class Alert {
  final String id;

  final String type;
  final String description;
  final String timestamp;

  Alert({
    required this.id,
    required this.type,
    required this.description,
    required this.timestamp,
  });

  factory Alert.fromJson(Map<String, dynamic> json) => Alert(
    id: json['id'],
    type: json['type'],
    description: json['description'],
    timestamp: json['timestamp'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'type': type,
    'description': description,
    'timestamp': timestamp,
  };
}
