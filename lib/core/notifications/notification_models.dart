enum AppNotificationKind { prayer, event, test, system }

class NotificationPayload {
  const NotificationPayload({
    required this.kind,
    this.prayerId,
    this.eventId,
  });

  final AppNotificationKind kind;
  final String? prayerId;
  final String? eventId;

  Map<String, String> toMap() {
    return <String, String>{
      'kind': kind.name,
      'prayerId': ?prayerId,
      'eventId': ?eventId,
    };
  }

  static NotificationPayload fromMap(Map<String, String> map) {
    return NotificationPayload(
      kind: AppNotificationKind.values.firstWhere(
        (AppNotificationKind value) => value.name == map['kind'],
        orElse: () => AppNotificationKind.system,
      ),
      prayerId: map['prayerId'],
      eventId: map['eventId'],
    );
  }

  static NotificationPayload? tryParse(String? raw) {
    if (raw == null || raw.isEmpty) {
      return null;
    }
    final Map<String, String> map = <String, String>{};
    for (final String part in raw.split('|')) {
      final int split = part.indexOf('=');
      if (split <= 0) {
        continue;
      }
      map[part.substring(0, split)] = part.substring(split + 1);
    }
    if (map.isEmpty) {
      return null;
    }
    return fromMap(map);
  }

  String encode() =>
      toMap().entries.map((MapEntry<String, String> e) => '${e.key}=${e.value}').join('|');
}

class ScheduledNotification {
  const ScheduledNotification({
    required this.id,
    required this.fireAt,
    required this.title,
    required this.body,
    required this.payload,
  });

  final int id;
  final DateTime fireAt;
  final String title;
  final String body;
  final NotificationPayload payload;
}

class NotificationIds {
  const NotificationIds._();

  static const int prayerBase = 10000;
  static const int eventBase = 30000;
  static const int testRangeStart = 90000;
  static const int test = 90001;
  static const int test60s = 90002;

  static const Map<String, int> prayerSlots = <String, int>{
    'fajr': 0,
    'sunrise': 1,
    'dhuhr': 2,
    'asr': 3,
    'maghrib': 4,
    'isha': 5,
  };

  static int prayer({
    required int dayIndex,
    required String prayerId,
    required bool reminder,
  }) {
    final int slot = prayerSlots[prayerId] ?? 9;
    return prayerBase + dayIndex * 20 + slot * 2 + (reminder ? 1 : 0);
  }

  static int event(String eventId) =>
      eventBase + (eventId.hashCode.abs() % 9000);

  static bool isPrayer(int id) => id >= prayerBase && id < eventBase;
  static bool isEvent(int id) => id >= eventBase && id < testRangeStart;
  static bool isTest(int id) => id >= testRangeStart;
}

class NotificationDiagnostics {
  const NotificationDiagnostics({
    required this.notificationsAllowed,
    required this.exactAlarmsAllowed,
    required this.usedInexactFallback,
    required this.channelId,
    required this.preAlertMinutes,
    required this.mosqueId,
    required this.deviceTimeIso,
    required this.timezoneId,
    required this.nextPrayerId,
    required this.nextPrayerAtIso,
    required this.nextScheduledAtIso,
    required this.pendingCount,
    required this.pendingIds,
    this.scheduleError,
  });

  final bool notificationsAllowed;
  final bool exactAlarmsAllowed;
  final bool usedInexactFallback;
  final String channelId;
  final int preAlertMinutes;
  final String mosqueId;
  final String deviceTimeIso;
  final String timezoneId;
  final String nextPrayerId;
  final String? nextPrayerAtIso;
  final String? nextScheduledAtIso;
  final int pendingCount;
  final List<int> pendingIds;
  final String? scheduleError;
}
