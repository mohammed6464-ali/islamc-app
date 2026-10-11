import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/data/demo_data.dart';
import '../../../core/data/models.dart';
import '../../../core/state/app_scope.dart';
import '../../../core/state/app_state.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_feedback.dart';
import '../../../core/widgets/app_screen_header.dart';
import '../../../core/widgets/app_toggle.dart';
import '../../../core/widgets/common_widgets.dart';
import 'widgets/settings_tile.dart';

class PrayerNotificationsScreen extends StatelessWidget {
  const PrayerNotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AppState state = AppScope.of(context);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: AppColors.background,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          bottom: false,
          child: Column(
            children: <Widget>[
              AppScreenHeader(
                leading: const HeaderBackButton(),
                title: 'تنبيهات الصلاة',
                actions: <Widget>[
                  HeaderIconButton(
                    icon: Icons.notifications_active_outlined,
                    tooltip: 'معاينة التنبيه',
                    circled: true,
                    onPressed: () => showAppMessage(
                      context,
                      'معاينة الأذان غير متاحة — لا يوجد صوت في النسخة '
                      'التجريبية.',
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
                          title: 'صوت الأذان والتكبير',
                          subtitle: state.adhanSound,
                          onTap: () async {
                            final String? picked = await showOptionPicker(
                              context,
                              title: 'صوت الأذان والتكبير',
                              options: DemoData.adhanSounds,
                              selected: state.adhanSound,
                            );
                            if (picked == null) return;
                            state.setAdhanSound(picked);
                            if (!context.mounted) return;
                            showAppMessage(
                              context,
                              'تم اختيار «$picked» — لا يوجد تشغيل صوتي فعلي '
                              'بعد.',
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    const InfoNote(
                      icon: Icons.info_outline_rounded,
                      text:
                          'يتم احتساب المواقيت وفق تقويم أم القرى بمكة '
                          'المكرمة. يتم ضبط التنبيهات بدقة تلقائياً عند تغير '
                          'موقعك الجغرافي.',
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 10),
                child: PrimaryButton(
                  label: 'حفظ التفضيلات',
                  icon: Icons.check_rounded,
                  onPressed: () => showAppMessage(
                    context,
                    'تم حفظ التفضيلات محليًا — لا توجد جدولة إشعارات حقيقية.',
                  ),
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
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'تفعيل تنبيهات الصلوات كافة',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                    height: 1.3,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'تلقي نداء الأذان والإشعارات لجميع الأوقات',
                  style: TextStyle(
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
                  const Text(
                    'مواقيت الصلوات اليومية',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const Spacer(),
                  AppBadge('${prayers.length} مواقيت', fontSize: 10),
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
                        prayer.supportsAlert ? prayer.longName : 'وقت الشروق',
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
                      const AppBadge(
                        'القادمة',
                        background: AppColors.mintStrong,
                        fontSize: 9.5,
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  prayer.timeWithPeriod,
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
            on ? 'مفعل' : 'غير مفعل',
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
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 2),
              child: SectionTitle(
                title: 'وقت التنبيه المسبق',
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
                  DemoData.preAlertLabel(minutes),
                  style: const TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              if (minutes == 0)
                const AppBadge(
                  'الافتراضي',
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
