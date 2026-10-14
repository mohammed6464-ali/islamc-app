import 'package:flutter/material.dart';

import '../../../../core/data/hijri_date.dart';
import '../../../../core/data/models.dart';
import '../../../../core/l10n/app_copy.dart';
import '../../../../core/l10n/app_language.dart';
import '../../../../core/navigation/app_routes.dart';
import '../../../../core/state/app_scope.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/common_widgets.dart';

/// Card used by the upcoming-occasions list on the calendar screen.
class EventListCard extends StatelessWidget {
  const EventListCard({super.key, required this.event});

  final IslamicEvent event;

  @override
  Widget build(BuildContext context) {
    final AppCopy copy = AppCopy(context.l10n);
    final bool national = event.kind == EventKind.national;
    final int days = AppScope.of(context).daysUntil(event.date);
    final HijriDate hijri = HijriDate.fromGregorian(event.date);
    final String dateLine = national
        ? '${copy.gregorianDate(event.date)} (${copy.hijriDate(hijri)})'
        : '${copy.hijriDate(hijri)} - ${copy.gregorianDate(event.date)}';

    return Material(
      color: national ? AppColors.surface : AppColors.mintTint,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () => Navigator.of(
          context,
        ).pushNamed(AppRoutes.eventDetails, arguments: event.id),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.border),
          ),
          padding: const EdgeInsets.fromLTRB(14, 14, 14, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  national
                      ? IconTile.amber(event.icon, iconSize: 21)
                      : IconTile.mint(event.icon, iconSize: 21),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          copy.eventTitle(event),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                            height: 1.3,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          dateLine,
                          style: const TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w400,
                            color: AppColors.textSecondary,
                            height: 1.45,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 110),
                    child: AppBadge(
                      national
                          ? '${copy.eventBadge(event)} - ${copy.remainingDays(days)}'
                          : copy.eventBadge(event),
                      background: national
                          ? AppColors.amberPill
                          : AppColors.mintStrong,
                      foreground: national
                          ? AppColors.amberText
                          : AppColors.primary,
                      fontSize: 10,
                      radius: 12,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 11,
                        vertical: 6,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const CardDivider(),
              const SizedBox(height: 10),
              Row(
                children: <Widget>[
                  Icon(
                    national ? Icons.event_available_outlined : Icons.schedule,
                    size: 15,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: 7),
                  Expanded(
                    child: Text(
                      copy.eventNote(event),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 11.5,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                  Text(
                    copy.eventAction(event),
                    style: const TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w600,
                      color: AppColors.accentGreen,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
