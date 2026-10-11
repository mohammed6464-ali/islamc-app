import 'package:flutter/material.dart';

import '../../../core/data/demo_data.dart';
import '../../../core/data/models.dart';
import '../../../core/navigation/app_routes.dart';
import '../../../core/state/app_scope.dart';
import '../../../core/state/app_state.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_feedback.dart';
import '../../../core/widgets/app_screen_header.dart';
import '../../../core/widgets/common_widgets.dart';
import 'widgets/forecast_row_card.dart';
import 'widgets/weather_hero_card.dart';
import 'widgets/weather_metric_card.dart';

class WeatherScreen extends StatelessWidget {
  const WeatherScreen({super.key});

  List<WeatherMetric> _metrics(AppState state) {
    final WeatherData w = state.weather;
    return <WeatherMetric>[
      WeatherMetric(
        label: 'الرطوبة',
        value: '${w.humidity}%',
        note: DemoData.humidityNote(w.humidity),
        icon: Icons.water_drop_outlined,
        progress: w.humidity / 100,
        tone: MetricTone.green,
      ),
      WeatherMetric(
        label: 'سرعة الرياح',
        value: '${w.windSpeed}',
        unit: 'كم/س',
        note: w.windDirection,
        icon: Icons.air_rounded,
        progress: w.windSpeed / 40,
        tone: MetricTone.green,
      ),
      WeatherMetric(
        label: 'الإحساس الفعلي',
        value: state.formatTemperature(w.feelsLike),
        note: w.feelsLike > w.temperature
            ? 'أدفأ بدرجتين'
            : 'مطابق لدرجة الحرارة',
        icon: Icons.thermostat_rounded,
        progress: 0.72,
        tone: MetricTone.orange,
      ),
      WeatherMetric(
        label: 'مؤشر الأشعة (UV)',
        value: '${w.uvIndex}',
        valueAccent: w.uvLabel,
        note: 'يوصى بالحماية شمسياً',
        icon: Icons.wb_sunny_outlined,
        progress: w.uvIndex / 11,
        tone: MetricTone.amber,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final AppState state = AppScope.of(context);
    final List<WeatherMetric> metrics = _metrics(state);
    final List<DailyForecast> forecast = state.weather.forecast;

    return Column(
      children: <Widget>[
        SafeArea(
          bottom: false,
          child: AppScreenHeader(
            leading: HeaderIconButton(
              icon: Icons.location_on_outlined,
              tooltip: 'تغيير المدينة',
              onPressed: () =>
                  Navigator.of(context).pushNamed(AppRoutes.currentLocation),
            ),
            title: 'الطقس',
            subtitle: state.city.fullName,
            titleColor: AppColors.textPrimary,
            actions: <Widget>[
              HeaderIconButton(
                icon: Icons.refresh_rounded,
                tooltip: 'تحديث',
                onPressed: () => showAppMessage(
                  context,
                  'بيانات الطقس تجريبية ولا تعتمد على خدمة طقس حقيقية.',
                ),
              ),
              HeaderIconButton(
                icon: Icons.explore_outlined,
                tooltip: 'اتجاه القبلة',
                onPressed: () =>
                    Navigator.of(context).pushNamed(AppRoutes.qibla),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 20),
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            children: <Widget>[
              const _StationBanner(),
              const SizedBox(height: 14),
              const WeatherHeroCard(),
              const SizedBox(height: 22),
              const SectionTitle(
                title: 'مؤشرات الطقس الآن',
                trailing: 'دقة لحظية',
              ),
              const SizedBox(height: 12),
              _MetricGrid(metrics: metrics),
              const SizedBox(height: 22),
              SectionTitle(
                title: 'توقعات الأيام القادمة',
                icon: Icons.calendar_today_outlined,
                trailing: '${forecast.length} أيام مقبلة',
              ),
              const SizedBox(height: 12),
              for (final DailyForecast day in forecast) ...<Widget>[
                ForecastRowCard(forecast: day),
                const SizedBox(height: 10),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _MetricGrid extends StatelessWidget {
  const _MetricGrid({required this.metrics});

  final List<WeatherMetric> metrics;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        for (int row = 0; row < metrics.length; row += 2) ...<Widget>[
          if (row > 0) const SizedBox(height: 12),
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Expanded(child: WeatherMetricCard(metric: metrics[row])),
                const SizedBox(width: 12),
                Expanded(
                  child: row + 1 < metrics.length
                      ? WeatherMetricCard(metric: metrics[row + 1])
                      : const SizedBox.shrink(),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

/// `● تحديث مباشر لمحطة ...` ............ `أجواء مستقرة`
class _StationBanner extends StatelessWidget {
  const _StationBanner();

  @override
  Widget build(BuildContext context) {
    final AppState state = AppScope.of(context);

    return Container(
      padding: const EdgeInsets.fromLTRB(14, 9, 9, 9),
      decoration: BoxDecoration(
        color: AppColors.pillGray,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: <Widget>[
          const Dot(size: 7, color: AppColors.primary),
          const SizedBox(width: 9),
          Expanded(
            child: Text(
              'تحديث مباشر لـ${state.weather.station}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w500,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          const SizedBox(width: 8),
          const AppBadge(
            'أجواء مستقرة',
            background: AppColors.surface,
            foreground: AppColors.textSecondary,
            fontSize: 10.5,
            fontWeight: FontWeight.w500,
            radius: 11,
            padding: EdgeInsets.symmetric(horizontal: 11, vertical: 5),
          ),
        ],
      ),
    );
  }
}
