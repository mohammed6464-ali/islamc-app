import 'package:flutter/material.dart';

import '../../features/events/presentation/event_details_screen.dart';
import '../../features/location/presentation/current_location_screen.dart';
import '../../features/notifications/presentation/notifications_screen.dart';
import '../../features/onboarding/presentation/location_permission_screen.dart';
import '../../features/prayer_times/presentation/prayer_times_screen.dart';
import '../../features/qibla/presentation/qibla_screen.dart';
import '../../features/settings/presentation/prayer_notifications_screen.dart';
import '../../features/splash/presentation/splash_screen.dart';
import 'main_shell.dart';

class AppRoutes {
  const AppRoutes._();

  static const String splash = '/';
  static const String locationPermission = '/location-permission';
  static const String shell = '/shell';
  static const String prayerTimes = '/prayer-times';
  static const String qibla = '/qibla';
  static const String currentLocation = '/current-location';
  static const String notifications = '/notifications';
  static const String prayerNotifications = '/prayer-notifications';
  static const String eventDetails = '/event-details';

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    return switch (settings.name) {
      splash => _build(settings, const SplashScreen()),
      locationPermission => _build(settings, const LocationPermissionScreen()),
      shell => _build(settings, MainShell(key: MainShell.shellKey)),
      prayerTimes => _build(settings, const PrayerTimesScreen()),
      qibla => _build(settings, const QiblaScreen()),
      currentLocation => _build(settings, const CurrentLocationScreen()),
      notifications => _build(settings, const NotificationsScreen()),
      prayerNotifications => _build(
        settings,
        const PrayerNotificationsScreen(),
      ),
      eventDetails => _build(
        settings,
        EventDetailsScreen(eventId: settings.arguments! as String),
      ),
      _ => null,
    };
  }

  static Route<dynamic> _build(RouteSettings settings, Widget page) =>
      fadeSlideRoute(page, settings: settings);
}

/// Fade + subtle slide, matching the splash → permission transition already
/// used by the app.
PageRouteBuilder<T> fadeSlideRoute<T>(Widget page, {RouteSettings? settings}) {
  return PageRouteBuilder<T>(
    settings: settings,
    transitionDuration: const Duration(milliseconds: 350),
    reverseTransitionDuration: const Duration(milliseconds: 260),
    pageBuilder: (_, _, _) => page,
    transitionsBuilder:
        (
          BuildContext context,
          Animation<double> animation,
          Animation<double> secondary,
          Widget child,
        ) {
          final CurvedAnimation curved = CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutCubic,
            reverseCurve: Curves.easeInCubic,
          );
          return FadeTransition(
            opacity: curved,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 0.02),
                end: Offset.zero,
              ).animate(curved),
              child: child,
            ),
          );
        },
  );
}
