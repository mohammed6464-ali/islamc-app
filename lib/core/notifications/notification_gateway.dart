import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/timezone.dart' as tz;

import '../time/app_timezone.dart';
import 'notification_models.dart';

typedef NotificationTapCallback = void Function(NotificationPayload payload);

abstract class NotificationGateway {
  Future<void> initialize({NotificationTapCallback? onTap});

  Future<bool> requestPermission();

  Future<bool> notificationsAllowed();

  Future<bool> exactAlarmsAllowed();

  Future<void> openSystemSettings();

  Future<void> schedule(ScheduledNotification notification);

  Future<void> cancel(int id);

  Future<void> cancelAll();

  Future<List<int>> pendingIds();

  NotificationPayload? consumeLaunchPayload();
}

class FlutterNotificationGateway implements NotificationGateway {
  FlutterNotificationGateway({FlutterLocalNotificationsPlugin? plugin})
    : _plugin = plugin ?? FlutterLocalNotificationsPlugin();

  static const String channelId = 'prayer_adhan_v1';
  static const String channelName = 'تنبيهات الصلاة';

  final FlutterLocalNotificationsPlugin _plugin;
  NotificationTapCallback? _onTap;
  NotificationPayload? _launchPayload;
  bool _initialized = false;

  @override
  Future<void> initialize({NotificationTapCallback? onTap}) async {
    _onTap = onTap;
    AppTimezone.ensureInitialized();
    const AndroidInitializationSettings android = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const DarwinInitializationSettings ios = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    await _plugin.initialize(
      const InitializationSettings(android: android, iOS: ios),
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        final NotificationPayload? payload = NotificationPayload.tryParse(
          response.payload,
        );
        if (payload != null) {
          _onTap?.call(payload);
        }
      },
    );
    final NotificationAppLaunchDetails? launch = await _plugin
        .getNotificationAppLaunchDetails();
    if (launch?.didNotificationLaunchApp == true) {
      _launchPayload = NotificationPayload.tryParse(
        launch?.notificationResponse?.payload,
      );
    }
    _initialized = true;
  }

  @override
  Future<bool> requestPermission() async {
    await _ensureInitialized();
    final AndroidFlutterLocalNotificationsPlugin? android = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    final bool androidOk =
        await android?.requestNotificationsPermission() ?? true;
    if (await android?.canScheduleExactNotifications() == false) {
      await android?.requestExactAlarmsPermission();
    }
    final IOSFlutterLocalNotificationsPlugin? ios = _plugin
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >();
    final bool iosOk =
        await ios?.requestPermissions(alert: true, badge: true, sound: true) ??
        true;
    return androidOk && iosOk;
  }

  @override
  Future<bool> notificationsAllowed() async {
    await _ensureInitialized();
    final AndroidFlutterLocalNotificationsPlugin? android = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    return await android?.areNotificationsEnabled() ?? true;
  }

  @override
  Future<bool> exactAlarmsAllowed() async {
    await _ensureInitialized();
    final AndroidFlutterLocalNotificationsPlugin? android = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    return await android?.canScheduleExactNotifications() ?? true;
  }

  @override
  Future<void> openSystemSettings() async {
    await openAppSettings();
  }

  @override
  Future<void> schedule(ScheduledNotification notification) async {
    await _ensureInitialized();
    AppTimezone.ensureInitialized();
    final tz.TZDateTime when = tz.TZDateTime.from(
      notification.fireAt.toUtc(),
      tz.UTC,
    );
    if (!when.isAfter(tz.TZDateTime.now(tz.UTC))) {
      return;
    }
    const NotificationDetails details = NotificationDetails(
      android: AndroidNotificationDetails(
        channelId,
        channelName,
        channelDescription: 'أذان وإشعارات أوقات الصلاة',
        importance: Importance.max,
        priority: Priority.max,
        sound: RawResourceAndroidNotificationSound('adhan_notify'),
        playSound: true,
      ),
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentSound: true,
        sound: 'adhan_notify.wav',
      ),
    );
    final String payload = notification.payload.encode();
    try {
      await _plugin.zonedSchedule(
        notification.id,
        notification.title,
        notification.body,
        when,
        details,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        payload: payload,
      );
    } catch (_) {
      await _plugin.zonedSchedule(
        notification.id,
        notification.title,
        notification.body,
        when,
        details,
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        payload: payload,
      );
    }
  }

  @override
  Future<void> cancel(int id) async {
    await _ensureInitialized();
    await _plugin.cancel(id);
  }

  @override
  Future<void> cancelAll() async {
    await _ensureInitialized();
    await _plugin.cancelAll();
  }

  @override
  Future<List<int>> pendingIds() async {
    await _ensureInitialized();
    final List<PendingNotificationRequest> pending = await _plugin
        .pendingNotificationRequests();
    return pending.map((PendingNotificationRequest item) => item.id).toList();
  }

  @override
  NotificationPayload? consumeLaunchPayload() {
    final NotificationPayload? payload = _launchPayload;
    _launchPayload = null;
    return payload;
  }

  Future<void> _ensureInitialized() async {
    if (_initialized) {
      return;
    }
    await initialize();
  }
}

class FakeNotificationGateway implements NotificationGateway {
  FakeNotificationGateway({
    this.permissionGranted = true,
    this.exactAllowed = true,
    this.throwOnSchedule = false,
  });

  bool permissionGranted;
  bool exactAllowed;
  bool throwOnSchedule;
  int permissionRequests = 0;
  int settingsOpens = 0;
  final Map<int, ScheduledNotification> scheduled =
      <int, ScheduledNotification>{};
  NotificationTapCallback? onTap;
  NotificationPayload? launchPayload;

  @override
  Future<void> initialize({NotificationTapCallback? onTap}) async {
    this.onTap = onTap;
  }

  @override
  Future<bool> requestPermission() async {
    permissionRequests += 1;
    return permissionGranted;
  }

  @override
  Future<bool> notificationsAllowed() async => permissionGranted;

  @override
  Future<bool> exactAlarmsAllowed() async => exactAllowed;

  @override
  Future<void> openSystemSettings() async {
    settingsOpens += 1;
  }

  @override
  Future<void> schedule(ScheduledNotification notification) async {
    if (throwOnSchedule) {
      throw Exception('schedule failed');
    }
    if (!permissionGranted) {
      return;
    }
    scheduled[notification.id] = notification;
  }

  @override
  Future<void> cancel(int id) async {
    scheduled.remove(id);
  }

  @override
  Future<void> cancelAll() async {
    scheduled.clear();
  }

  @override
  Future<List<int>> pendingIds() async => scheduled.keys.toList();

  @override
  NotificationPayload? consumeLaunchPayload() {
    final NotificationPayload? payload = launchPayload;
    launchPayload = null;
    return payload;
  }
}

