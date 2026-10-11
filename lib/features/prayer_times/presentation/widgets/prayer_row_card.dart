import 'package:flutter/material.dart';

import '../../../../core/data/models.dart';
import '../../../../core/state/app_scope.dart';
import '../../../../core/state/app_state.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_feedback.dart';
import '../../../../core/widgets/common_widgets.dart';

/// One row of the prayer-times list. The next prayer gets the mint treatment
/// with a dark icon tile and a filled bell.
class PrayerRowCard extends StatelessWidget {
  const PrayerRowCard({super.key, required this.prayer});

  final PrayerTime prayer;

  @override
  Widget build(BuildContext context) {
    final AppState state = AppScope.of(context);
    final bool isNext = prayer.isNext;
    final bool alertOn = state.alertFor(prayer.id);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: isNext ? AppColors.mintSoft : AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isNext ? AppColors.primary : AppColors.border,
          width: isNext ? 1.5 : 1,
        ),
        boxShadow: isNext
            ? null
            : <BoxShadow>[
                BoxShadow(
                  color: AppColors.textPrimary.withValues(alpha: 0.025),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 12),
        child: Row(
          children: <Widget>[
            IconTile(
              prayer.icon,
              iconSize: 21,
              background: isNext ? AppColors.primary : AppColors.pillGray,
              foreground: isNext ? AppColors.surface : AppColors.textPrimary,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Flexible(
                        child: Text(
                          prayer.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                            height: 1.25,
                          ),
                        ),
                      ),
                      if (isNext) ...<Widget>[
                        const SizedBox(width: 8),
                        const AppBadge(
                          'الصلاة القادمة',
                          background: AppColors.primary,
                          foreground: AppColors.surface,
                          fontSize: 9.5,
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    isNext ? 'متبقي ${state.countdown}' : prayer.note,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: isNext ? FontWeight.w600 : FontWeight.w400,
                      color: isNext
                          ? AppColors.accentGreen
                          : AppColors.textSecondary,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Text(
              prayer.timeWithPeriod,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(width: 12),
            _AlertButton(prayer: prayer, isNext: isNext, enabled: alertOn),
          ],
        ),
      ),
    );
  }
}

class _AlertButton extends StatelessWidget {
  const _AlertButton({
    required this.prayer,
    required this.isNext,
    required this.enabled,
  });

  final PrayerTime prayer;
  final bool isNext;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final AppState state = AppScope.read(context);

    if (!prayer.supportsAlert) {
      return const _BellCircle(
        icon: Icons.notifications_off_outlined,
        background: AppColors.pillGray,
        foreground: AppColors.textMuted,
      );
    }

    return Semantics(
      button: true,
      label: 'تنبيه ${prayer.longName}',
      child: InkResponse(
        radius: 24,
        onTap: () {
          state.togglePrayerAlert(prayer.id);
          showAppMessage(
            context,
            state.rawAlertFor(prayer.id)
                ? 'تم تفعيل تنبيه ${prayer.longName} (تجريبي).'
                : 'تم إيقاف تنبيه ${prayer.longName} (تجريبي).',
          );
        },
        child: _BellCircle(
          icon: enabled
              ? Icons.notifications_active_outlined
              : Icons.notifications_off_outlined,
          background: isNext
              ? AppColors.primary
              : (enabled ? AppColors.mintSoft : AppColors.pillGray),
          foreground: isNext
              ? AppColors.surface
              : (enabled ? AppColors.primary : AppColors.textMuted),
        ),
      ),
    );
  }
}

class _BellCircle extends StatelessWidget {
  const _BellCircle({
    required this.icon,
    required this.background,
    required this.foreground,
  });

  final IconData icon;
  final Color background;
  final Color foreground;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(color: background, shape: BoxShape.circle),
      child: Icon(icon, size: 19, color: foreground),
    );
  }
}
