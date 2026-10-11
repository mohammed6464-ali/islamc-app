import 'package:flutter/material.dart';

import '../../../../core/navigation/main_shell.dart';
import '../../../../core/state/app_scope.dart';
import '../../../../core/state/app_state.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/decorative_patterns.dart';

class DateWeatherCard extends StatelessWidget {
  const DateWeatherCard({super.key});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: EdgeInsets.zero,
      child: Stack(
        children: <Widget>[
          const Positioned.fill(child: SkylineDecoration()),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
            child: IntrinsicHeight(
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 59,
                    child: InkWell(
                      onTap: () => MainShell.goToTab(context, 2),
                      child: const _DateBlock(),
                    ),
                  ),
                  Container(
                    width: 1,
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    color: AppColors.divider,
                  ),
                  Expanded(
                    flex: 41,
                    child: InkWell(
                      onTap: () => MainShell.goToTab(context, 1),
                      child: const _WeatherBlock(),
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

class _DateBlock extends StatelessWidget {
  const _DateBlock();

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Padding(
          padding: EdgeInsets.only(top: 1),
          child: Icon(
            Icons.calendar_month_outlined,
            size: 16,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                AppScope.of(context).hijriLabel,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                  height: 1.35,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                AppScope.of(context).gregorianLabel,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w400,
                  color: AppColors.textSecondary,
                  height: 1.35,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _WeatherBlock extends StatelessWidget {
  const _WeatherBlock();

  @override
  Widget build(BuildContext context) {
    final AppState state = AppScope.of(context);

    return Row(
      children: <Widget>[
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                '${state.formatTemperature(state.weather.temperature)} '
                '${state.useFahrenheit ? 'ف' : 'م'}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                state.weather.condition,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w400,
                  color: AppColors.textSecondary,
                  height: 1.35,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        const PartlyCloudyTile(),
      ],
    );
  }
}

/// Sun-behind-cloud glyph in a soft rounded tile, matching the reference.
class PartlyCloudyTile extends StatelessWidget {
  const PartlyCloudyTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 38,
      height: 38,
      decoration: BoxDecoration(
        color: const Color(0xFFF2F1EA),
        borderRadius: BorderRadius.circular(12),
      ),
      alignment: Alignment.center,
      child: SizedBox(
        width: 22,
        height: 22,
        child: Stack(
          children: <Widget>[
            const Positioned(
              top: 0,
              right: 0,
              child: Icon(
                Icons.wb_sunny_outlined,
                size: 17,
                color: AppColors.goldDeep,
              ),
            ),
            Positioned(
              bottom: 1,
              left: 0,
              child: Container(
                padding: const EdgeInsets.all(1),
                decoration: const BoxDecoration(
                  color: Color(0xFFF2F1EA),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.cloud,
                  size: 11,
                  color: AppColors.goldDeep,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
