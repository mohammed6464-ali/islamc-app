import 'package:flutter/material.dart';

import '../../../../core/data/models.dart';
import '../../../../core/navigation/app_routes.dart';
import '../../../../core/state/app_scope.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_card.dart';

class PrayerTimesCard extends StatelessWidget {
  const PrayerTimesCard({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: () => Navigator.of(context).pushNamed(AppRoutes.prayerTimes),
      child: AppCard(
        radius: 18,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 7),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              for (final PrayerTime entry in AppScope.of(context).prayerTimes)
                Expanded(child: PrayerTimeItem(entry: entry)),
            ],
          ),
        ),
      ),
    );
  }
}

class PrayerTimeItem extends StatelessWidget {
  const PrayerTimeItem({super.key, required this.entry});

  final PrayerTime entry;

  @override
  Widget build(BuildContext context) {
    final bool active = entry.isNext;
    final Color nameColor =
        active ? AppColors.primary : AppColors.textMuted;
    final Color timeColor =
        active ? AppColors.primary : const Color(0xFF454B47);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2),
      padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 2),
      decoration: active
          ? BoxDecoration(
              color: AppColors.mint,
              borderRadius: BorderRadius.circular(13),
              border: Border.all(color: AppColors.mintBorder),
            )
          : null,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              entry.name,
              maxLines: 1,
              style: TextStyle(
                fontSize: 11,
                fontWeight: active ? FontWeight.w700 : FontWeight.w500,
                color: nameColor,
                height: 1.3,
              ),
            ),
          ),
          const SizedBox(height: 9),
          Icon(
            entry.icon,
            size: 17,
            color: active ? AppColors.primary : const Color(0xFFB9BEBA),
          ),
          const SizedBox(height: 9),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              entry.time,
              maxLines: 1,
              textDirection: TextDirection.ltr,
              style: TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w700,
                color: timeColor,
                height: 1.25,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            entry.period,
            style: TextStyle(
              fontSize: 10,
              fontWeight: active ? FontWeight.w600 : FontWeight.w400,
              color: active ? AppColors.primary : AppColors.textMuted,
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}
