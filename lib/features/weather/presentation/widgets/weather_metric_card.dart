import 'package:flutter/material.dart';

import '../../../../core/data/models.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/common_widgets.dart';

/// One tile of the 2×2 "مؤشرات الطقس الآن" grid.
class WeatherMetricCard extends StatelessWidget {
  const WeatherMetricCard({super.key, required this.metric});

  final WeatherMetric metric;

  Color get _progressColor => switch (metric.tone) {
    MetricTone.green => AppColors.primary,
    MetricTone.amber => AppColors.progressAmber,
    MetricTone.orange => AppColors.progressOrange,
  };

  @override
  Widget build(BuildContext context) {
    return AppCard(
      radius: 16,
      padding: const EdgeInsets.fromLTRB(13, 13, 13, 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  metric.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconTile(
                metric.icon,
                size: 34,
                radius: 11,
                iconSize: 17,
                foreground: _progressColor,
              ),
            ],
          ),
          const SizedBox(height: 14),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: AlignmentDirectional.centerStart,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: <Widget>[
                Text(
                  metric.value,
                  textDirection: TextDirection.ltr,
                  style: const TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                    height: 1.2,
                  ),
                ),
                if (metric.valueAccent != null) ...<Widget>[
                  const SizedBox(width: 6),
                  Text(
                    metric.valueAccent!,
                    style: const TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                      height: 1.2,
                    ),
                  ),
                ],
                if (metric.unit != null) ...<Widget>[
                  const SizedBox(width: 6),
                  Text(
                    metric.unit!,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 3),
          Text(
            metric.note,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w400,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 13),
          ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: SizedBox(
              height: 6,
              child: Stack(
                children: <Widget>[
                  const Positioned.fill(
                    child: ColoredBox(color: AppColors.progressTrack),
                  ),
                  Positioned.fill(
                    child: FractionallySizedBox(
                      alignment: AlignmentDirectional.centerStart,
                      widthFactor: metric.progress.clamp(0.05, 1.0),
                      child: ColoredBox(color: _progressColor),
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
