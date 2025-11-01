import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:tora_frontend/core/theme/tora_theme.dart';
import 'package:tora_frontend/features/auth/services/auth_service.dart';
import 'package:tora_frontend/features/parent/models/parent.dart';
import 'package:tora_frontend/features/parent/services/parent_service.dart';
import 'package:tora_frontend/features/parent/widgets/emotion_calendar_card.dart';
import 'package:tora_frontend/features/parent/widgets/emotional_status_chart.dart';
import 'package:tora_frontend/features/parent/widgets/parent_kpis_section.dart';
import 'package:tora_frontend/features/parent/widgets/parent_recent_alerts_card.dart';

class ParentDashboardScreen extends HookWidget {
  const ParentDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();

    final dashboardFuture = useMemoized(() async {
      final user = await authService.getCurrentUser() as Parent?;
      if (user == null) return null;

      return ParentService.getDashboard(user.children.first);
    }, []);
    final dashboardSnapshot = useFuture(dashboardFuture);
    final refreshKey = useState(0);

    Future<void> refresh() async {
      refreshKey.value++;
    }

    if (dashboardSnapshot.connectionState == ConnectionState.waiting) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (dashboardSnapshot.hasError) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text('Error: ${dashboardSnapshot.error}'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: refresh,
                child: const Text('Reintentar'),
              ),
            ],
          ),
        ),
      );
    }

    final dashboard = dashboardSnapshot.data;
    if (dashboard == null) {
      return const Scaffold(
        body: Center(child: Text('No hay datos disponibles')),
      );
    }

    return Scaffold(
      backgroundColor: ToraTheme.pureWhite,
      body: RefreshIndicator(
        onRefresh: refresh,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              // Calendario de Emociones
              EmotionCalendarCard(emotions: dashboard.emotions),
              const SizedBox(height: 16),

              // Estado Emocional
              EmotionalStatusChart(emotions: dashboard.emotions),
              const SizedBox(height: 16),

              // Tareas Completadas y Botón Pánico
              ParentKpisSection(dashboard: dashboard),
              const SizedBox(height: 16),

              // Alertas Recientes
              ParentRecentAlertsCard(alerts: dashboard.alerts),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
