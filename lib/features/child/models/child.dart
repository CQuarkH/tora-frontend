import 'package:tora_frontend/features/auth/models/user.dart';
import 'dart:convert';

class Child extends User {
  final String name;
  final int age;
  final String grade;
  final String? parentId; // Hacer nullable

  Child({
    required super.id,
    required super.email,
    required super.passwordHash,
    required super.createdAt,
    required super.updatedAt,
    required this.name,
    required this.age,
    required this.grade,
    this.parentId, // Ahora es opcional
  }) : super(role: UserRole.CHILD);

  factory Child.fromJson(Map<String, dynamic> json) {
    return Child(
      id: json['id'] ?? json['_id'] ?? '',
      email: json['email'] ?? '', // ← Valor por defecto
      passwordHash: json['passwordHash'] ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : DateTime.now(),
      name: json['name'] ?? 'Sin nombre',
      age: json['age'] ?? 0,
      grade: json['grade'] ?? '',
      parentId: json['parentId'], // Puede ser null
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'email': email,
    'passwordHash': passwordHash,
    'role': 'CHILD',
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
    'name': name,
    'age': age,
    'grade': grade,
    'parentId': parentId,
  };

  String toJsonString() => json.encode(toJson());

  factory Child.fromJsonString(String jsonString) {
    return Child.fromJson(json.decode(jsonString));
  }

  static Child createSampleChild() {
    return Child(
      id: 'child1',
      email: 'child1@example.com',
      passwordHash: 'hashed_password',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      name: 'Child One',
      age: 10,
      grade: '5th',
      parentId: 'parent1',
    );
  }
}
