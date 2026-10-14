import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/adhan/adhan_audio_catalog.dart';
import '../../../core/data/demo_data.dart';
import '../../../core/data/models.dart';
import '../../../core/l10n/app_copy.dart';
import '../../../core/l10n/app_language.dart';
import '../../../core/state/app_scope.dart';
import '../../../core/state/app_state.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_feedback.dart';
import '../../../core/widgets/app_screen_header.dart';
import '../../../core/widgets/app_toggle.dart';
import '../../../core/widgets/common_widgets.dart';
import 'widgets/adhan_trial_card.dart';
import 'widgets/settings_tile.dart';

class PrayerNotificationsScreen extends StatelessWidget {
  const PrayerNotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AppState state = AppScope.of(context);
    final AppCopy copy = AppCopy(context.l10n);
    final String mosqueLabel = copy.mosque(state.adhanMosque);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: AppColors.background,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: SafeArea(
          bottom: false,
          child: Column(
            children: <Widget>[
              AppScreenHeader(
                leading: const HeaderBackButton(),
                title: context.l10n.prayerNotifications,
                actions: <Widget>[
                  HeaderIconButton(
                    icon: Icons.notifications_active_outlined,
                    tooltip: context.l10n.adhanPreview,
                    circled: true,
                    onPressed: () => showAppMessage(
                      context,
                      context.l10n.adhanPreviewHint,
                    ),
                  ),
                ],
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                  physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics(),
                  ),
                  children: <Widget>[
                    const _MasterCard(),
                    const SizedBox(height: 14),
                    const _PrayerList(),
                    const SizedBox(height: 14),
                    const _PreAlertCard(),
                    const SizedBox(height: 14),
                    SettingsGroup(
                      children: <Widget>[
                        SettingsTile(
                          icon: Icons.volume_up_outlined,
                          title: context.l10n.adhanSound,
                          subtitle: mosqueLabel,
                          onTap: () async {
                            final List<String> options = <String>[
                              for (final AdhanMosque mosque
                                  in AdhanMosque.values)
                                copy.mosque(mosque),
                            ];
                            final String? picked = await showOptionPicker(
                              context,
                              title: context.l10n.adhanSound,
                              options: options,
                              selected: mosqueLabel,
                            );
                            if (picked == null) return;
                            final int index = options.indexOf(picked);
                            if (index >= 0) {
                              state.setAdhanMosque(AdhanMosque.values[index]);
                            }
                            if (!context.mounted) return;
                            showAppMessage(
                              context,
                              context.l10n.adhanSoundPicked(picked),
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    const AdhanTrialCard(),
                    if (kDebugMode) ...<Widget>[
                      const SizedBox(height: 14),
                      const _TestNotificationCard(),
                    ],
                    const SizedBox(height: 14),
                    InfoNote(
                      icon: Icons.info_outline_rounded,
                      text:
                          '${context.l10n.prayerNotifyNote}'
                          '${state.notificationPermissionMessage == null ? '' : ' ${state.notificationPermissionMessage}'}',
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 10),
                child: PrimaryButton(
                  label: context.l10n.savePreferences,
                  icon: Icons.check_rounded,
                  onPressed: () async {
                    final bool allowed = await state
                        .requestNotificationPermission();
                    await state.resyncNotifications();
                    if (!context.mounted) {
                      return;
                    }
                    showAppMessage(
                      context,
                      allowed
                          ? context.l10n.prefsSaved
                          : (state.notificationPermissionMessage ??
                                context.l10n.prefsBlocked),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MasterCard extends StatelessWidget {
  const _MasterCard();

  @override
  Widget build(BuildContext context) {
    final AppState state = AppScope.of(context);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.mintTint,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: <Widget>[
          const IconTile.mint(Icons.notifications_none_rounded, size: 46, iconSize: 23),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  context.l10n.enableAllPrayerAlerts,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  context.l10n.receiveAdhanAll,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          AppToggle(
            value: state.masterPrayerAlerts,
            onChanged: state.setMasterPrayerAlerts,
          ),
        ],
      ),
    );
  }
}

class _PrayerList extends StatelessWidget {
  const _PrayerList();

  @override
  Widget build(BuildContext context) {
    final AppState state = AppScope.of(context);
    final List<PrayerTime> prayers = state.prayerTimes;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Column(
          children: <Widget>[
            Container(
              color: AppColors.background,
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
              child: Row(
                children: <Widget>[
                  Text(
                    context.l10n.dailyPrayerTimes,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const Spacer(),
                  AppBadge(
                    '${prayers.length} ${context.l10n.prayerTimes}',
                    fontSize: 10,
                  ),
                ],
              ),
            ),
            for (final PrayerTime prayer in prayers) ...<Widget>[
              const CardDivider(),
              _PrayerAlertRow(prayer: prayer),
            ],
          ],
        ),
      ),
    );
  }
}

class _PrayerAlertRow extends StatelessWidget {
  const _PrayerAlertRow({required this.prayer});

  final PrayerTime prayer;

  @override
  Widget build(BuildContext context) {
    final AppState state = AppScope.of(context);
    final AppCopy copy = AppCopy(context.l10n);
    final bool on = state.rawAlertFor(prayer.id);
    final bool isNext = prayer.isNext;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
      child: Row(
        children: <Widget>[
          IconTile(
            prayer.icon,
            size: 44,
            iconSize: 21,
            background: isNext ? AppColors.mint : AppColors.pillGray,
            foreground: prayer.supportsAlert
                ? AppColors.primary
                : AppColors.goldDeep,
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
                        copy.prayerLongName(prayer.id),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                          height: 1.3,
                        ),
                      ),
                    ),
                    if (isNext) ...<Widget>[
                      const SizedBox(width: 8),
                      AppBadge(
                        context.l10n.upcomingShort,
                        background: AppColors.mintStrong,
                        fontSize: 9.5,
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  copy.timeWithPeriod(prayer),
                  textDirection: TextDirection.ltr,
                  style: const TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Text(
            on ? context.l10n.enabled : context.l10n.disabled,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: on ? AppColors.accentGreen : AppColors.textMuted,
            ),
          ),
          const SizedBox(width: 10),
          AppToggle(
            value: on,
            enabled: state.masterPrayerAlerts,
            onChanged: (bool value) => state.setPrayerAlert(prayer.id, value),
          ),
        ],
      ),
    );
  }
}

class _PreAlertCard extends StatelessWidget {
  const _PreAlertCard();

  @override
  Widget build(BuildContext context) {
    final AppState state = AppScope.of(context);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(13, 14, 13, 13),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: SectionTitle(
                title: context.l10n.preAlertTime,
                icon: Icons.timer_outlined,
              ),
            ),
            const SizedBox(height: 12),
            const CardDivider(indent: 2),
            const SizedBox(height: 10),
            for (final int minutes in DemoData.preAlertOptions) ...<Widget>[
              _PreAlertOption(
                minutes: minutes,
                selected: state.preAlertMinutes == minutes,
              ),
              if (minutes != DemoData.preAlertOptions.last)
                const SizedBox(height: 8),
            ],
          ],
        ),
      ),
    );
  }
}

class _PreAlertOption extends StatelessWidget {
  const _PreAlertOption({required this.minutes, required this.selected});

  final int minutes;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final AppState state = AppScope.read(context);

    return Material(
      color: selected ? AppColors.mintTint : AppColors.surface,
      borderRadius: BorderRadius.circular(13),
      child: InkWell(
        borderRadius: BorderRadius.circular(13),
        onTap: () => state.setPreAlertMinutes(minutes),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(13),
            border: Border.all(
              color: selected ? AppColors.mintBorder : AppColors.border,
            ),
          ),
          child: Row(
            children: <Widget>[
              AppRadio(selected: selected),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  AppCopy(context.l10n).preAlertLabel(minutes),
                  style: const TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              if (minutes == 0)
                AppBadge(
                  context.l10n.defaultLabel,
                  background: AppColors.mintStrong,
                  fontSize: 9.5,
                )
              else
                Text(
                  '${minutes}m',
                  textDirection: TextDirection.ltr,
                  style: const TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textMuted,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TestNotificationCard extends StatelessWidget {
  const _TestNotificationCard();

  @override
  Widget build(BuildContext context) {
    final AppState state = AppScope.of(context);
    final DateTime? scheduled = state.lastTestNotificationAt;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(13, 14, 13, 13),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SectionTitle(
              title: context.l10n.testNotification,
              icon: Icons.notification_add_outlined,
            ),
            const SizedBox(height: 8),
            Text(
              context.l10n.testNotificationBody,
              style: const TextStyle(
                fontSize: 12,
                height: 1.55,
                color: AppColors.textSecondary,
              ),
            ),
            if (scheduled != null) ...<Widget>[
              const SizedBox(height: 8),
              Text(
                context.l10n.notificationAt(
                  '${scheduled.hour.toString().padLeft(2, '0')}:'
                  '${scheduled.minute.toString().padLeft(2, '0')}',
                ),
                style: const TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
            ],
            const SizedBox(height: 12),
            PrimaryButton(
              label: context.l10n.scheduleTest,
              icon: Icons.schedule_send_outlined,
              height: 46,
              onPressed: () async {
                final DateTime? at = await state.scheduleTestNotification();
                if (!context.mounted) {
                  return;
                }
                if (at == null) {
                  showAppMessage(
                    context,
                    state.notificationPermissionMessage ??
                        context.l10n.testFailed,
                  );
                  return;
                }
                showAppMessage(
                  context,
                  context.l10n.testScheduled,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
