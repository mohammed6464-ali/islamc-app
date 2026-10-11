import 'package:flutter/material.dart';

import '../../../../core/data/demo_data.dart';
import '../../../../core/data/hijri_date.dart';
import '../../../../core/data/models.dart';
import '../../../../core/state/app_scope.dart';
import '../../../../core/state/app_state.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/common_widgets.dart';

/// Month grid showing the Gregorian day with its Hijri counterpart beneath.
class CalendarMonthCard extends StatelessWidget {
  const CalendarMonthCard({super.key});

  @override
  Widget build(BuildContext context) {
    final AppState state = AppScope.of(context);
    final DateTime month = state.visibleMonth;
    final HijriDate hijriMonth = HijriDate.fromGregorian(
      DateTime(month.year, month.month, 15),
    );

    // The grid always starts on the Sunday on or before the 1st.
    final DateTime first = DateTime(month.year, month.month);
    final DateTime gridStart = first.subtract(
      Duration(days: first.weekday % 7),
    );
    final int lastDay = DateTime(month.year, month.month + 1, 0).day;
    final int cells =
        ((first.weekday % 7) + lastDay + 6) ~/ 7 * 7;

    return AppCard(
      radius: 18,
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 14),
      child: Column(
        children: <Widget>[
          const _CalendarModeSwitch(),
          const SizedBox(height: 14),
          _MonthNavigator(month: month, hijriMonth: hijriMonth),
          const SizedBox(height: 12),
          const CardDivider(indent: 2),
          const SizedBox(height: 8),
          const _WeekdayHeader(),
          const SizedBox(height: 4),
          for (int week = 0; week < cells ~/ 7; week++)
            Row(
              children: <Widget>[
                for (int day = 0; day < 7; day++)
                  Expanded(
                    child: _DayCell(
                      date: gridStart.add(Duration(days: week * 7 + day)),
                      month: month,
                    ),
                  ),
              ],
            ),
        ],
      ),
    );
  }
}

class _CalendarModeSwitch extends StatelessWidget {
  const _CalendarModeSwitch();

  @override
  Widget build(BuildContext context) {
    final AppState state = AppScope.of(context);

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.pillGray,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: _SwitchSegment(
              label: 'هجري',
              selected: state.hijriView,
              onTap: () => state.setHijriView(true),
            ),
          ),
          Expanded(
            child: _SwitchSegment(
              label: 'ميلادي',
              selected: !state.hijriView,
              onTap: () => state.setHijriView(false),
            ),
          ),
        ],
      ),
    );
  }
}

class _SwitchSegment extends StatelessWidget {
  const _SwitchSegment({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        height: 38,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? AppColors.surface : Colors.transparent,
          borderRadius: BorderRadius.circular(11),
          boxShadow: selected
              ? <BoxShadow>[
                  BoxShadow(
                    color: AppColors.textPrimary.withValues(alpha: 0.05),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13.5,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
            color: selected ? AppColors.primary : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}

class _MonthNavigator extends StatelessWidget {
  const _MonthNavigator({required this.month, required this.hijriMonth});

  final DateTime month;
  final HijriDate hijriMonth;

  @override
  Widget build(BuildContext context) {
    final AppState state = AppScope.read(context);

    return Row(
      children: <Widget>[
        _NavButton(
          icon: Icons.chevron_left,
          tooltip: 'الشهر السابق',
          onPressed: () => state.shiftMonth(-1),
        ),
        Expanded(
          child: Column(
            children: <Widget>[
              Text(
                '${GregorianLabels.monthName(month)} ${month.year}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                  height: 1.3,
                ),
              ),
              Text(
                hijriMonth.monthFormatted,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.goldDeep,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
        _NavButton(
          icon: Icons.chevron_right,
          tooltip: 'الشهر التالي',
          onPressed: () => state.shiftMonth(1),
        ),
      ],
    );
  }
}

class _NavButton extends StatelessWidget {
  const _NavButton({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: AppColors.pillGray,
        borderRadius: BorderRadius.circular(13),
        child: InkWell(
          borderRadius: BorderRadius.circular(13),
          onTap: onPressed,
          child: SizedBox(
            width: 42,
            height: 42,
            child: Icon(icon, size: 22, color: AppColors.textPrimary),
          ),
        ),
      ),
    );
  }
}

class _WeekdayHeader extends StatelessWidget {
  const _WeekdayHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        for (int i = 0; i < 7; i++)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  GregorianLabels.weekdays[i],
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: i == 5 ? FontWeight.w700 : FontWeight.w500,
                    color: i == 5
                        ? AppColors.primary
                        : AppColors.textSecondary,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _DayCell extends StatelessWidget {
  const _DayCell({required this.date, required this.month});

  final DateTime date;
  final DateTime month;

  @override
  Widget build(BuildContext context) {
    final AppState state = AppScope.of(context);
    final bool inMonth = date.month == month.month && date.year == month.year;
    final bool isToday = date == DemoData.today;
    final bool isFriday = date.weekday == DateTime.friday;
    final IslamicEvent? event = DemoData.eventOn(date);
    final bool isSelected = date == state.selectedDate && !isToday;
    final HijriDate hijri = HijriDate.fromGregorian(date);

    final bool national = event?.kind == EventKind.national;
    final Color accent = national ? AppColors.goldDeep : AppColors.primary;

    Color numberColor;
    if (isToday) {
      numberColor = AppColors.surface;
    } else if (!inMonth) {
      numberColor = AppColors.textMuted;
    } else if (event != null) {
      numberColor = accent;
    } else if (isFriday) {
      numberColor = AppColors.primary;
    } else {
      numberColor = AppColors.textPrimary;
    }

    BoxDecoration? decoration;
    if (isToday) {
      decoration = const BoxDecoration(
        color: AppColors.primary,
        shape: BoxShape.circle,
      );
    } else if (event != null) {
      decoration = BoxDecoration(
        color: national ? AppColors.amberBg : AppColors.mintSoft,
        borderRadius: BorderRadius.circular(13),
        border: Border.all(
          color: national ? AppColors.amberPill : AppColors.mintBorder,
        ),
      );
    } else if (isSelected) {
      decoration = BoxDecoration(
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: AppColors.mintBorder),
      );
    }

    return Semantics(
      selected: date == state.selectedDate,
      button: true,
      label: '${GregorianLabels.withWeekday(date)} — ${hijri.formatted}',
      child: InkWell(
        borderRadius: BorderRadius.circular(13),
        onTap: () {
          state.selectDate(date);
          if (!inMonth) state.showMonth(date);
        },
        child: Padding(
          padding: const EdgeInsets.all(2),
          child: AspectRatio(
            aspectRatio: 0.92,
            child: DecoratedBox(
              decoration: decoration ?? const BoxDecoration(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    '${date.day}',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: numberColor,
                      height: 1.15,
                    ),
                  ),
                  Text(
                    '${hijri.day}',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w400,
                      color: isToday
                          ? AppColors.surface.withValues(alpha: 0.85)
                          : (inMonth
                                ? AppColors.textSecondary
                                : AppColors.textMuted),
                      height: 1.2,
                    ),
                  ),
                  if (event != null && !isToday) ...<Widget>[
                    const SizedBox(height: 2),
                    Dot(size: 4, color: accent),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
