import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../features/calendar/presentation/calendar_screen.dart';
import '../../features/home/presentation/home_screen.dart';
import '../../features/settings/presentation/settings_screen.dart';
import '../../features/weather/presentation/weather_screen.dart';
import '../theme/app_colors.dart';
import '../widgets/custom_bottom_navigation.dart';
import 'app_routes.dart';

/// Hosts the four bottom-navigation destinations in a single [IndexedStack]
/// so switching tabs never pushes a new route.
class MainShell extends StatefulWidget {
  const MainShell({super.key});

  static final GlobalKey<MainShellState> shellKey =
      GlobalKey<MainShellState>(debugLabel: 'main-shell');

  /// Pops back to the shell (if a detail screen is open) and selects [index].
  static void goToTab(BuildContext context, int index) {
    Navigator.of(
      context,
    ).popUntil((Route<dynamic> route) => route.settings.name == AppRoutes.shell);
    shellKey.currentState?.selectTab(index);
  }

  @override
  State<MainShell> createState() => MainShellState();
}

class MainShellState extends State<MainShell> {
  int _index = 0;

  void selectTab(int index) {
    if (_index == index || !mounted) return;
    setState(() => _index = index);
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: AppColors.surface,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: IndexedStack(
          index: _index,
          children: const <Widget>[
            HomeScreen(),
            WeatherScreen(),
            CalendarScreen(),
            SettingsScreen(),
          ],
        ),
        bottomNavigationBar: CustomBottomNavigation(
          currentIndex: _index,
          onTap: selectTab,
        ),
      ),
    );
  }
}
