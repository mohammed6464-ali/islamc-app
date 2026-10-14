import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/app_info.dart';
import '../../../core/l10n/app_copy.dart';
import '../../../core/l10n/app_language.dart';
import '../../../core/legal/app_legal.dart';
import '../../../core/navigation/app_routes.dart';
import '../../../core/prayer/prayer_calc_method.dart';
import '../../../core/state/app_scope.dart';
import '../../../core/state/app_state.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_feedback.dart';
import '../../../core/widgets/app_screen_header.dart';
import '../../../core/widgets/app_toggle.dart';
import 'widgets/settings_tile.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AppState state = AppScope.of(context);
    final copy = AppCopy(context.l10n);
    final l10n = copy.l10n;

    return Column(
      children: <Widget>[
        SafeArea(
          bottom: false,
          child: AppScreenHeader(
            leading: HeaderIconButton(
              icon: Icons.location_on_outlined,
              tooltip: l10n.changeCity,
              onPressed: () =>
                  Navigator.of(context).pushNamed(AppRoutes.currentLocation),
            ),
            title: copy.cityFullName(state.city),
            titleColor: AppColors.textSecondary,
            titleSize: 12,
            actions: <Widget>[
              HeaderIconButton(
                icon: Icons.explore_outlined,
                tooltip: l10n.qiblaDirection,
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
              const _SettingsIntro(),
              const SizedBox(height: 22),
              _GroupLabel(
                label: l10n.prayerAndAlerts,
                icon: Icons.notifications_active_outlined,
              ),
              const SizedBox(height: 11),
              SettingsGroup(
                children: <Widget>[
                  SettingsTile(
                    icon: Icons.volume_up_outlined,
                    title: l10n.prayerNotifications,
                    subtitle: l10n.prayerNotificationsSubtitle,
                    onTap: () => Navigator.of(
                      context,
                    ).pushNamed(AppRoutes.prayerNotifications),
                  ),
                  SettingsTile(
                    icon: Icons.calculate_outlined,
                    title: l10n.calculationMethod,
                    subtitle: l10n.calculationMethodSubtitle,
                    value: copy.calcMethod(state.calculationMethodEnum),
                    valuePill: true,
                    onTap: () async {
                      final String? picked = await showOptionPicker(
                        context,
                        title: l10n.calculationMethod,
                        options: copy.calcMethodLabels,
                        selected: copy.calcMethod(state.calculationMethodEnum),
                      );
                      if (picked == null) {
                        return;
                      }
                      final int index = copy.calcMethodLabels.indexOf(picked);
                      if (index >= 0) {
                        state.setCalculationMethodEnum(
                          PrayerCalcMethod.values[index],
                        );
                      }
                    },
                  ),
                  SettingsTile(
                    icon: Icons.event_note_outlined,
                    title: l10n.eventAlerts,
                    subtitle: l10n.eventAlertsSubtitle,
                    trailing: AppToggle(
                      value: state.eventAlerts,
                      onChanged: state.setEventAlerts,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 22),
              _GroupLabel(
                label: l10n.locationAndWeather,
                icon: Icons.near_me_outlined,
              ),
              const SizedBox(height: 11),
              SettingsGroup(
                children: <Widget>[
                  SettingsTile(
                    icon: Icons.apartment_rounded,
                    title: l10n.currentCity,
                    subtitle: state.autoDetectLocation
                        ? l10n.currentCitySubtitleAuto
                        : l10n.currentCitySubtitleManual,
                    value: copy.cityName(state.city),
                    onTap: () => Navigator.of(
                      context,
                    ).pushNamed(AppRoutes.currentLocation),
                  ),
                  SettingsTile(
                    icon: Icons.gps_fixed_rounded,
                    title: l10n.useDeviceLocation,
                    subtitle: l10n.useDeviceLocationSubtitle,
                    trailing: AppToggle(
                      value: state.autoDetectLocation,
                      onChanged: (bool value) async {
                        await state.setAutoDetectLocation(value);
                        if (!context.mounted) {
                          return;
                        }
                        final next = AppCopy(context.l10n);
                        if (value && state.locationError != null) {
                          showAppMessage(
                            context,
                            next.locationFailure(state.locationError!),
                          );
                          return;
                        }
                        showAppMessage(
                          context,
                          value ? next.l10n.gpsEnabled : next.l10n.gpsManual,
                        );
                      },
                    ),
                  ),
                  SettingsTile(
                    icon: Icons.thermostat_rounded,
                    title: l10n.temperatureUnit,
                    subtitle: l10n.temperatureUnitSubtitle,
                    value: state.temperatureUnitLabelFor(copy),
                    valuePill: true,
                    onTap: () {
                      state.setUseFahrenheit(!state.useFahrenheit);
                      showAppMessage(
                        context,
                        context.l10n.unitAdopted(
                          state.temperatureUnitNameFor(AppCopy(context.l10n)),
                        ),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 22),
              _GroupLabel(
                label: l10n.appearance,
                icon: Icons.palette_outlined,
              ),
              const SizedBox(height: 11),
              SettingsGroup(
                children: <Widget>[
                  SettingsTile(
                    icon: Icons.calendar_view_month_outlined,
                    title: l10n.calendarDisplay,
                    subtitle: l10n.calendarDisplaySubtitle,
                    value: state.hijriView ? l10n.hijri : l10n.gregorian,
                    valuePill: true,
                    onTap: () {
                      state.setHijriView(!state.hijriView);
                      showAppMessage(
                        context,
                        state.hijriView
                            ? context.l10n.hijriAdopted
                            : context.l10n.gregorianAdopted,
                      );
                    },
                  ),
                  SettingsTile(
                    icon: Icons.dark_mode_outlined,
                    title: l10n.darkMode,
                    subtitle: l10n.darkModeSubtitle,
                    trailing: AppToggle(
                      value: state.darkMode,
                      onChanged: (bool value) {
                        state.setDarkMode(value);
                        showAppMessage(
                          context,
                          value
                              ? context.l10n.darkModeOn
                              : context.l10n.darkModeOff,
                        );
                      },
                    ),
                  ),
                  SettingsTile(
                    icon: Icons.translate_rounded,
                    title: l10n.language,
                    subtitle: l10n.languageSubtitle,
                    value: state.isEnglish
                        ? l10n.languageEnglish
                        : l10n.languageArabic,
                    onTap: () async {
                      final String? picked = await showOptionPicker(
                        context,
                        title: l10n.language,
                        options: <String>[
                          l10n.languageArabic,
                          l10n.languageEnglish,
                        ],
                        selected: state.isEnglish
                            ? l10n.languageEnglish
                            : l10n.languageArabic,
                      );
                      if (picked == null) {
                        return;
                      }
                      final bool english = picked == l10n.languageEnglish;
                      state.setLanguage(
                        english ? AppLanguage.english : AppLanguage.arabic,
                      );
                      if (!context.mounted) {
                        return;
                      }
                      final next = AppCopy.forCode(
                        english ? AppLanguage.english : AppLanguage.arabic,
                      );
                      showAppMessage(
                        context,
                        next.l10n.languageChanged(
                          english
                              ? next.l10n.languageEnglish
                              : next.l10n.languageArabic,
                        ),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 22),
              _GroupLabel(
                label: l10n.aboutSection,
                icon: Icons.info_outline_rounded,
              ),
              const SizedBox(height: 11),
              SettingsGroup(
                children: <Widget>[
                  SettingsTile(
                    icon: Icons.explore_rounded,
                    iconBackground: AppColors.primary,
                    iconForeground: AppColors.surface,
                    title: l10n.aboutApp,
                    subtitle: AppLegal.appName,
                    onTap: () => _showAbout(context),
                  ),
                  SettingsTile(
                    icon: Icons.shield_outlined,
                    title: l10n.privacyPolicy,
                    onTap: () => _showMissingLegal(
                      context,
                      title: l10n.privacyPolicy,
                      body: l10n.privacyBody,
                    ),
                  ),
                  SettingsTile(
                    icon: Icons.gavel_rounded,
                    title: l10n.terms,
                    onTap: () => _showMissingLegal(
                      context,
                      title: l10n.terms,
                      body: l10n.termsBody,
                    ),
                  ),
                  SettingsTile(
                    icon: Icons.mail_outline_rounded,
                    title: l10n.contactUs,
                    onTap: () => showAppMessage(
                      context,
                      l10n.contactUnavailable,
                    ),
                  ),
                  SettingsTile(
                    icon: Icons.star_outline_rounded,
                    title: l10n.rateApp,
                    onTap: () => showAppMessage(
                      context,
                      l10n.rateUnavailable,
                    ),
                  ),
                  SettingsTile(
                    icon: Icons.share_outlined,
                    title: l10n.shareApp,
                    onTap: () {
                      SharePlus.instance.share(
                        ShareParams(
                          text: '${AppLegal.appName}\n${context.l10n.homeTagline}',
                        ),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 26),
              const _VersionFooter(),
            ],
          ),
        ),
      ],
    );
  }

  static void _showAbout(BuildContext context) {
    final l10n = context.l10n;
    showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          l10n.aboutApp,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        content: Text(
          '${AppLegal.appName}\n${l10n.appVersionLabel(AppLegal.appName, AppInfo.version)}\n\n'
          '${l10n.aboutBody}',
          style: const TextStyle(
            fontSize: 13,
            color: AppColors.textSecondary,
            height: 1.8,
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(
              l10n.ok,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  static void _showMissingLegal(
    BuildContext context, {
    required String title,
    required String body,
  }) {
    showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        content: Text(
          body,
          style: const TextStyle(
            fontSize: 13,
            color: AppColors.textSecondary,
            height: 1.8,
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(
              context.l10n.ok,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsIntro extends StatelessWidget {
  const _SettingsIntro();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                l10n.settings,
                style: const TextStyle(
                  fontSize: 27,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                l10n.settingsIntro,
                style: const TextStyle(
                  fontSize: 11.5,
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Container(
          width: 44,
          height: 44,
          decoration: const BoxDecoration(
            color: AppColors.pillGray,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.tune_rounded,
            size: 21,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}

class _GroupLabel extends StatelessWidget {
  const _GroupLabel({required this.label, required this.icon});

  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Icon(icon, size: 18, color: AppColors.primary),
        const SizedBox(width: 9),
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}

class _VersionFooter extends StatelessWidget {
  const _VersionFooter();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(
          context.l10n.appVersionLabel(AppLegal.appName, AppInfo.version),
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          context.l10n.homeTagline,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
        ),
      ],
    );
  }
}
