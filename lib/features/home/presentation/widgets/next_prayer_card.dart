import 'package:flutter/material.dart';

import '../../../../core/data/models.dart';
import '../../../../core/l10n/app_copy.dart';
import '../../../../core/l10n/app_language.dart';
import '../../../../core/navigation/app_routes.dart';
import '../../../../core/state/app_scope.dart';
import '../../../../core/state/app_state.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/decorative_patterns.dart';

/// The dark green hero card: next prayer, its time and the countdown panel.
class NextPrayerCard extends StatelessWidget {
  const NextPrayerCard({super.key});

  @override
  Widget build(BuildContext context) {
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
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const _HeroTopRow(),
                  const SizedBox(height: 20),
                  const _HeroMainRow(),
                  const SizedBox(height: 20),
                  const _CountdownPanel(),
                ],
              ),
            ),
            Positioned.fill(
              child: Material(
                type: MaterialType.transparency,
                child: InkWell(
                  onTap: () =>
                      Navigator.of(context).pushNamed(AppRoutes.prayerTimes),
                  splashColor: Colors.white.withValues(alpha: 0.08),
                  highlightColor: Colors.white.withValues(alpha: 0.05),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeroTopRow extends StatelessWidget {
  const _HeroTopRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Flexible(
          child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.10),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.white.withValues(alpha: 0.14)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  color: AppColors.mintStrong.withValues(alpha: 0.95),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 7),
              Flexible(
                child: Text(
                  context.l10n.nextPrayer,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: Colors.white.withValues(alpha: 0.95),
                  ),
                ),
              ),
            ],
          ),
        ),
        ),
        const SizedBox(width: 8),
        Flexible(
          child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.14),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(
                Icons.volume_up_outlined,
                size: 13,
                color: Colors.white.withValues(alpha: 0.85),
              ),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  AppScope.of(context).masterPrayerAlerts
                      ? context.l10n.adhanEnabled
                      : context.l10n.adhanDisabled,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w500,
                    color: Colors.white.withValues(alpha: 0.85),
                  ),
                ),
              ),
            ],
          ),
        ),
        ),
      ],
    );
  }
}

class _HeroMainRow extends StatelessWidget {
  const _HeroMainRow();

  @override
  Widget build(BuildContext context) {
    final AppState state = AppScope.of(context);
    final PrayerTime next = state.nextPrayer;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: AlignmentDirectional.centerStart,
                child: Text(
                  AppCopy(context.l10n).prayerLongName(next.id),
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    height: 1.2,
                  ),
                ),
              ),
              const SizedBox(height: 5),
              Text(
                context.l10n.adhanTimeUmmAlQura,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 10.5,
                  fontWeight: FontWeight.w400,
                  color: Colors.white.withValues(alpha: 0.58),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              textDirection: TextDirection.ltr,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: <Widget>[
                Text(
                  next.time,
                  style: const TextStyle(
                    fontSize: 27,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    height: 1.2,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(width: 9),
                Text(
                  next.minutes < 12 * 60 ? 'AM' : 'PM',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    height: 1.2,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: Text(
                next.minutes < 12 * 60
                    ? context.l10n.morning
                    : context.l10n.evening,
                style: TextStyle(
                  fontSize: 10.5,
                  fontWeight: FontWeight.w400,
                  color: Colors.white.withValues(alpha: 0.58),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _CountdownPanel extends StatelessWidget {
  const _CountdownPanel();

  @override
  Widget build(BuildContext context) {
    final AppState state = AppScope.of(context);

    return Container(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
      decoration: BoxDecoration(
        color: AppColors.primaryDark.withValues(alpha: 0.62),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            children: <Widget>[
              Icon(
                Icons.hourglass_bottom_rounded,
                size: 14,
                color: Colors.white.withValues(alpha: 0.75),
              ),
              const SizedBox(width: 7),
              Expanded(
                child: Text(
                  context.l10n.remainingUntilPrayer,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w400,
                    color: Colors.white.withValues(alpha: 0.78),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                state.countdown,
                textDirection: TextDirection.ltr,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: AppColors.mintStrong,
                  letterSpacing: 0.6,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: SizedBox(
              height: 6,
              child: Stack(
                children: <Widget>[
                  ColoredBox(
                    color: Colors.white.withValues(alpha: 0.12),
                    child: const SizedBox.expand(),
                  ),
                  FractionallySizedBox(
                    alignment: AlignmentDirectional.centerStart,
                    widthFactor: state.countdownProgress,
                    child: const DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: <Color>[
                            AppColors.lightMint,
                            Color(0xFFE8F3EE),
                          ],
                        ),
                      ),
                      child: SizedBox.expand(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
