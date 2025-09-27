import 'package:flutter/material.dart';
import 'package:tora_frontend/features/auth/screens/fork_users_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tora App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Colors.deepPurple[50],
          selectedItemColor: Colors.deepPurple[800],
          unselectedItemColor: Colors.deepPurple[400],
        ),
      ),
      home: const ForkUsersScreen(),
    );
  }
}
