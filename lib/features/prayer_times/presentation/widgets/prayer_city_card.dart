import 'package:flutter/material.dart';

import '../../../../core/l10n/app_copy.dart';
import '../../../../core/l10n/app_language.dart';
import '../../../../core/navigation/app_routes.dart';
import '../../../../core/state/app_scope.dart';
import '../../../../core/state/app_state.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/common_widgets.dart';

/// White card at the top of the prayer-times screen: city, country pill and
/// the Hijri/Gregorian pair.
class PrayerCityCard extends StatelessWidget {
  const PrayerCityCard({super.key});

  @override
  Widget build(BuildContext context) {
    final AppState state = AppScope.of(context);
    final AppCopy copy = AppCopy(context.l10n);
    final String dates =
        '${copy.hijriDate(state.hijriToday)} — ${copy.gregorianDate(state.today)}';

    return AppCard(
      radius: 18,
      padding: const EdgeInsets.all(13),
      child: Row(
        children: <Widget>[
          const IconTile.mint(Icons.location_on_outlined, iconSize: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Flexible(
                      child: Text(
                        copy.cityName(state.city),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 16.5,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                          height: 1.25,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: AppBadge(
                        copy.countryName(state.city),
                        background: AppColors.pillGray,
                        foreground: AppColors.textSecondary,
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  dates,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textSecondary,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            tooltip: context.l10n.changeCity,
            visualDensity: VisualDensity.compact,
            onPressed: () =>
                Navigator.of(context).pushNamed(AppRoutes.currentLocation),
            icon: const Icon(
              Icons.tune_rounded,
              size: 20,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
