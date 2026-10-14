import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/data/hijri_date.dart';
import '../../../core/data/models.dart';
import '../../../core/events/device_calendar_service.dart';
import '../../../core/l10n/app_copy.dart';
import '../../../core/l10n/app_language.dart';
import '../../../core/state/app_scope.dart';
import '../../../core/state/app_state.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_feedback.dart';
import '../../../core/widgets/app_screen_header.dart';
import '../../../core/widgets/app_toggle.dart';
import '../../../core/widgets/common_widgets.dart';
import '../../../core/widgets/islamic_geometric_pattern.dart';

class EventDetailsScreen extends StatelessWidget {
  const EventDetailsScreen({super.key, required this.eventId});

  final String eventId;

  @override
  Widget build(BuildContext context) {
    final AppState state = AppScope.of(context);
    final AppCopy copy = AppCopy(context.l10n);
    final IslamicEvent event = state.eventById(eventId);
    final bool favorite = state.isFavoriteEvent(event.id);

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
                showDivider: false,
                leading: const HeaderBackButton(boxed: true),
                title: context.l10n.eventDetails,
                titleColor: AppColors.textPrimary,
                titleSize: 15,
                actions: <Widget>[
                  HeaderIconButton(
                    icon: Icons.share_outlined,
                    tooltip: context.l10n.shareOccasion,
                    boxed: true,
                    onPressed: () => _shareEvent(context, event),
                  ),
                ],
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 20),
                  physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics(),
                  ),
                  children: <Widget>[
                    _EventHero(event: event),
                    const SizedBox(height: 14),
                    _CountdownCard(event: event),
                    const SizedBox(height: 12),
                    _EventDateCard(event: event),
                    const SizedBox(height: 12),
                    _AboutCard(event: event),
                    const SizedBox(height: 12),
                    _QuickActionsCard(event: event),
                    const SizedBox(height: 18),
                    PrimaryButton(
                      label: favorite
                          ? context.l10n.savedInFavorites
                          : context.l10n.saveToFavorites,
                      icon: favorite
                          ? Icons.bookmark_rounded
                          : Icons.bookmark_add_outlined,
                      onPressed: () {
                        final bool added = state.toggleFavoriteEvent(event.id);
                        showAppMessage(
                          context,
                          added
                              ? context.l10n.favoriteAdded(copy.eventTitle(event))
                              : context.l10n.favoriteRemoved(
                                  copy.eventTitle(event),
                                ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EventHero extends StatelessWidget {
  const _EventHero({required this.event});

  final IslamicEvent event;

  @override
  Widget build(BuildContext context) {
    final AppCopy copy = AppCopy(context.l10n);
    final List<String> pills = copy.eventPills(event);

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: <Color>[AppColors.heroGreenStart, AppColors.heroGreenEnd],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.2),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: <Widget>[
            const PositionedDirectional(
              start: -90,
              top: -70,
              width: 260,
              height: 260,
              child: IslamicGeometricPattern(centerAlignment: Alignment.center),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 18, 18, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.gold.withValues(alpha: 0.14),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: AppColors.gold.withValues(alpha: 0.55),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        const Icon(
                          Icons.star_rounded,
                          size: 14,
                          color: AppColors.goldText,
                        ),
                        const SizedBox(width: 7),
                        Text(
                          copy.eventOwner(event),
                          style: const TextStyle(
                            fontSize: 10.5,
                            fontWeight: FontWeight.w600,
                            color: AppColors.goldText,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 22),
                  Text(
                    copy.eventTitle(event),
                    style: const TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w700,
                      color: AppColors.surface,
                      height: 1.35,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    copy.eventTagline(event),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: AppColors.surface.withValues(alpha: 0.6),
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Wrap(
                    spacing: 10,
                    runSpacing: 8,
                    children: <Widget>[
                      _HeroPill(
                        icon: Icons.verified_outlined,
                        label: pills.isEmpty ? '' : pills.first,
                      ),
                      _HeroPill(
                        icon: Icons.event_available_outlined,
                        label: pills.length < 2 ? '' : pills.last,
                        filled: true,
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

class _HeroPill extends StatelessWidget {
  const _HeroPill({
    required this.icon,
    required this.label,
    this.filled = false,
  });

  final IconData icon;
  final String label;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    final Color foreground = filled ? AppColors.amberText : AppColors.surface;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
      decoration: BoxDecoration(
        color: filled
            ? AppColors.amberIcon
            : AppColors.surface.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: filled
            ? null
            : Border.all(color: AppColors.surface.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(icon, size: 15, color: foreground),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w600,
              color: foreground,
            ),
          ),
        ],
      ),
    );
  }
}

class _CountdownCard extends StatelessWidget {
  const _CountdownCard({required this.event});

  final IslamicEvent event;

  @override
  Widget build(BuildContext context) {
    final int days = AppScope.of(context).daysUntil(event.date);
    final bool upcoming = days > 0;
    final AppCopy copy = AppCopy(context.l10n);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.mintTint,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.mintBorder),
      ),
      child: Row(
        children: <Widget>[
          const IconTile.dark(Icons.hourglass_bottom_rounded, size: 52, iconSize: 26),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  context.l10n.timeUntilStart,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  copy.remainingDays(days),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: <Widget>[
                Text(
                  context.l10n.status,
                  style: const TextStyle(
                    fontSize: 10,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  upcoming ? context.l10n.upcoming : context.l10n.statusToday,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
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

class _EventDateCard extends StatelessWidget {
  const _EventDateCard({required this.event});

  final IslamicEvent event;

  @override
  Widget build(BuildContext context) {
    final AppCopy copy = AppCopy(context.l10n);
    final HijriDate hijri = HijriDate.fromGregorian(event.date);

    return AppCard(
      radius: 18,
      child: Row(
        children: <Widget>[
          const IconTile(Icons.calendar_month_outlined, iconSize: 21),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  context.l10n.eventDate,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  copy.weekdayDate(event.date),
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '(${copy.hijriDate(hijri)})',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.accentGreen,
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

class _AboutCard extends StatelessWidget {
  const _AboutCard({required this.event});

  final IslamicEvent event;

  @override
  Widget build(BuildContext context) {
    final AppCopy copy = AppCopy(context.l10n);

    return AppCard(
      radius: 18,
      padding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SectionTitle(
            title: context.l10n.aboutOccasion,
            icon: Icons.article_outlined,
          ),
          const SizedBox(height: 12),
          Text(
            copy.eventDescription(event),
            textAlign: TextAlign.justify,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w400,
              color: AppColors.textSecondary,
              height: 1.95,
            ),
          ),
          const SizedBox(height: 14),
          InfoNote(icon: event.icon, text: copy.eventHighlight(event)),
          const SizedBox(height: 8),
          Text(
            copy.eventDateSource(event),
            style: const TextStyle(
              fontSize: 11.5,
              height: 1.45,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickActionsCard extends StatelessWidget {
  const _QuickActionsCard({required this.event});

  final IslamicEvent event;

  @override
  Widget build(BuildContext context) {
    final AppState state = AppScope.of(context);
    final AppCopy copy = AppCopy(context.l10n);

    return AppCard(
      radius: 18,
      padding: const EdgeInsets.fromLTRB(13, 15, 13, 13),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: SectionTitle(
              title: context.l10n.quickActions,
              icon: Icons.bolt_rounded,
            ),
          ),
          const SizedBox(height: 12),
          _ActionRow(
            icon: Icons.calendar_today_outlined,
            label: context.l10n.addToDeviceCalendar,
            onTap: () async {
              final bool ok = await const DeviceCalendarService().addAllDayEvent(
                title: copy.eventTitle(event),
                date: event.date,
                notes: copy.eventDescription(event),
              );
              if (!context.mounted) {
                return;
              }
              showAppMessage(
                context,
                ok ? context.l10n.calendarOpened : context.l10n.calendarFailed,
              );
            },
          ),
          const SizedBox(height: 10),
          _ActionRow(
            icon: Icons.notifications_active_outlined,
            label: context.l10n.enableAdvanceAlert,
            subtitle: context.l10n.threeDaysBefore,
            trailing: AppToggle(
              value: state.eventPreAlert(event.id),
              onChanged: (bool value) =>
                  state.setEventPreAlert(event.id, value),
            ),
          ),
          const SizedBox(height: 10),
          _ActionRow(
            icon: Icons.share_outlined,
            label: context.l10n.shareOccasion,
            onTap: () => _shareEvent(context, event),
          ),
        ],
      ),
    );
  }
}

class _ActionRow extends StatelessWidget {
  const _ActionRow({
    required this.icon,
    required this.label,
    this.subtitle,
    this.trailing,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.background,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: <Widget>[
              IconTile(
                icon,
                size: 40,
                radius: 12,
                iconSize: 19,
                background: AppColors.surface,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      label,
                      style: const TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                        height: 1.3,
                      ),
                    ),
                    if (subtitle != null) ...<Widget>[
                      const SizedBox(height: 2),
                      Text(
                        subtitle!,
                        style: const TextStyle(
                          fontSize: 10.5,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 8),
              trailing ??
                  const Icon(
                    Icons.chevron_right,
                    size: 20,
                    color: AppColors.textMuted,
                  ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<void> _shareEvent(BuildContext context, IslamicEvent event) {
  final AppCopy copy = AppCopy(context.l10n);
  return SharePlus.instance.share(
    ShareParams(
      text: context.l10n.shareEventText(
        copy.eventTitle(event),
        copy.weekdayDate(event.date),
        copy.eventTagline(event),
      ),
    ),
  );
}
