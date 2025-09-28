import 'package:flutter/material.dart';
import 'package:tora_frontend/core/router/router.dart';
import 'package:tora_frontend/core/theme/tora_theme.dart';

void main() {
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
