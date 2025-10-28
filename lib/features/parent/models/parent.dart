import 'package:tora_frontend/features/auth/models/user.dart';
import 'dart:convert';

class Parent extends User {
  final String name;
  final String phone;
  final List<String> children;

  Parent({
    required super.id,
    required super.email,
    required super.passwordHash,
    required super.createdAt,
    required super.updatedAt,
    required this.name,
    required this.phone,
    required this.children,
  }) : super(role: UserRole.PARENT);

  factory Parent.fromJson(Map<String, dynamic> json) {
    return Parent(
      id: json['id'],
      email: json['email'],
      passwordHash: json['passwordHash'] ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : DateTime.now(),
      name: json['name'],
      phone: json['phone'],
      children: json['children'] != null
          ? List<String>.from(json['children'])
          : [],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'email': email,
    'passwordHash': passwordHash,
    'role': 'PARENT',
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
    'name': name,
    'phone': phone,
    'children': children,
  };

  String toJsonString() => json.encode(toJson());

  factory Parent.fromJsonString(String jsonString) {
    return Parent.fromJson(json.decode(jsonString));
  }
}
