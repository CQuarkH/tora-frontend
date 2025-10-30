class RegistrationErrorHandler {
  static String getUserFriendlyMessage(String error) {
    if (error.contains('Email already exists') ||
        error.contains('already exists')) {
      return 'Este correo ya está registrado. Por favor usa otro.';
    }

    if (error.contains('Invalid parent ID')) {
      return 'Hubo un error al vincular las cuentas. Intenta nuevamente.';
    }

    if (error.contains('Parent not found')) {
      return 'No se pudo encontrar la cuenta del padre. Intenta nuevamente.';
    }

    if (error.contains('Invalid credentials')) {
      return 'Credenciales inválidas. Verifica tus datos.';
    }

    if (error.contains('Network') || error.contains('conexión')) {
      return 'Error de conexión. Verifica tu internet.';
    }

    return 'Ocurrió un error inesperado. Por favor intenta nuevamente.';
  }
}
