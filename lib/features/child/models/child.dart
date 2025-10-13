import 'package:tora_frontend/features/auth/models/user.dart';

class Child extends User {
  final String name;
  final int age;
  final String grade;
  final String parentId;

  Child({
    required super.id,
    required super.email,
    required super.passwordHash,
    required super.createdAt,
    required super.updatedAt,
    required this.name,
    required this.age,
    required this.grade,
    required this.parentId,
  }) : super(role: UserRole.CHILD);

  static Child createSampleChild() {
    final now = DateTime.now();
    return Child(
      id: 'child_123',
      email: 'child@example.com',
      passwordHash: 'hashed_password',
      createdAt: now,
      updatedAt: now,
      name: 'María',
      age: 8,
      grade: '3° básico',
      parentId: 'parent_456',
    );
  }

  factory Child.fromJson(Map<String, dynamic> json) {
    return Child(
      id: json['id'],
      email: json['email'],
      passwordHash: json['passwordHash'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      name: json['name'],
      age: json['age'],
      grade: json['grade'],
      parentId: json['parentId'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'email': email,
    'passwordHash': passwordHash,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
    'name': name,
    'age': age,
    'grade': grade,
    'parentId': parentId,
  };
}
