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
}
