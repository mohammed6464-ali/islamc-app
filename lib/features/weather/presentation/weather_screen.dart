import 'package:flutter/material.dart';

import '../../../core/data/models.dart';
import '../../../core/l10n/app_copy.dart';
import '../../../core/l10n/app_language.dart';
import '../../../core/navigation/app_routes.dart';
import '../../../core/state/app_scope.dart';
import '../../../core/state/app_state.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/time/app_timezone.dart';
import '../../../core/weather/weather_snapshot.dart';
import '../../../core/widgets/app_feedback.dart';
import '../../../core/widgets/app_screen_header.dart';
import '../../../core/widgets/common_widgets.dart';
import '../../../l10n/app_localizations.dart';
import 'widgets/forecast_row_card.dart';
import 'widgets/weather_hero_card.dart';
import 'widgets/weather_metric_card.dart';

class WeatherScreen extends StatelessWidget {
  const WeatherScreen({super.key});

  List<WeatherMetric> _metrics(BuildContext context, AppState state) {
    final AppCopy copy = AppCopy(context.l10n);
    final WeatherData w = state.weather;
    return <WeatherMetric>[
      WeatherMetric(
        label: context.l10n.humidity,
        value: '${w.humidity}%',
        note: copy.humidityNote(w.humidity),
        icon: Icons.water_drop_outlined,
        progress: w.humidity / 100,
        tone: MetricTone.green,
      ),
      WeatherMetric(
        label: context.l10n.windSpeed,
        value: '${w.windSpeed}',
        unit: context.l10n.kmh,
        note: copy.windDirectionFromLabel(w.windDirection),
        icon: Icons.air_rounded,
        progress: w.windSpeed / 40,
        tone: MetricTone.green,
      ),
      WeatherMetric(
        label: context.l10n.feelsLike,
        value: state.formatTemperature(w.feelsLike),
        note: w.feelsLike > w.temperature
            ? context.l10n.warmer
            : context.l10n.matchesTemp,
        icon: Icons.thermostat_rounded,
        progress: 0.72,
        tone: MetricTone.orange,
      ),
      WeatherMetric(
        label: context.l10n.uvIndex,
        value: '${w.uvIndex}',
        valueAccent: copy.uvLabel(w.uvIndex),
        note: context.l10n.uvProtect,
        icon: Icons.wb_sunny_outlined,
        progress: w.uvIndex / 11,
        tone: MetricTone.amber,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final AppState state = AppScope.of(context);
    final AppCopy copy = AppCopy(context.l10n);
    final List<WeatherMetric> metrics = _metrics(context, state);
    final List<DailyForecast> forecast = state.weather.forecast;

    return Column(
      children: <Widget>[
        SafeArea(
          bottom: false,
          child: AppScreenHeader(
            leading: HeaderIconButton(
              icon: Icons.location_on_outlined,
              tooltip: context.l10n.changeCity,
              onPressed: () =>
                  Navigator.of(context).pushNamed(AppRoutes.currentLocation),
            ),
            title: context.l10n.weather,
            subtitle: copy.cityFullName(state.city),
            titleColor: AppColors.textPrimary,
            actions: <Widget>[
              HeaderIconButton(
                icon: Icons.refresh_rounded,
                tooltip: context.l10n.refresh,
                onPressed: () async {
                  if (state.weatherRefreshing) {
                    return;
                  }
                  final bool ok = await state.refreshWeather(force: true);
                  if (!context.mounted) {
                    return;
                  }
                  if (ok) {
                    showAppMessage(context, context.l10n.weatherUpdated);
                  } else {
                    showAppMessage(
                      context,
                      context.l10n.weatherUpdateFailed,
                    );
                  }
                },
              ),
              HeaderIconButton(
                icon: Icons.explore_outlined,
                tooltip: context.l10n.qiblaDirection,
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
              SectionTitle(
                title: context.l10n.weatherIndicators,
                trailing: state.weatherRefreshing
                    ? context.l10n.updating
                    : (state.weatherSnapshot == null
                          ? context.l10n.liveAccuracy
                          : _weatherUpdatedLabel(context, state)),
              ),
              const SizedBox(height: 12),
              _MetricGrid(metrics: metrics),
              const SizedBox(height: 22),
              SectionTitle(
                title: context.l10n.forecast,
                icon: Icons.calendar_today_outlined,
                trailing: context.l10n.forecastDays(forecast.length),
              ),
              const SizedBox(height: 12),
              for (int i = 0; i < forecast.length; i++) ...<Widget>[
                ForecastRowCard(
                  forecast: forecast[i],
                  selected: i == state.selectedForecastIndex,
                  onTap: () {
                    state.selectForecastIndex(i);
                    showAppMessage(
                      context,
                      context.l10n.forecastSnack(
                        copy.forecastDay(forecast[i]),
                        _forecastCondition(copy, forecast[i], state.weather),
                        state.formatTemperature(forecast[i].low),
                        state.formatTemperature(forecast[i].high),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 10),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

String _forecastCondition(
  AppCopy copy,
  DailyForecast day,
  WeatherData current,
) {
  return copy.weatherCondition(
    day.weatherCode ?? current.weatherCode,
    isDay: day.weatherCode != null ? true : current.isDay,
  );
}

String _weatherUpdatedLabel(BuildContext context, AppState state) {
  final WeatherSnapshot? snapshot = state.weatherSnapshot;
  if (snapshot == null) {
    return '';
  }
  final Duration age = state.clock.nowUtc().difference(snapshot.fetchedAt.toUtc());
  if (age.inMinutes < 1) {
    return context.l10n.weatherUpdatedNow;
  }
  if (age.inMinutes < 60) {
    return context.l10n.weatherUpdatedMinutes(age.inMinutes);
  }
  final DateTime local = AppTimezone.convert(
    snapshot.fetchedAt,
    state.location.timezoneId,
  );
  final String time =
      '${local.hour.toString().padLeft(2, '0')}:${local.minute.toString().padLeft(2, '0')}';
  return context.l10n.weatherUpdatedAt(time);
}

String _weatherStatus(BuildContext context, AppState state) {
  final AppLocalizations l10n = context.l10n;
  final WeatherSnapshot? snapshot = state.weatherSnapshot;
  if (state.weatherRefreshing && snapshot == null) {
    return l10n.weatherUpdating;
  }
  if (snapshot == null) {
    if (state.weatherError != null) {
      return l10n.weatherUpdateFailed;
    }
    if (state.weather.isUnavailable) {
      return l10n.weatherUnavailableCity;
    }
    return l10n.weatherLive(state.weather.station);
  }
  if (snapshot.isFromCache || snapshot.isStale(state.clock.nowUtc())) {
    return l10n.weatherCached(snapshot.data.station);
  }
  return l10n.weatherLive(snapshot.data.station);
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

/// Live station status + weather badge.
class _StationBanner extends StatelessWidget {
  const _StationBanner();

  @override
  Widget build(BuildContext context) {
    final AppState state = AppScope.of(context);
    final AppCopy copy = AppCopy(context.l10n);

    return Container(
      padding: const EdgeInsets.fromLTRB(14, 9, 9, 9),
      decoration: BoxDecoration(
        color: AppColors.pillGray,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: <Widget>[
          Dot(
            size: 7,
            color: state.weatherRefreshing
                ? AppColors.sunOrange
                : (state.weather.isFromCache || state.weather.isUnavailable
                      ? AppColors.textMuted
                      : AppColors.primary),
          ),
          const SizedBox(width: 9),
          Expanded(
            child: Text(
              _weatherStatus(context, state),
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
          AppBadge(
            state.weather.isUnavailable
                ? context.l10n.weatherStationUnavailable
                : copy.weatherBadge(state.weather.weatherCode),
            background: AppColors.surface,
            foreground: AppColors.textSecondary,
            fontSize: 10.5,
            fontWeight: FontWeight.w500,
            radius: 11,
            padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 5),
          ),
        ],
      ),
    );
  }
}
