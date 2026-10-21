import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/ads/ads_service.dart';
import 'core/location/geolocator_location_provider.dart';
import 'core/navigation/app_routes.dart';
import 'core/notifications/notification_gateway.dart';
import 'core/notifications/notification_models.dart';
import 'core/persistence/settings_store.dart';
import 'core/state/app_scope.dart';
import 'core/state/app_state.dart';
import 'core/theme/app_theme.dart';
import 'core/time/app_clock.dart';
import 'core/time/app_timezone.dart';
import 'core/weather/open_meteo_weather_repository.dart';
import 'core/weather/weather_api_service.dart';
import 'core/weather/weather_cache_service.dart';
import 'core/app_info.dart';
import 'core/data/models.dart';
import 'core/l10n/app_copy.dart';
import 'core/legal/app_legal.dart';
import 'l10n/app_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  unawaited(AdsService.initialize());
  AppTimezone.ensureInitialized();
  await AppInfo.load();
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final FlutterNotificationGateway notifications = FlutterNotificationGateway();
  final AppState state = AppState(
    clock: const SystemClock(),
    locationProvider: const GeolocatorLocationProvider(),
    store: SharedPrefsSettingsStore(prefs),
    weatherRepository: OpenMeteoWeatherRepository(
      api: WeatherApiService(),
      cache: SharedPrefsWeatherCache(prefs),
    ),
    notificationGateway: notifications,
    enableTicker: true,
  );
  await notifications.initialize(
    onTap: (NotificationPayload payload) {
      _handleNotificationTap(state, payload);
    },
  );
  await state.hydrate();
  final NotificationPayload? launch = notifications.consumeLaunchPayload();
  runApp(MawaqeetnaApp(state: state, launchPayload: launch));
}

void _handleNotificationTap(AppState state, NotificationPayload payload) {
  final AppCopy copy = AppCopy.forCode(state.languageCode);
  state.recordDeliveredNotification(
    AppNotification(
      id: '${payload.kind.name}-${payload.prayerId ?? payload.eventId ?? 'tap'}-${DateTime.now().millisecondsSinceEpoch}',
      title: payload.kind == AppNotificationKind.event
          ? copy.l10n.inboxEventTitle
          : copy.l10n.inboxPrayerTitle,
      bodyTemplate: payload.kind == AppNotificationKind.prayer
          ? copy.l10n.inboxPrayerBody(copy.cityNameFromId(
              state.location.catalogId,
              state.location.cityName,
            ))
          : copy.l10n.inboxEventBody,
      timeLabel: copy.l10n.now,
      icon: payload.kind == AppNotificationKind.event
          ? Icons.flag_outlined
          : Icons.notifications_active_outlined,
      tone: payload.kind == AppNotificationKind.event
          ? NotificationTone.amber
          : NotificationTone.mint,
      group: copy.l10n.today,
      createdAt: DateTime.now(),
      targetRoute: payload.kind == AppNotificationKind.event
          ? AppRoutes.eventDetails
          : AppRoutes.prayerTimes,
      targetId: payload.eventId,
    ),
  );
  final NavigatorState? navigator = AppNavigator.key.currentState;
  if (navigator == null) {
    return;
  }
  switch (payload.kind) {
    case AppNotificationKind.event:
      navigator.pushNamed(AppRoutes.eventDetails, arguments: payload.eventId);
    case AppNotificationKind.prayer:
    case AppNotificationKind.test:
      navigator.pushNamed(AppRoutes.prayerTimes);
    case AppNotificationKind.system:
      break;
  }
}

class MawaqeetnaApp extends StatefulWidget {
  const MawaqeetnaApp({super.key, required this.state, this.launchPayload});

  final AppState state;
  final NotificationPayload? launchPayload;

  @override
  State<MawaqeetnaApp> createState() => _MawaqeetnaAppState();
}

class _MawaqeetnaAppState extends State<MawaqeetnaApp>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    final NotificationPayload? launch = widget.launchPayload;
    if (launch != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _handleNotificationTap(widget.state, launch);
      });
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      widget.state.onAppResumed();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    widget.state.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScope(
      state: widget.state,
      child: ListenableBuilder(
        listenable: widget.state,
        builder: (BuildContext context, Widget? _) {
          return MaterialApp(
            navigatorKey: AppNavigator.key,
            title: AppLegal.appName,
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light,
            locale: widget.state.locale,
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            builder: (BuildContext context, Widget? child) {
              final MediaQueryData media = MediaQuery.of(context);
              return MediaQuery(
                data: media.copyWith(
                  textScaler: media.textScaler.clamp(
                    minScaleFactor: 0.9,
                    maxScaleFactor: 1.1,
                  ),
                ),
                child: child ?? const SizedBox.shrink(),
              );
            },
            initialRoute: AppRoutes.splash,
            onGenerateRoute: AppRoutes.onGenerateRoute,
          );
        },
      ),
    );
  }
}
