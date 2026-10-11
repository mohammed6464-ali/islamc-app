import 'package:flutter/material.dart';

import '../../../core/data/demo_data.dart';
import '../../../core/navigation/app_routes.dart';
import '../../../core/state/app_scope.dart';
import '../../../core/theme/app_colors.dart';
import 'widgets/date_weather_card.dart';
import 'widgets/home_header.dart';
import 'widgets/info_cards.dart';
import 'widgets/next_prayer_card.dart';
import 'widgets/prayer_times_card.dart';
import 'widgets/quick_actions.dart';
import 'widgets/upcoming_event_card.dart';

/// First destination of [MainShell]; the bottom bar lives in the shell.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const SafeArea(bottom: false, child: HomeTopBar()),
        const Divider(height: 1, thickness: 1, color: AppColors.divider),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            children: const <Widget>[
              HomeGreeting(),
              SizedBox(height: 18),
              DateWeatherCard(),
              SizedBox(height: 16),
              NextPrayerCard(),
              SizedBox(height: 19),
              QuickActionsRow(),
              SizedBox(height: 26),
              _SectionHeader(),
              SizedBox(height: 14),
              PrayerTimesCard(),
              SizedBox(height: 18),
              UpcomingEventCard(),
              SizedBox(height: 22),
              InfoCardsRow(),
            ],
          ),
        ),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        GestureDetector(
          onTap: () => Navigator.of(context).pushNamed(AppRoutes.prayerTimes),
          child: const Text(
            DemoData.prayerTimesHeader,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
              height: 1.3,
            ),
          ),
        ),
        const Spacer(),
        Flexible(
          child: Text(
            AppScope.of(context).prayerSourceLabel,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.end,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: AppColors.accentGreen,
            ),
          ),
        ),
      ],
    );
  }
}
