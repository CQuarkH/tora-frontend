import 'package:tora_frontend/features/auth/models/login_response.dart';

class RegistrationResult {
  final bool success;
  final String? parentId;
  final String? childId;
  final LoginResponse? loginResponse;
  final String? error;

  RegistrationResult({
    required this.success,
    this.parentId,
    this.childId,
    this.loginResponse,
    this.error,
  });
}
