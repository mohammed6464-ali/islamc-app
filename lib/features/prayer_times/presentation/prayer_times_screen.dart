import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/data/models.dart';
import '../../../core/l10n/app_copy.dart';
import '../../../core/l10n/app_language.dart';
import '../../../core/navigation/app_routes.dart';
import '../../../core/navigation/main_shell.dart';
import '../../../core/state/app_scope.dart';
import '../../../core/state/app_state.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_feedback.dart';
import '../../../core/widgets/app_screen_header.dart';
import '../../../core/widgets/common_widgets.dart';
import 'widgets/prayer_city_card.dart';
import 'widgets/prayer_countdown_card.dart';
import 'widgets/prayer_row_card.dart';

class PrayerTimesScreen extends StatelessWidget {
  const PrayerTimesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AppState state = AppScope.of(context);
    final List<PrayerTime> prayers = state.prayerTimes;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: AppColors.background,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: SafeArea(
          bottom: false,
          child: Column(
            children: <Widget>[
              AppScreenHeader(
                leading: const HeaderBackButton(),
                title: context.l10n.prayerTimes,
                actions: <Widget>[
                  HeaderIconButton(
                    icon: Icons.calendar_today_outlined,
                    tooltip: context.l10n.calendar,
                    onPressed: () => MainShell.goToTab(context, 2),
                  ),
                  HeaderIconButton(
                    icon: Icons.share_outlined,
                    tooltip: context.l10n.shareApp,
                    onPressed: () => showAppMessage(
                      context,
                      context.l10n.shareDisabled,
                    ),
                  ),
                ],
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
                  physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics(),
                  ),
                  children: <Widget>[
                    const PrayerCityCard(),
                    const SizedBox(height: 14),
                    const PrayerCountdownCard(),
                    const SizedBox(height: 16),
                    for (final PrayerTime prayer in prayers) ...<Widget>[
                      PrayerRowCard(prayer: prayer),
                      const SizedBox(height: 10),
                    ],
                    const SizedBox(height: 6),
                    const _QiblaStrip(),
                  ],
                ),
              ),
              const Divider(height: 1, thickness: 1, color: AppColors.divider),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
                child: PrimaryButton(
                  label: context.l10n.prayerNotificationSettings,
                  icon: Icons.notifications_none_rounded,
                  onPressed: () => Navigator.of(
                    context,
                  ).pushNamed(AppRoutes.prayerNotifications),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// `اتجاه القبلة: 244° جنوب غرب` ........ `تقويم أم القرى`
class _QiblaStrip extends StatelessWidget {
  const _QiblaStrip();

  @override
  Widget build(BuildContext context) {
    final AppState state = AppScope.of(context);
    final AppCopy copy = AppCopy(context.l10n);

    return Material(
      color: AppColors.pillGray,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () => Navigator.of(context).pushNamed(AppRoutes.qibla),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
          child: Row(
            children: <Widget>[
              const Icon(
                Icons.explore_outlined,
                size: 17,
                color: AppColors.primary,
              ),
              const SizedBox(width: 9),
              Expanded(
                child: Text(
                  '${context.l10n.qiblaDirection}: ${copy.qiblaLabel(
                    state.city.qiblaAngle.toDouble(),
                    atKaaba: state.city.distanceToMakkah < 2,
                  )}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                copy.calcMethod(state.calculationMethodEnum),
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textMuted,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
