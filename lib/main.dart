import 'package:flutter/material.dart';
import 'package:tora_frontend/core/router/router.dart';

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
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Colors.deepPurple[50],
          selectedItemColor: Colors.deepPurple[800],
          unselectedItemColor: Colors.deepPurple[400],
        ),
      ),
    );
  }
}
