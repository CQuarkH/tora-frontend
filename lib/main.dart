import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:tora_frontend/core/router/router.dart';
import 'package:tora_frontend/core/theme/tora_theme.dart';

Future<void> main() async {
  runApp(const MyApp());
  await dotenv.load(fileName: ".env");
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
