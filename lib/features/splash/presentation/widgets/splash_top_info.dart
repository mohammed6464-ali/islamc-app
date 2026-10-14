import 'package:flutter/material.dart';

import '../../../../core/l10n/app_copy.dart';
import '../../../../core/l10n/app_language.dart';
import '../../../../core/state/app_scope.dart';
import '../../../../core/theme/app_colors.dart';

/// The two outlined pills pinned to the top of the splash screen:
/// the location on the right, the Hijri year on the left.
class SplashTopInfo extends StatelessWidget {
  const SplashTopInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Flexible(child: _LocationPill()),
        const SizedBox(width: 12),
        _HijriPill(),
      ],
    );
  }
}

class _LocationPill extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 34,
      padding: const EdgeInsetsDirectional.only(start: 12, end: 14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(17),
        border: Border.all(color: Colors.white.withValues(alpha: 0.14)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Icon(Icons.location_on, size: 14, color: AppColors.gold),
          const SizedBox(width: 7),
          Flexible(
            child: Text(
              _locationLabel(context),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w500,
                color: Colors.white.withValues(alpha: 0.92),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

String _locationLabel(BuildContext context) {
  final copy = AppCopy(context.l10n);
  final state = AppScope.of(context);
  final city = copy.cityNameFromId(
    state.location.catalogId,
    state.location.cityName,
  );
  return '${copy.l10n.countrySaudi} • $city';
}

String _toEasternDigits(String value) {
  const String western = '0123456789';
  const String eastern = '٠١٢٣٤٥٦٧٨٩';
  return String.fromCharCodes(
    value.codeUnits.map((int unit) {
      final int index = western.codeUnits.indexOf(unit);
      return index >= 0 ? eastern.codeUnitAt(index) : unit;
    }),
  );
}

class _HijriPill extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          height: 34,
          padding: const EdgeInsets.symmetric(horizontal: 13),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(17),
            border: Border.all(color: Colors.white.withValues(alpha: 0.14)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                width: 6,
                height: 6,
                decoration: const BoxDecoration(
                  color: AppColors.gold,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 7),
              Text(
                AppLanguage.isEnglish(AppScope.of(context).languageCode)
                    ? '${AppScope.of(context).hijriToday.year}'
                    : _toEasternDigits(
                        '${AppScope.of(context).hijriToday.year}',
                      ),
                style: const TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                  color: AppColors.goldText,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 2),
        Text(
          AppLanguage.isEnglish(AppScope.of(context).languageCode) ? 'AH' : 'هـ',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: AppColors.goldText,
          ),
        ),
      ],
    );
  }
}
