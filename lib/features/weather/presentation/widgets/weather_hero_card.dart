import 'package:flutter/material.dart';

import '../../../../core/data/models.dart';
import '../../../../core/l10n/app_copy.dart';
import '../../../../core/l10n/app_language.dart';
import '../../../../core/state/app_scope.dart';
import '../../../../core/state/app_state.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/decorative_patterns.dart';

/// Big temperature block, high/low pill, cloud-cover tile and the two
/// footer lines.
class WeatherHeroCard extends StatelessWidget {
  const WeatherHeroCard({super.key});

  @override
  Widget build(BuildContext context) {
    final AppState state = AppScope.of(context);
    final AppCopy copy = AppCopy(context.l10n);
    final WeatherData weather = state.weather;
    final PrayerTime next = state.nextPrayer;

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
              padding: const EdgeInsets.fromLTRB(16, 22, 16, 16),
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Text(
                        state.formatTemperature(weather.temperature),
                        textDirection: TextDirection.ltr,
                        style: const TextStyle(
                          fontSize: 64,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          height: 1.05,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Text(
                          state.temperatureUnitNameFor(copy),
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.white.withValues(alpha: 0.72),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${copy.weatherCondition(weather.weatherCode, isDay: weather.isDay)} • ${copy.cityName(state.city)}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 14),
                  _HighLowPill(
                    high: state.formatTemperature(weather.high),
                    low: state.formatTemperature(weather.low),
                  ),
                  const SizedBox(height: 16),
                  _CloudCoverTile(cover: weather.cloudCover),
                  const SizedBox(height: 16),
                  Divider(
                    height: 1,
                    thickness: 1,
                    color: Colors.white.withValues(alpha: 0.14),
                  ),
                  const SizedBox(height: 14),
                  _FooterLine(
                    icon: Icons.mosque_outlined,
                    text: context.l10n.nextAdhanAt(
                      copy.prayerName(next.id),
                      copy.timeWithPeriod(next),
                    ),
                  ),
                  const SizedBox(height: 9),
                  _FooterLine(
                    icon: Icons.air_rounded,
                    text: copy.weatherNote(weather.weatherCode),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HighLowPill extends StatelessWidget {
  const _HighLowPill({required this.high, required this.low});

  final String high;
  final String low;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withValues(alpha: 0.14)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Icon(
            Icons.arrow_upward_rounded,
            size: 14,
            color: Color(0xFFFFB4A8),
          ),
          const SizedBox(width: 6),
          Text(context.l10n.highTemp(high), style: _valueStyle),
          Container(
            width: 1,
            height: 16,
            margin: const EdgeInsets.symmetric(horizontal: 12),
            color: Colors.white.withValues(alpha: 0.22),
          ),
          const Icon(
            Icons.arrow_downward_rounded,
            size: 14,
            color: AppColors.lightMint,
          ),
          const SizedBox(width: 6),
          Text(context.l10n.lowTemp(low), style: _valueStyle),
        ],
      ),
    );
  }

  static const TextStyle _valueStyle = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );
}

class _CloudCoverTile extends StatelessWidget {
  const _CloudCoverTile({required this.cover});

  final int cover;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      padding: const EdgeInsets.symmetric(vertical: 18),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withValues(alpha: 0.14)),
      ),
      child: Column(
        children: <Widget>[
          const SizedBox(
            width: 62,
            height: 48,
            child: Stack(
              children: <Widget>[
                PositionedDirectional(
                  top: 0,
                  end: 8,
                  child: Icon(
                    Icons.wb_sunny_rounded,
                    size: 30,
                    color: AppColors.sunOrange,
                  ),
                ),
                PositionedDirectional(
                  bottom: 0,
                  start: 2,
                  child: Icon(
                    Icons.cloud_outlined,
                    size: 30,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Text(
            context.l10n.cloudCoverPct(cover),
            style: TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w500,
              color: Colors.white.withValues(alpha: 0.78),
            ),
          ),
        ],
      ),
    );
  }
}

class _FooterLine extends StatelessWidget {
  const _FooterLine({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Icon(icon, size: 17, color: Colors.white.withValues(alpha: 0.9)),
        const SizedBox(width: 9),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.white.withValues(alpha: 0.92),
            ),
          ),
        ),
      ],
    );
  }
}
