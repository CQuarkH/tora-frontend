// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

import 'package:tora_frontend/core/router/router.dart';
import 'package:tora_frontend/core/services/firebase_notifications_service.dart';
import 'package:tora_frontend/core/theme/tora_theme.dart';
import 'package:tora_frontend/features/tora-pet/services/mascota_state.dart';

import 'package:tora_frontend/features/tora-pet/util/accessory_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseNotificationService().initialize();
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AccessoryRepository>(
          create: (_) => AccessoryRepository()..load(),
        ),
        ChangeNotifierProxyProvider<AccessoryRepository, MascotaState>(
          create: (ctx) => MascotaState(ctx.read<AccessoryRepository>()),
          update: (ctx, repo, prev) => prev ?? MascotaState(repo),
        ),
      ],
      child: MaterialApp.router(
        title: 'Tora App',
        debugShowCheckedModeBanner: false,
        routerConfig: appRouter,
        theme: ToraTheme.lightTheme,
      ),
    );
  }
}
