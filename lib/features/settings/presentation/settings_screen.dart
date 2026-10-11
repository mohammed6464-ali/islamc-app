import 'package:flutter/material.dart';

import '../../../core/data/demo_data.dart';
import '../../../core/navigation/app_routes.dart';
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
            title: state.city.fullName,
            titleColor: AppColors.textSecondary,
            titleSize: 12,
            actions: <Widget>[
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
              const _SettingsIntro(),
              const SizedBox(height: 22),
              const _GroupLabel(
                label: 'الصلاة والتنبيهات',
                icon: Icons.notifications_active_outlined,
              ),
              const SizedBox(height: 11),
              SettingsGroup(
                children: <Widget>[
                  SettingsTile(
                    icon: Icons.volume_up_outlined,
                    title: 'تنبيهات الصلاة والأذان',
                    subtitle: 'تخصيص الأذان وصوت التنبيه لكل فريضة',
                    onTap: () => Navigator.of(
                      context,
                    ).pushNamed(AppRoutes.prayerNotifications),
                  ),
                  SettingsTile(
                    icon: Icons.calculate_outlined,
                    title: 'طريقة حساب المواقيت',
                    subtitle: 'المعتمد في حساب أوقات الفرائض',
                    value: state.calculationMethod,
                    valuePill: true,
                    onTap: () async {
                      final String? picked = await showOptionPicker(
                        context,
                        title: 'طريقة حساب المواقيت',
                        options: DemoData.calculationMethods,
                        selected: state.calculationMethod,
                      );
                      if (picked != null) state.setCalculationMethod(picked);
                    },
                  ),
                  SettingsTile(
                    icon: Icons.event_note_outlined,
                    title: 'تنبيهات المناسبات والتقويم',
                    subtitle: 'الأيام البيض، صيام عاشوراء، والأعياد المباركة',
                    trailing: AppToggle(
                      value: state.eventAlerts,
                      onChanged: state.setEventAlerts,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 22),
              const _GroupLabel(
                label: 'الموقع والطقس',
                icon: Icons.near_me_outlined,
              ),
              const SizedBox(height: 11),
              SettingsGroup(
                children: <Widget>[
                  SettingsTile(
                    icon: Icons.apartment_rounded,
                    title: 'المدينة الحالية',
                    subtitle: 'تحديد الموقع لحساب القبلة والطقس بدقة',
                    value: state.city.name,
                    onTap: () => Navigator.of(
                      context,
                    ).pushNamed(AppRoutes.currentLocation),
                  ),
                  SettingsTile(
                    icon: Icons.thermostat_rounded,
                    title: 'وحدة قياس درجة الحرارة',
                    subtitle: 'عرض درجات الحرارة في شاشات الطقس',
                    value: state.temperatureUnitLabel,
                    valuePill: true,
                    onTap: () {
                      state.setUseFahrenheit(!state.useFahrenheit);
                      showAppMessage(
                        context,
                        'تم اعتماد وحدة ${state.temperatureUnitName}.',
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 22),
              const _GroupLabel(
                label: 'المظهر واللغة',
                icon: Icons.palette_outlined,
              ),
              const SizedBox(height: 11),
              SettingsGroup(
                children: <Widget>[
                  SettingsTile(
                    icon: Icons.dark_mode_outlined,
                    title: 'الوضع الداكن',
                    subtitle: 'تقليل الإضاءة لراحة العين أثناء الليل',
                    trailing: AppToggle(
                      value: state.darkMode,
                      onChanged: (bool value) {
                        state.setDarkMode(value);
                        showAppMessage(
                          context,
                          value
                              ? 'الوضع الداكن مُفعّل كتفضيل — الثيم الداكن لم '
                                    'يُنفّذ بعد.'
                              : 'تم إيقاف الوضع الداكن.',
                        );
                      },
                    ),
                  ),
                  SettingsTile(
                    icon: Icons.translate_rounded,
                    title: 'لغة التطبيق',
                    subtitle: 'واجهة المستخدم والمواقيت',
                    value: state.language,
                    onTap: () async {
                      final String? picked = await showOptionPicker(
                        context,
                        title: 'لغة التطبيق',
                        options: DemoData.languages,
                        selected: state.language,
                      );
                      if (picked == null) return;
                      state.setLanguage(picked);
                      if (!context.mounted) return;
                      showAppMessage(
                        context,
                        'تم حفظ التفضيل — الترجمة الكاملة غير متوفرة بعد.',
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 22),
              const _GroupLabel(
                label: 'عن التطبيق',
                icon: Icons.info_outline_rounded,
              ),
              const SizedBox(height: 11),
              SettingsGroup(
                children: <Widget>[
                  SettingsTile(
                    icon: Icons.explore_rounded,
                    iconBackground: AppColors.primary,
                    iconForeground: AppColors.surface,
                    title: 'حول التطبيق',
                    subtitle: 'رسالتنا في خدمة المجتمع وسكان المملكة',
                    onTap: () => _showAbout(context),
                  ),
                  SettingsTile(
                    icon: Icons.shield_outlined,
                    title: 'سياسة الخصوصية',
                    onTap: () => showAppMessage(
                      context,
                      'التطبيق لا يجمع أي بيانات — كل المحتوى تجريبي محلي.',
                    ),
                  ),
                  SettingsTile(
                    icon: Icons.gavel_rounded,
                    title: 'الشروط والأحكام',
                    onTap: () => showAppMessage(
                      context,
                      'الشروط والأحكام ستتوفر في الإصدار النهائي.',
                    ),
                  ),
                  SettingsTile(
                    icon: Icons.star_outline_rounded,
                    title: 'تقييم التطبيق',
                    onTap: () => showAppMessage(
                      context,
                      'التقييم غير متاح قبل النشر على المتجر.',
                    ),
                  ),
                  SettingsTile(
                    icon: Icons.share_outlined,
                    title: 'مشاركة التطبيق',
                    onTap: () => showAppMessage(
                      context,
                      'المشاركة غير مفعّلة في النسخة التجريبية.',
                    ),
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
    showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text(
          'حول التطبيق',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        content: const Text(
          'مواقيتنا تطبيق تجريبي لعرض مواقيت الصلاة والقبلة والطقس والتقويم '
          'الهجري. جميع البيانات في هذه النسخة ثابتة ولا تعتمد على أي خدمة '
          'خارجية.',
          style: TextStyle(
            fontSize: 13,
            color: AppColors.textSecondary,
            height: 1.8,
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text(
              'حسنًا',
              style: TextStyle(
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
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'الإعدادات',
                style: TextStyle(
                  fontSize: 27,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                  height: 1.3,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'تخصيص مواقيت الصلاة، التنبيهات، وتفضيلات التطبيق',
                style: TextStyle(
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
    return const Column(
      children: <Widget>[
        Text(
          DemoData.appVersion,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
          ),
        ),
        SizedBox(height: 5),
        Text(
          DemoData.appTagline,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 11, color: AppColors.textMuted),
        ),
      ],
    );
  }
}
