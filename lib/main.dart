import 'package:flutter/material.dart';
import 'package:tora_frontend/core/router/router.dart';
import 'package:tora_frontend/core/services/firebase_notifications_service.dart';
import 'package:tora_frontend/core/theme/tora_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializar Firebase y Notificaciones
  await FirebaseNotificationService().initialize();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Tora App',
      debugShowCheckedModeBanner: false,
      routerConfig: appRouter,
      theme: ToraTheme.lightTheme,
    );
  }
}
