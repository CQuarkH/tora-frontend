// services/timer_service.dart
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:tora_frontend/features/child/models/timer.dart';
import 'package:vibration/vibration.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import 'package:permission_handler/permission_handler.dart';

class TimerService extends ChangeNotifier {
  static final TimerService _instance = TimerService._internal();
  factory TimerService() => _instance;
  TimerService._internal();

  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();
  final AudioPlayer _audioPlayer = AudioPlayer();

  final Map<String, Timer> _activeTimers = {};
  final Map<String, TimerModel> _timers = {};

  Map<String, TimerModel> get timers => Map.unmodifiable(_timers);

  Future<void> initialize() async {
    // Solicitar permisos de notificación primero
    await _requestNotificationPermissions();

    // Inicializar notificaciones
    const initializationSettingsAndroid = AndroidInitializationSettings(
      'app_icon',
    );
    const initializationSettingsIOS = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    const initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    try {
      final bool? initialized = await _notifications.initialize(
        initializationSettings,
        onDidReceiveNotificationResponse: (NotificationResponse response) {
          debugPrint('Notificación tocada: ${response.payload}');
        },
      );

      debugPrint('Notificaciones inicializadas: $initialized');

      // Crear canal de notificaciones en Android
      await _createNotificationChannel();
    } catch (e) {
      debugPrint('Error inicializando notificaciones: $e');
    }
  }

  Future<void> _requestNotificationPermissions() async {
    // Solicitar permisos para Android 13+
    if (await Permission.notification.isDenied) {
      await Permission.notification.request();
    }

    // Verificar el estado del permiso
    final status = await Permission.notification.status;
    debugPrint('Estado del permiso de notificaciones: $status');
  }

  Future<void> _createNotificationChannel() async {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'timer_channel',
      'Timer Notifications',
      description: 'Notificaciones de timers completados',
      importance: Importance.high,
      enableVibration: true,
      playSound: true,
    );

    final AndroidFlutterLocalNotificationsPlugin? androidPlugin = _notifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    if (androidPlugin != null) {
      await androidPlugin.createNotificationChannel(channel);
      debugPrint('Canal de notificaciones creado');
    }
  }

  void addTimer(TimerModel timer) {
    _timers[timer.id] = timer;
    notifyListeners();
  }

  void removeTimer(String timerId) {
    stopTimer(timerId);
    _timers.remove(timerId);
    notifyListeners();
  }

  void startTimer(String timerId) {
    final timer = _timers[timerId];
    if (timer == null || timer.status == TimerStatus.running) return;

    // Activar wakelock para mantener la pantalla activa
    WakelockPlus.enable();

    _timers[timerId] = timer.copyWith(
      status: TimerStatus.running,
      startTime: DateTime.now(),
    );

    _activeTimers[timerId] = Timer.periodic(
      const Duration(seconds: 1),
      (activeTimer) => _updateTimer(timerId, activeTimer),
    );

    notifyListeners();
  }

  void pauseTimer(String timerId) {
    final timer = _timers[timerId];
    if (timer == null || timer.status != TimerStatus.running) return;

    _activeTimers[timerId]?.cancel();
    _activeTimers.remove(timerId);

    _timers[timerId] = timer.copyWith(status: TimerStatus.paused);

    // Desactivar wakelock si no hay más timers activos
    if (_activeTimers.isEmpty) {
      WakelockPlus.disable();
    }

    notifyListeners();
  }

  void stopTimer(String timerId) {
    final timer = _timers[timerId];
    if (timer == null) return;

    _activeTimers[timerId]?.cancel();
    _activeTimers.remove(timerId);

    _timers[timerId] = timer.copyWith(
      status: TimerStatus.stopped,
      remainingTime: timer.duration,
      startTime: null,
      endTime: null,
    );

    // Desactivar wakelock si no hay más timers activos
    if (_activeTimers.isEmpty) {
      WakelockPlus.disable();
    }

    notifyListeners();
  }

  void _updateTimer(String timerId, Timer activeTimer) {
    final timer = _timers[timerId];
    if (timer == null) {
      activeTimer.cancel();
      return;
    }

    final newRemainingTime = timer.remainingTime - const Duration(seconds: 1);

    if (newRemainingTime <= Duration.zero) {
      // Timer completado
      _completeTimer(timerId);
      activeTimer.cancel();
    } else {
      _timers[timerId] = timer.copyWith(remainingTime: newRemainingTime);
      notifyListeners();
    }
  }

  void _completeTimer(String timerId) {
    final timer = _timers[timerId];
    if (timer == null) return;

    _activeTimers.remove(timerId);
    _timers[timerId] = timer.copyWith(
      status: TimerStatus.completed,
      remainingTime: Duration.zero,
      endTime: DateTime.now(),
    );

    // Desactivar wakelock si no hay más timers activos
    if (_activeTimers.isEmpty) {
      WakelockPlus.disable();
    }

    // Reproducir sonido y vibración
    _playCompletionAlert(timer);

    // Mostrar notificación
    _showCompletionNotification(timer);

    notifyListeners();
  }

  Future<void> _playCompletionAlert(TimerModel timer) async {
    if (timer.hasVibration) {
      // Vibrar por 1 segundo
      if (await Vibration.hasVibrator()) {
        Vibration.vibrate(duration: 1000);
      }
    }

    if (timer.hasSound) {
      try {
        // Reproducir sonido de alarma (puedes cambiar por tu archivo de audio)
        await _audioPlayer.play(AssetSource('sounds/timer_complete.mp3'));
      } catch (e) {
        debugPrint('Error reproduciendo sonido: $e');
      }
    }
  }

  Future<void> _showCompletionNotification(TimerModel timer) async {
    try {
      // Verificar que tenemos permisos
      final hasPermission = await Permission.notification.isGranted;
      debugPrint('¿Tiene permisos de notificación? $hasPermission');

      if (!hasPermission) {
        debugPrint('Sin permisos de notificación, solicitando...');
        final status = await Permission.notification.request();
        if (status != PermissionStatus.granted) {
          debugPrint('Permisos de notificación denegados');
          return;
        }
      }

      const androidDetails = AndroidNotificationDetails(
        'timer_channel',
        'Timer Notifications',
        channelDescription: 'Notificaciones de timers completados',
        importance: Importance.high,
        priority: Priority.high,
        icon: 'app_icon',
        enableVibration: true,
        playSound: true,
        autoCancel: true,
        fullScreenIntent: true,
        category: AndroidNotificationCategory.alarm,
        visibility: NotificationVisibility.public,
      );

      const iosDetails = DarwinNotificationDetails(
        sound: 'default',
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
        interruptionLevel: InterruptionLevel.critical,
      );

      const notificationDetails = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      debugPrint('Mostrando notificación para timer ${timer.name}');
      debugPrint('ID de notificación: ${timer.id.hashCode}');

      await _notifications.show(
        timer.id.hashCode,
        '🎉 ¡Timer completado!',
        '${timer.name} ha terminado - ¡Buen trabajo!',
        notificationDetails,
        payload: 'timer_completed_${timer.id}',
      );

      debugPrint('Notificación enviada exitosamente');

      // Verificar notificaciones pendientes
      final pendingNotifications = await _notifications
          .pendingNotificationRequests();
      debugPrint('Notificaciones pendientes: ${pendingNotifications.length}');

      final activeNotifications = await _notifications.getActiveNotifications();
      debugPrint('Notificaciones activas: ${activeNotifications.length}');
    } catch (e, stackTrace) {
      debugPrint('Error completo mostrando notificación: $e');
      debugPrint('Stack trace: $stackTrace');

      // Fallback: mostrar en consola
      debugPrint('🎉 TIMER COMPLETADO: ${timer.name}');
    }
  }

  void resetTimer(String timerId) {
    final timer = _timers[timerId];
    if (timer == null) return;

    stopTimer(timerId);
    _timers[timerId] = timer.copyWith(
      remainingTime: timer.duration,
      status: TimerStatus.stopped,
    );
    notifyListeners();
  }

  @override
  void dispose() {
    for (final timer in _activeTimers.values) {
      timer.cancel();
    }
    _activeTimers.clear();
    WakelockPlus.disable();
    _audioPlayer.dispose();
    super.dispose();
  }
}
