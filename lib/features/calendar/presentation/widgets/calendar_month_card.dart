import 'package:flutter/material.dart';

import '../../../../core/data/hijri_date.dart';
import '../../../../core/data/models.dart';
import '../../../../core/l10n/app_copy.dart';
import '../../../../core/l10n/app_language.dart';
import '../../../../core/state/app_scope.dart';
import '../../../../core/state/app_state.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/common_widgets.dart';
import '../../../../core/widgets/decorative_patterns.dart';

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

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: const LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: <Color>[
            AppColors.accentGreen,
            AppColors.primary,
            AppColors.darkGreen,
          ],
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.22),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: Stack(
          children: <Widget>[
            const Positioned.fill(child: DotGridPattern()),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 14),
              child: Column(
                children: <Widget>[
                  const _CalendarModeSwitch(),
                  const SizedBox(height: 14),
                  _MonthNavigator(month: month, hijriMonth: hijriMonth),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    child: Divider(
                      height: 1,
                      thickness: 1,
                      color: Colors.white.withValues(alpha: 0.14),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const _WeekdayHeader(),
                  const SizedBox(height: 4),
                  for (int week = 0; week < cells ~/ 7; week++)
                    Row(
                      children: <Widget>[
                        for (int day = 0; day < 7; day++)
                          Expanded(
                            child: _DayCell(
                              date: gridStart.add(
                                Duration(days: week * 7 + day),
                              ),
                              month: month,
                            ),
                          ),
                      ],
                    ),
                ],
              ),
            ),
          ],
        ),
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
        color: Colors.white.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withValues(alpha: 0.14)),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: _SwitchSegment(
              label: context.l10n.hijri,
              selected: state.hijriView,
              onTap: () => state.setHijriView(true),
            ),
          ),
          Expanded(
            child: _SwitchSegment(
              label: context.l10n.gregorian,
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
          color: selected
              ? Colors.white.withValues(alpha: 0.18)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(11),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13.5,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
            color: selected
                ? Colors.white
                : Colors.white.withValues(alpha: 0.72),
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
    final AppState state = AppScope.of(context);
    final AppCopy copy = AppCopy(context.l10n);

    return Row(
      children: <Widget>[
        _NavButton(
          icon: Icons.arrow_back,
          tooltip: context.l10n.previousMonth,
          onPressed: () => state.hijriView
              ? state.shiftHijriMonth(-1)
              : state.shiftMonth(-1),
        ),
        Expanded(
          child: Column(
            children: <Widget>[
              Text(
                state.hijriView
                    ? copy.hijriMonthYear(hijriMonth)
                    : copy.gregorianMonthYear(month),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  height: 1.3,
                ),
              ),
              Text(
                state.hijriView
                    ? copy.gregorianMonthYear(month)
                    : copy.hijriMonthYear(hijriMonth),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.white.withValues(alpha: 0.72),
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
        _NavButton(
          icon: Icons.arrow_forward,
          tooltip: context.l10n.nextMonth,
          onPressed: () => state.hijriView
              ? state.shiftHijriMonth(1)
              : state.shiftMonth(1),
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
        color: Colors.white.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(13),
        child: InkWell(
          borderRadius: BorderRadius.circular(13),
          onTap: onPressed,
          splashColor: Colors.white.withValues(alpha: 0.12),
          highlightColor: Colors.white.withValues(alpha: 0.08),
          child: SizedBox(
            width: 42,
            height: 42,
            child: Icon(icon, size: 22, color: Colors.white),
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
    final List<String> weekdays = AppCopy(context.l10n).weekdaysSundayFirst;

    return Row(
      children: <Widget>[
        for (int i = 0; i < 7; i++)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  weekdays[i],
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: i == 5 ? FontWeight.w700 : FontWeight.w500,
                    color: i == 5
                        ? Colors.white
                        : Colors.white.withValues(alpha: 0.72),
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
    final AppCopy copy = AppCopy(context.l10n);
    final bool inMonth = date.month == month.month && date.year == month.year;
    final bool isToday =
        date.year == state.today.year &&
        date.month == state.today.month &&
        date.day == state.today.day;
    final IslamicEvent? event = state.eventOn(date);
    final bool isSelected = date == state.selectedDate && !isToday;
    final HijriDate hijri = HijriDate.fromGregorian(date);

    final bool national = event?.kind == EventKind.national;
    final Color accent = national ? AppColors.gold : AppColors.lightMint;

    Color numberColor;
    if (isToday) {
      numberColor = AppColors.primary;
    } else if (!inMonth) {
      numberColor = Colors.white.withValues(alpha: 0.38);
    } else if (event != null) {
      numberColor = national ? AppColors.gold : Colors.white;
    } else {
      numberColor = Colors.white;
    }

    BoxDecoration? decoration;
    if (isToday) {
      decoration = const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      );
    } else if (event != null) {
      decoration = BoxDecoration(
        color: Colors.white.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(13),
        border: Border.all(
          color: national
              ? AppColors.gold.withValues(alpha: 0.7)
              : Colors.white.withValues(alpha: 0.22),
        ),
      );
    } else if (isSelected) {
      decoration = BoxDecoration(
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: Colors.white.withValues(alpha: 0.35)),
      );
    }

    return Semantics(
      selected: date == state.selectedDate,
      button: true,
      label: '${copy.weekdayDate(date)} — ${copy.hijriDate(hijri)}',
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
                    '${state.hijriView ? hijri.day : date.day}',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: numberColor,
                      height: 1.15,
                    ),
                  ),
                  Text(
                    '${state.hijriView ? date.day : hijri.day}',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w400,
                      color: isToday
                          ? AppColors.primary.withValues(alpha: 0.72)
                          : Colors.white.withValues(
                              alpha: inMonth ? 0.62 : 0.32,
                            ),
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
