import 'package:flutter/material.dart';

import '../../../../core/data/models.dart';
import '../../../../core/l10n/app_copy.dart';
import '../../../../core/l10n/app_language.dart';
import '../../../../core/navigation/app_routes.dart';
import '../../../../core/state/app_scope.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_card.dart';

class UpcomingEventCard extends StatelessWidget {
  const UpcomingEventCard({super.key});

  @override
  Widget build(BuildContext context) {
    final IslamicEvent? event = AppScope.of(context).featuredEvent;
    if (event == null) {
      return const SizedBox.shrink();
    }
    final int days = AppScope.of(context).daysUntil(event.date);

    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: () => Navigator.of(
        context,
      ).pushNamed(AppRoutes.eventDetails, arguments: event.id),
      child: AppCard(
      radius: 18,
      padding: EdgeInsets.zero,
      child: Stack(
        children: <Widget>[
          PositionedDirectional(
            end: -26,
            bottom: -34,
            child: Container(
              width: 110,
              height: 110,
              decoration: const BoxDecoration(
                color: AppColors.amberBg,
                shape: BoxShape.circle,
              ),
            ),
          ),
          const PositionedDirectional(
            end: 16,
            bottom: 12,
            child: Icon(
              Icons.chevron_right_rounded,
              size: 20,
              color: AppColors.divider,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: <Widget>[
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppColors.amberIcon,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.celebration_outlined,
                    size: 22,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        context.l10n.upcomingEvents,
                        style: TextStyle(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w500,
                          color: AppColors.goldDeep,
                          height: 1.3,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        AppCopy(context.l10n).eventTitle(event),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                          height: 1.3,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        AppCopy(context.l10n).weekdayDate(event.date),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w400,
                          color: AppColors.textSecondary,
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.amberPill,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Text(
                      AppCopy(context.l10n).remainingDays(days),
                      style: const TextStyle(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w600,
                        color: AppColors.amberText,
                      ),
                    ),
                  ),
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
