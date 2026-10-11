import 'package:flutter/material.dart';

import '../../../../core/data/models.dart';
import '../../../../core/navigation/app_routes.dart';
import '../../../../core/state/app_scope.dart';
import '../../../../core/state/app_state.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_card.dart';

class InfoCardsRow extends StatelessWidget {
  const InfoCardsRow({super.key});

  @override
  Widget build(BuildContext context) {
    final AppState state = AppScope.of(context);
    final PrayerTime maghrib = state.prayerById('maghrib');

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: InfoCard(
              title: 'الإمساك والإفطار',
              icon: Icons.access_time_rounded,
              value: 'الإفطار: ${maghrib.timeWithPeriod}',
              note: 'صيام الاثنين والخميس',
              onTap: () =>
                  Navigator.of(context).pushNamed(AppRoutes.prayerTimes),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: InfoCard(
              title: 'زاوية القبلة',
              icon: Icons.wifi_tethering_rounded,
              iconColor: AppColors.primary,
              value: state.city.qiblaLabel,
              note: 'دقة البوصلة عالية',
              noteColor: AppColors.accentGreen,
              onTap: () => Navigator.of(context).pushNamed(AppRoutes.qibla),
            ),
          ),
        ],
      ),
    );
  }
}

class InfoCard extends StatelessWidget {
  const InfoCard({
    super.key,
    required this.title,
    required this.icon,
    required this.value,
    required this.note,
    required this.onTap,
    this.iconColor = AppColors.textPrimary,
    this.noteColor = AppColors.textSecondary,
  });

  final String title;
  final IconData icon;
  final String value;
  final String note;
  final VoidCallback onTap;
  final Color iconColor;
  final Color noteColor;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: AppCard(
      padding: const EdgeInsets.fromLTRB(14, 13, 14, 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textSecondary,
                    height: 1.3,
                  ),
                ),
              ),
              const SizedBox(width: 6),
              Icon(icon, size: 16, color: iconColor),
            ],
          ),
          const SizedBox(height: 14),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: AlignmentDirectional.centerStart,
            child: Text(
              value,
              maxLines: 1,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
                height: 1.3,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            note,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w400,
              color: noteColor,
              height: 1.3,
            ),
          ),
        ],
      ),
      ),
    );
  }
}
