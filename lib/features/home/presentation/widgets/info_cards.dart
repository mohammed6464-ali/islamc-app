import 'package:flutter/material.dart';

import '../../../../core/data/models.dart';
import '../../../../core/l10n/app_copy.dart';
import '../../../../core/l10n/app_language.dart';
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
              title: context.l10n.imsakIftar,
              icon: Icons.access_time_rounded,
              value: context.l10n.iftarAt(
                AppCopy(context.l10n).timeWithPeriod(maghrib),
              ),
              note: context.l10n.mondayThursdayFast,
              onTap: () =>
                  Navigator.of(context).pushNamed(AppRoutes.prayerTimes),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: InfoCard(
              title: context.l10n.qiblaAngleLabel,
              icon: Icons.wifi_tethering_rounded,
              iconColor: AppColors.primary,
              value: AppCopy(context.l10n).qiblaLabel(
                state.city.qiblaAngle.toDouble(),
                atKaaba: state.city.distanceToMakkah < 2,
              ),
              note: context.l10n.compassHighAccuracy,
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
