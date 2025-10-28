import 'package:tora_frontend/features/auth/models/user.dart';
import 'package:tora_frontend/features/child/models/child.dart';
import 'package:tora_frontend/features/parent/models/parent.dart';

class LoginResponse {
  final String accessToken;
  final User user;

  LoginResponse({required this.accessToken, required this.user});

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    final userRole = json['user']['role'];
    final User user;

    if (userRole == 'child' || userRole == 'CHILD') {
      user = Child.fromJson(json['user']);
    } else {
      user = Parent.fromJson(json['user']);
    }

    return LoginResponse(accessToken: json['access_token'], user: user);
  }
}
