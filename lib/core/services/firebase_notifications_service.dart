import 'dart:convert';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:tora_frontend/core/services/api_client.dart';
import 'package:tora_frontend/features/auth/services/auth_service.dart';
import 'package:tora_frontend/features/child/models/child.dart';
import 'package:tora_frontend/features/parent/services/notification_storage_service.dart';
import 'package:tora_frontend/features/parent/models/alert.dart';

class FirebaseNotificationService {
  static final FirebaseNotificationService _instance =
      FirebaseNotificationService._internal();
  factory FirebaseNotificationService() => _instance;
  FirebaseNotificationService._internal();

  FirebaseMessaging? _firebaseMessaging;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  String? _fcmToken;
  bool _initialized = false;
  bool _tokenRegisteredInBackend = false; // ← NUEVO FLAG

  String? get fcmToken => _fcmToken;
  bool get isInitialized => _initialized;

  /// Inicializar Firebase (SIN registrar en backend todavía)
  Future<void> initialize() async {
    if (_initialized) {
      print('⚠️ Firebase ya está inicializado');
      return;
    }

    try {
      print('🔄 Inicializando Firebase...');

      await Firebase.initializeApp();
      print('✅ Firebase Core inicializado');

      _firebaseMessaging = FirebaseMessaging.instance;
      print('✅ FirebaseMessaging instance creada');

      await _requestPermissions();
      await _configureLocalNotifications();
      await _getToken(); // Solo obtiene el token, NO lo envía al backend
      _configureMessageHandlers();

      _initialized = true;
      print('✅ Firebase Notifications inicializadas correctamente');
    } catch (e, stackTrace) {
      print('❌ Error inicializando Firebase: $e');
      print('Stack trace: $stackTrace');
      _initialized = false;
    }
  }

  /// Obtener token FCM (SIN enviarlo al backend)
  Future<void> _getToken() async {
    if (_firebaseMessaging == null) {
      print('❌ FirebaseMessaging no está inicializado');
      return;
    }

    try {
      _fcmToken = await _firebaseMessaging!.getToken();
      print('🔑 FCM Token obtenido: $_fcmToken');

      // ⚠️ NO llamar a _sendTokenToBackend aquí
      // Se llamará después del login

      // Escuchar cambios en el token
      _firebaseMessaging!.onTokenRefresh.listen((newToken) {
        print('🔄 Token renovado: $newToken');
        _fcmToken = newToken;
        // Si ya había login, registrar el nuevo token
        if (_tokenRegisteredInBackend) {
          _sendTokenToBackend(newToken);
        }
      });
    } catch (e) {
      print('❌ Error obteniendo token: $e');
    }
  }

  /// Registrar token en el backend (llamar DESPUÉS del login)
  Future<bool> registerTokenInBackend() async {
    if (_fcmToken == null) {
      print('⚠️ No hay token FCM para registrar');
      return false;
    }

    if (_tokenRegisteredInBackend) {
      print('⚠️ Token ya está registrado en backend');
      return true;
    }

    return await _sendTokenToBackend(_fcmToken!);
  }

  /// Enviar token al backend
  Future<bool> _sendTokenToBackend(String token) async {
    try {
      print('📤 Enviando token al backend...');
      final apiClient = ApiClient();

      await apiClient.post('/notifications/register-token', {
        'token': token,
        'deviceType': Platform.isAndroid ? 'ANDROID' : 'IOS',
      });

      _tokenRegisteredInBackend = true;
      print('✅ Token registrado en backend exitosamente');
      return true;
    } catch (e) {
      print('❌ Error registrando token en backend: $e');
      _tokenRegisteredInBackend = false;
      return false;
    }
  }

  /// Eliminar token del backend (llamar en logout)
  Future<bool> unregisterTokenFromBackend() async {
    try {
      print('📤 Eliminando token del backend');
      final apiClient = ApiClient();

      await apiClient.delete('/notifications/unregister-token/$_fcmToken');

      _tokenRegisteredInBackend = false;
      print('✅ Token eliminado del backend exitosamente');
      return true;
    } catch (e) {
      print('❌ Error eliminando token en backend: $e');
      _tokenRegisteredInBackend = false;
      return false;
    }
  }

  /// Solicitar permisos de notificaciones
  Future<void> _requestPermissions() async {
    if (_firebaseMessaging == null) {
      print('❌ FirebaseMessaging no está inicializado');
      return;
    }

    try {
      if (Platform.isIOS) {
        await _firebaseMessaging!.requestPermission(
          alert: true,
          badge: true,
          sound: true,
        );
      }

      final settings = await _firebaseMessaging!.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        provisional: false,
      );

      print('📲 Permisos de notificación: ${settings.authorizationStatus}');
    } catch (e) {
      print('❌ Error solicitando permisos: $e');
    }
  }

  /// Configurar notificaciones locales
  Future<void> _configureLocalNotifications() async {
    try {
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

      print('✅ Notificaciones locales configuradas');
    } catch (e) {
      print('❌ Error configurando notificaciones locales: $e');
    }
  }

  /// Configurar handlers de mensajes
  void _configureMessageHandlers() {
    if (_firebaseMessaging == null) {
      print('❌ FirebaseMessaging no está inicializado');
      return;
    }

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print(
        '📩 Mensaje recibido en foreground: ${message.notification?.title}',
      );

      final alert = Alert.fromFirebaseMessage(
        message.data,
        message.notification?.title,
        message.notification?.body,
      );
      await NotificationStorageService.addNotification(alert);

      _showLocalNotification(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      print('🔔 Notificación tocada (app en background): ${message.data}');

      final alert = Alert.fromFirebaseMessage(
        message.data,
        message.notification?.title,
        message.notification?.body,
      );
      await NotificationStorageService.addNotification(alert);

      _handleNotificationNavigation(message);
    });

    _firebaseMessaging!.getInitialMessage().then((
      RemoteMessage? message,
    ) async {
      if (message != null) {
        print('🔔 App abierta desde notificación: ${message.data}');

        final alert = Alert.fromFirebaseMessage(
          message.data,
          message.notification?.title,
          message.notification?.body,
        );
        await NotificationStorageService.addNotification(alert);

        _handleNotificationNavigation(message);
      }
    });
  }

  /// Mostrar notificación local
  Future<void> _showLocalNotification(RemoteMessage message) async {
    final notification = message.notification;

    if (notification != null) {
      await _localNotifications.show(
        notification.hashCode,
        notification.title,
        notification.body,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'default',
            'Notificaciones Tora',
            channelDescription: 'Canal principal de notificaciones',
            importance: Importance.high,
            priority: Priority.high,
            icon: '@mipmap/ic_launcher',
          ),
          iOS: DarwinNotificationDetails(),
        ),
        payload: message.data.toString(),
      );
    }
  }

  void _onNotificationTapped(NotificationResponse response) {
    print('🔔 Notificación tocada: ${response.payload}');
  }

  void _handleNotificationNavigation(RemoteMessage message) {
    final data = message.data;
    final type = data['type'];

    switch (type) {
      case 'TASK_REMINDER':
        print('📝 Navegar a tareas');
        break;
      case 'EMOTION_CHECKIN':
        print('😊 Navegar a emociones');
        break;
      case 'ALERT':
        print('🚨 Navegar a alertas');
        break;
      case 'TEST':
        print('🧪 Notificación de prueba');
        break;
      default:
        print('📱 Notificación general');
    }
  }

  Future<Map<String, dynamic>> sendTestToParent({
    required String title,
    required String body,
    Map<String, String>? data,
  }) async {
    try {
      // Obtener usuario actual (debe ser un niño)
      final AuthService _authService = AuthService();
      final ApiClient _apiClient = ApiClient();
      final user = await _authService.getCurrentUser();

      if (user == null || user is! Child) {
        throw Exception('Usuario no es un niño');
      }

      final child = user as Child;

      if (child.parentId == null) {
        throw Exception('No hay padre asignado');
      }

      print('📤 Enviando notificación de prueba al padre...');
      print('  Parent ID: ${child.parentId}');
      print('  Title: $title');
      print('  Body: $body');

      final response = await _apiClient.post('/notifications/send-to-parent', {
        'parentId': child.parentId,
        'title': title,
        'body': body,
        'data':
            data ??
            {
              'type': 'TEST',
              'timestamp': DateTime.now().toIso8601String(),
              'sentBy': 'child',
            },
      });

      if (response.statusCode == 200 || response.statusCode == 201) {
        final result = json.decode(response.body);
        print('✅ Notificación enviada exitosamente');
        print('Resultado: $result');
        return {
          'success': true,
          'message': 'Notificación enviada al padre',
          'data': result,
        };
      } else {
        throw Exception('Error del servidor: ${response.body}');
      }
    } catch (e) {
      print('❌ Error enviando notificación: $e');
      return {'success': false, 'message': e.toString()};
    }
  }

  Future<void> sendTestNotification() async {
    if (!_initialized) {
      print('❌ Firebase no está inicializado');
      return;
    }

    try {
      final apiClient = ApiClient();
      await apiClient.post('/notifications/test', {});
      print('✅ Test notification enviada');
    } catch (e) {
      print('❌ Error enviando test: $e');
    }
  }
}
