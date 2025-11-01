import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:tora_frontend/core/services/api_client.dart';

class FirebaseNotificationService {
  static final FirebaseNotificationService _instance =
      FirebaseNotificationService._internal();
  factory FirebaseNotificationService() => _instance;
  FirebaseNotificationService._internal();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  String? _fcmToken;

  String? get fcmToken => _fcmToken;

  /// Inicializar Firebase y notificaciones
  Future<void> initialize() async {
    try {
      // Inicializar Firebase
      await Firebase.initializeApp();

      // Solicitar permisos
      await _requestPermissions();

      // Configurar notificaciones locales
      await _configureLocalNotifications();

      // Obtener token FCM
      await _getToken();

      // Configurar handlers
      _configureMessageHandlers();

      print('✅ Firebase Notifications inicializadas correctamente');
    } catch (e) {
      print('❌ Error inicializando Firebase: $e');
    }
  }

  /// Solicitar permisos de notificaciones
  Future<void> _requestPermissions() async {
    if (Platform.isIOS) {
      await _firebaseMessaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );
    }

    // Android 13+ requiere permiso en tiempo de ejecución
    final settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );

    print('📲 Permisos de notificación: ${settings.authorizationStatus}');
  }

  /// Configurar notificaciones locales
  Future<void> _configureLocalNotifications() async {
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const iosSettings = DarwinInitializationSettings();

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    // Crear canal de notificaciones para Android
    const androidChannel = AndroidNotificationChannel(
      'default',
      'Notificaciones Tora',
      description: 'Canal principal de notificaciones',
      importance: Importance.high,
    );

    await _localNotifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(androidChannel);
  }

  /// Obtener token FCM
  Future<void> _getToken() async {
    try {
      _fcmToken = await _firebaseMessaging.getToken();
      print('🔑 FCM Token: $_fcmToken');

      if (_fcmToken != null) {
        await _sendTokenToBackend(_fcmToken!);
      }

      // Escuchar cambios en el token
      _firebaseMessaging.onTokenRefresh.listen((newToken) {
        print('🔄 Token renovado: $newToken');
        _fcmToken = newToken;
        _sendTokenToBackend(newToken);
      });
    } catch (e) {
      print('❌ Error obteniendo token: $e');
    }
  }

  /// Enviar token al backend
  Future<void> _sendTokenToBackend(String token) async {
    try {
      final apiClient = ApiClient();
      await apiClient.post('/notifications/register-token', {
        'token': token,
        'deviceType': Platform.isAndroid ? 'ANDROID' : 'IOS',
      });
      print('✅ Token registrado en backend');
    } catch (e) {
      print('❌ Error registrando token en backend: $e');
    }
  }

  /// Configurar handlers de mensajes
  void _configureMessageHandlers() {
    // Cuando la app está en foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print(
        '📩 Mensaje recibido en foreground: ${message.notification?.title}',
      );
      _showLocalNotification(message);
    });

    // Cuando se toca una notificación y la app estaba en background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('🔔 Notificación tocada (app en background): ${message.data}');
      _handleNotificationNavigation(message);
    });

    // Cuando se toca una notificación y la app estaba cerrada
    _firebaseMessaging.getInitialMessage().then((RemoteMessage? message) {
      if (message != null) {
        print('🔔 App abierta desde notificación: ${message.data}');
        _handleNotificationNavigation(message);
      }
    });
  }

  /// Mostrar notificación local
  Future<void> _showLocalNotification(RemoteMessage message) async {
    final notification = message.notification;
    final android = message.notification?.android;

    if (notification != null) {
      await _localNotifications.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            'default',
            'Notificaciones Tora',
            channelDescription: 'Canal principal de notificaciones',
            importance: Importance.high,
            priority: Priority.high,
            icon: '@mipmap/ic_launcher',
          ),
          iOS: const DarwinNotificationDetails(),
        ),
        payload: message.data.toString(),
      );
    }
  }

  /// Manejar tap en notificación
  void _onNotificationTapped(NotificationResponse response) {
    print('🔔 Notificación tocada: ${response.payload}');
    // Aquí puedes navegar a pantallas específicas según el tipo
  }

  /// Navegar según el tipo de notificación
  void _handleNotificationNavigation(RemoteMessage message) {
    final data = message.data;
    final type = data['type'];

    switch (type) {
      case 'TASK_REMINDER':
        // Navegar a calendario
        print('📝 Navegar a tareas');
        break;
      case 'EMOTION_CHECKIN':
        // Navegar a registro de emociones
        print('😊 Navegar a emociones');
        break;
      case 'ALERT':
        // Navegar a alertas
        print('🚨 Navegar a alertas');
        break;
      case 'TEST':
        print('🧪 Notificación de prueba');
        break;
      default:
        print('📱 Notificación general');
    }
  }

  /// Enviar notificación de prueba
  Future<void> sendTestNotification() async {
    try {
      final apiClient = ApiClient();
      final response = await apiClient.post('/notifications/test', {});
      print('✅ Test notification sent: $response');
    } catch (e) {
      print('❌ Error sending test: $e');
    }
  }
}
