import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:workmanager/workmanager.dart';
import 'quote_service.dart';

const String notificationChannelId = 'matrix_motivation_channel';
const String notificationChannelName = 'Matrix Motivatsiya';
const String notificationChannelDesc = 'Motivatsion va Matrix uslubidagi xabarlar';
const String workmanagerTaskName = 'matrix_motivation_task';
const String notificationPayload = 'matrix_motivation';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    await NotificationService._showRandomNotification();
    return Future.value(true);
  });
}

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  static const AndroidInitializationSettings _androidSettings =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  final DarwinInitializationSettings _iosSettings =
      DarwinInitializationSettings(
    requestAlertPermission: true,
    requestBadgePermission: true,
    requestSoundPermission: true,
  );

  Future<void> initialize() async {
    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const darwinSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: darwinSettings,
      macOS: darwinSettings,
    );

    await _notifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (response) async {},
    );

    await Workmanager().initialize(callbackDispatcher, isInDebugMode: false);
  }

  Future<void> requestPermissions() async {
    final android = _notifications.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    if (android != null) {
      await android.requestNotificationsPermission();
    }

    final ios = _notifications.resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>();
    if (ios != null) {
      await ios.requestPermissions(alert: true, badge: true, sound: true);
    }
  }

  Future<void> showNotification({String? customMessage}) async {
    final message = customMessage ?? QuoteService().getRandomMessage();
    await _showNotificationWithMessage(message);
  }

  Future<void> _showNotificationWithMessage(String message) async {
    const androidDetails = AndroidNotificationDetails(
      notificationChannelId,
      notificationChannelName,
      channelDescription: notificationChannelDesc,
      importance: Importance.max,
      priority: Priority.max,
      showWhen: true,
      enableVibration: true,
      playSound: true,
      fullScreenIntent: true,
      visibility: NotificationVisibility.public,
      showOnLockScreen: true,
      category: AndroidNotificationCategory.alarm,
      actions: <AndroidNotificationAction>[],
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
      macOS: iosDetails,
    );

    final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    await _notifications.show(
      id,
      'MATRIX',
      message,
      details,
      payload: notificationPayload,
    );
  }

  static Future<void> _showRandomNotification() async {
    final service = NotificationService();
    final message = QuoteService().getRandomMessage();
    await service._showNotificationWithMessage(message);
  }

  Future<void> schedulePeriodicNotifications() async {
    await Workmanager().registerPeriodicTask(
      'matrix_motivation',
      workmanagerTaskName,
      frequency: const Duration(hours: 1),
      constraints: Constraints(
        networkType: NetworkType.not_required,
      ),
      existingWorkPolicy: ExistingWorkPolicy.replace,
      backoffPolicy: BackoffPolicy.linear,
      initialDelay: const Duration(minutes: 1),
    );
  }

  Future<void> cancelAll() async {
    await Workmanager().cancelAll();
    await _notifications.cancelAll();
  }
}
