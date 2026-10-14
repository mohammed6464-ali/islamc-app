import 'package:flutter/material.dart';

import '../../../core/data/hijri_date.dart';
import '../../../core/data/models.dart';
import '../../../core/l10n/app_copy.dart';
import '../../../core/l10n/app_language.dart';
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
    final AppCopy copy = AppCopy(context.l10n);

    return Column(
      children: <Widget>[
        SafeArea(
          bottom: false,
          child: AppScreenHeader(
            leading: _CityLeading(city: copy.cityFullName(state.city)),
            title: context.l10n.calendar,
            actions: <Widget>[
              HeaderIconButton(
                icon: Icons.explore_outlined,
                tooltip: context.l10n.qiblaDirection,
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
                title: context.l10n.upcomingEvents,
                titleColor: AppColors.primary,
                trailing: state.upcomingEvents.isEmpty
                    ? ''
                    : _eventsRange(state, copy),
              ),
              const SizedBox(height: 12),
              for (final IslamicEvent event in state.upcomingEvents) ...<Widget>[
                EventListCard(event: event),
                const SizedBox(height: 12),
              ],
            ],
          ),
        ),
      ],
    );
  }

  String _eventsRange(AppState state, AppCopy copy) {
    final List<HijriDate> dates =
        state.upcomingEvents
            .map((IslamicEvent e) => HijriDate.fromGregorian(e.date))
            .toList()
          ..sort(
            (HijriDate a, HijriDate b) =>
                (a.year * 12 + a.month).compareTo(b.year * 12 + b.month),
          );
    if (dates.isEmpty) {
      return '';
    }
    final Set<String> names = <String>{
      for (final HijriDate d in dates) copy.hijriMonth(d.month),
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
          tooltip: context.l10n.changeCity,
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
    final AppCopy copy = AppCopy(context.l10n);
    final DateTime date = state.selectedDate;
    final bool isToday =
        date.year == state.today.year &&
        date.month == state.today.month &&
        date.day == state.today.day;
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
                  isToday ? context.l10n.currentDay : context.l10n.selectedDay,
                  background: AppColors.mintStrong,
                ),
                const SizedBox(height: 7),
                Text(
                  '${copy.weekday(date.weekday)} ${copy.hijriDate(hijri)} — '
                  '${copy.gregorianDate(date)}',
                  style: const TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${context.l10n.prayerSource(copy.cityName(state.city))} • '
                  '${context.l10n.nextPrayerAt(copy.prayerLongName(next.id), copy.timeWithPeriod(next))}',
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
