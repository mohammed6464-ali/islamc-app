import 'package:flutter/material.dart';

import '../../../../core/data/models.dart';
import '../../../../core/state/app_scope.dart';
import '../../../../core/state/app_state.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_feedback.dart';
import '../../../../core/widgets/common_widgets.dart';

/// Row of the "توقعات الأيام القادمة" list.
class ForecastRowCard extends StatelessWidget {
  const ForecastRowCard({super.key, required this.forecast});

  final DailyForecast forecast;

  @override
  Widget build(BuildContext context) {
    final AppState state = AppScope.of(context);
    final bool highlighted = forecast.isToday;

    return Material(
      color: highlighted ? AppColors.mintSoft : AppColors.surface,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => showAppMessage(
          context,
          'توقعات ${forecast.day}: ${forecast.description} '
          '(${state.formatTemperature(forecast.low)} / '
          '${state.formatTemperature(forecast.high)}).',
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: highlighted ? AppColors.mintBorder : AppColors.border,
            ),
          ),
          child: Row(
            children: <Widget>[
              IconTile(
                forecast.icon,
                size: 42,
                radius: 13,
                iconSize: 21,
                background: highlighted
                    ? AppColors.surface
                    : AppColors.pillGray,
                foreground: AppColors.sunOrange,
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
                            forecast.day,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 14.5,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                              height: 1.25,
                            ),
                          ),
                        ),
                        if (forecast.badge != null) ...<Widget>[
                          const SizedBox(width: 8),
                          AppBadge(
                            forecast.badge!,
                            fontSize: 9.5,
                            background: forecast.badgeTone == BadgeTone.amber
                                ? AppColors.amberPill
                                : AppColors.mintStrong,
                            foreground: forecast.badgeTone == BadgeTone.amber
                                ? AppColors.amberText
                                : AppColors.primary,
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      forecast.description,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.textSecondary,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Row(
                textDirection: TextDirection.ltr,
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: <Widget>[
                  Text(
                    state.formatTemperature(forecast.low),
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textMuted,
                    ),
                  ),
                  const Text(
                    ' / ',
                    style: TextStyle(fontSize: 13, color: AppColors.textMuted),
                  ),
                  Text(
                    state.formatTemperature(forecast.high),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 4),
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
