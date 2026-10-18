import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/timezone.dart' as tz;

import '../time/app_timezone.dart';
import 'notification_models.dart';

typedef NotificationTapCallback = void Function(NotificationPayload payload);

/// Debug builds always show it. Release can opt in with
/// `--dart-define=NOTIFICATION_DIAGNOSTICS=true`.
const bool kShowNotificationDiagnostics =
    bool.fromEnvironment('NOTIFICATION_DIAGNOSTICS') || kDebugMode;

abstract class NotificationGateway {
  Future<void> initialize({NotificationTapCallback? onTap});

  Future<bool> requestPermission({bool requestExactAlarms = true});

  Future<bool> notificationsAllowed();

  Future<bool> exactAlarmsAllowed();

  Future<void> openSystemSettings();

  String get channelId;

  bool get lastScheduleUsedInexact;

  String? get lastScheduleError;

  Future<void> schedule(ScheduledNotification notification);

  Future<void> cancel(int id);

  Future<void> cancelAll();

  Future<List<int>> pendingIds();

  NotificationPayload? consumeLaunchPayload();
}

class FlutterNotificationGateway implements NotificationGateway {
  FlutterNotificationGateway({FlutterLocalNotificationsPlugin? plugin})
    : _plugin = plugin ?? FlutterLocalNotificationsPlugin();

  /// v2 migrates the Android 8+ channel so sound/importance can be set
  /// correctly. v1 cannot be mutated after first creation.
  static const String channelIdValue = 'prayer_adhan_v2';
  static const String channelName = 'تنبيهات الصلاة';
  static const String notificationIcon = 'ic_stat_notify';

  final FlutterLocalNotificationsPlugin _plugin;
  NotificationTapCallback? _onTap;
  NotificationPayload? _launchPayload;
  bool _initialized = false;
  bool _lastScheduleUsedInexact = false;
  String? _lastScheduleError;

  @override
  String get channelId => channelIdValue;

  @override
  bool get lastScheduleUsedInexact => _lastScheduleUsedInexact;

  @override
  String? get lastScheduleError => _lastScheduleError;

  @override
  Future<void> initialize({NotificationTapCallback? onTap}) async {
    _onTap = onTap;
    AppTimezone.ensureInitialized();
    const AndroidInitializationSettings android = AndroidInitializationSettings(
      notificationIcon,
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
    await _ensureAndroidChannel();
  }

  Future<void> _ensureAndroidChannel() async {
    final AndroidFlutterLocalNotificationsPlugin? android = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    if (android == null) {
      return;
    }
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      channelIdValue,
      channelName,
      description: 'أذان وإشعارات أوقات الصلاة',
      importance: Importance.max,
      playSound: true,
      sound: RawResourceAndroidNotificationSound('adhan_notify'),
      enableVibration: true,
      audioAttributesUsage: AudioAttributesUsage.alarm,
    );
    await android.createNotificationChannel(channel);
  }

  @override
  Future<bool> requestPermission({bool requestExactAlarms = true}) async {
    await _ensureInitialized();
    final AndroidFlutterLocalNotificationsPlugin? android = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    final bool androidOk =
        await android?.requestNotificationsPermission() ?? true;
    if (requestExactAlarms &&
        await android?.canScheduleExactNotifications() == false) {
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
    if (!await notificationsAllowed()) {
      _lastScheduleError = 'notifications-disabled';
      return;
    }
    final tz.TZDateTime when = tz.TZDateTime.from(
      notification.fireAt.toUtc(),
      tz.UTC,
    );
    if (!when.isAfter(tz.TZDateTime.now(tz.UTC))) {
      return;
    }
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      channelIdValue,
      channelName,
      channelDescription: 'أذان وإشعارات أوقات الصلاة',
      icon: notificationIcon,
      importance: Importance.max,
      priority: Priority.max,
      category: AndroidNotificationCategory.alarm,
      visibility: NotificationVisibility.public,
      sound: RawResourceAndroidNotificationSound('adhan_notify'),
      playSound: true,
      enableVibration: true,
      audioAttributesUsage: AudioAttributesUsage.alarm,
    );
    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentSound: true,
        presentBadge: true,
        sound: 'adhan_notify.wav',
      ),
    );
    final String payload = notification.payload.encode();
    final bool exact = await exactAlarmsAllowed();
    _lastScheduleUsedInexact = !exact;
    _lastScheduleError = null;
    try {
      await _plugin.zonedSchedule(
        notification.id,
        notification.title,
        notification.body,
        when,
        details,
        androidScheduleMode: exact
            ? AndroidScheduleMode.exactAllowWhileIdle
            : AndroidScheduleMode.inexactAllowWhileIdle,
        payload: payload,
      );
    } catch (error, stack) {
      debugPrint('prayer notification exact schedule failed: $error');
      debugPrint('$stack');
      try {
        await _plugin.zonedSchedule(
          notification.id,
          notification.title,
          notification.body,
          when,
          details,
          androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
          payload: payload,
        );
        _lastScheduleUsedInexact = true;
        _lastScheduleError = error.toString();
      } catch (fallbackError) {
        _lastScheduleError = fallbackError.toString();
        debugPrint(
          'prayer notification inexact schedule failed: $fallbackError',
        );
        rethrow;
      }
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
  bool lastScheduleUsedInexactValue = false;
  String? lastScheduleErrorValue;
  final Map<int, ScheduledNotification> scheduled =
      <int, ScheduledNotification>{};
  NotificationTapCallback? onTap;
  NotificationPayload? launchPayload;

  @override
  String get channelId => FlutterNotificationGateway.channelIdValue;

  @override
  bool get lastScheduleUsedInexact => lastScheduleUsedInexactValue;

  @override
  String? get lastScheduleError => lastScheduleErrorValue;

  @override
  Future<void> initialize({NotificationTapCallback? onTap}) async {
    this.onTap = onTap;
  }

  @override
  Future<bool> requestPermission({bool requestExactAlarms = true}) async {
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
      lastScheduleErrorValue = 'schedule failed';
      throw Exception('schedule failed');
    }
    if (!permissionGranted) {
      lastScheduleErrorValue = 'notifications-disabled';
      return;
    }
    lastScheduleUsedInexactValue = !exactAllowed;
    lastScheduleErrorValue = exactAllowed ? null : 'inexact-fallback';
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

