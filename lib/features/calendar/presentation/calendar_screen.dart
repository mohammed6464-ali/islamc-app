import 'package:flutter/material.dart';

import '../../../core/data/demo_data.dart';
import '../../../core/data/hijri_date.dart';
import '../../../core/data/models.dart';
import '../../../core/navigation/app_routes.dart';
import '../../../core/state/app_scope.dart';
import '../../../core/state/app_state.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_screen_header.dart';
import '../../../core/widgets/common_widgets.dart';
import 'widgets/calendar_month_card.dart';
import 'widgets/event_list_card.dart';

class CalendarScreen extends StatelessWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AppState state = AppScope.of(context);

    return Column(
      children: <Widget>[
        SafeArea(
          bottom: false,
          child: AppScreenHeader(
            leading: _CityLeading(city: state.city.fullName),
            title: 'التقويم',
            actions: <Widget>[
              HeaderIconButton(
                icon: Icons.explore_outlined,
                tooltip: 'اتجاه القبلة',
                onPressed: () =>
                    Navigator.of(context).pushNamed(AppRoutes.qibla),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 20),
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            children: <Widget>[
              const CalendarMonthCard(),
              const SizedBox(height: 16),
              const _SelectedDayCard(),
              const SizedBox(height: 20),
              SectionTitle(
                title: 'المناسبات القادمة',
                titleColor: AppColors.primary,
                trailing: _eventsRange(),
              ),
              const SizedBox(height: 12),
              for (final IslamicEvent event in DemoData.events) ...<Widget>[
                EventListCard(event: event),
                const SizedBox(height: 12),
              ],
            ],
          ),
        ),
      ],
    );
  }

  static String _eventsRange() {
    final List<HijriDate> dates =
        DemoData.events
            .map((IslamicEvent e) => HijriDate.fromGregorian(e.date))
            .toList()
          ..sort(
            (HijriDate a, HijriDate b) =>
                (a.year * 12 + a.month).compareTo(b.year * 12 + b.month),
          );
    final Set<String> names = <String>{
      for (final HijriDate d in dates) d.monthName,
    };
    return '${names.join(' - ')} ${dates.last.year}';
  }
}

class _CityLeading extends StatelessWidget {
  const _CityLeading({required this.city});

  final String city;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        HeaderIconButton(
          icon: Icons.location_on_outlined,
          tooltip: 'تغيير المدينة',
          onPressed: () =>
              Navigator.of(context).pushNamed(AppRoutes.currentLocation),
        ),
        const SizedBox(width: 2),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 170),
          child: Text(
            city,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w400,
              color: AppColors.textSecondary,
            ),
          ),
        ),
      ],
    );
  }
}

/// Summary of the day currently selected in the grid.
class _SelectedDayCard extends StatelessWidget {
  const _SelectedDayCard();

  @override
  Widget build(BuildContext context) {
    final AppState state = AppScope.of(context);
    final DateTime date = state.selectedDate;
    final bool isToday = date == DemoData.today;
    final HijriDate hijri = HijriDate.fromGregorian(date);
    final PrayerTime next = state.nextPrayer;

    return AppCard(
      radius: 18,
      padding: const EdgeInsets.all(14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const IconTile.mint(Icons.event_note_outlined, size: 48, iconSize: 23),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                AppBadge(
                  isToday ? 'اليوم الحالي' : 'يوم محدد',
                  background: AppColors.mintStrong,
                ),
                const SizedBox(height: 7),
                Text(
                  '${GregorianLabels.weekdayName(date)} ${hijri.formatted} — '
                  '${GregorianLabels.formatted(date)}',
                  style: const TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${state.city.name} • ${DemoData.timezoneName} • '
                  '${next.longName} القادمة في ${next.timeWithPeriod}',
                  style: const TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textSecondary,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
