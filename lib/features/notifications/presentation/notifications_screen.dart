import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/data/demo_data.dart';
import '../../../core/data/models.dart';
import '../../../core/navigation/app_routes.dart';
import '../../../core/state/app_scope.dart';
import '../../../core/state/app_state.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_feedback.dart';
import '../../../core/widgets/app_screen_header.dart';
import '../../../core/widgets/common_widgets.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AppState state = AppScope.of(context);
    final List<String> groups = <String>{
      for (final AppNotification n in DemoData.notifications) n.group,
    }.toList(growable: false);

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
                title: 'الإشعارات',
                actions: <Widget>[_MarkAllButton(state: state)],
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                  physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics(),
                  ),
                  children: <Widget>[
                    for (final String group in groups) ...<Widget>[
                      _GroupHeader(
                        label: group,
                        trailing: group == 'اليوم' ? 'تحديث فوري' : null,
                      ),
                      const SizedBox(height: 10),
                      for (final AppNotification notification
                          in DemoData.notifications.where(
                            (AppNotification n) => n.group == group,
                          )) ...<Widget>[
                        _NotificationCard(notification: notification),
                        const SizedBox(height: 10),
                      ],
                      const SizedBox(height: 10),
                    ],
                    const SizedBox(height: 8),
                    const _CustomizeCard(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MarkAllButton extends StatelessWidget {
  const _MarkAllButton({required this.state});

  final AppState state;

  @override
  Widget build(BuildContext context) {
    final bool enabled = state.hasUnreadNotifications;

    return TextButton.icon(
      onPressed: enabled
          ? () {
              state.markAllNotificationsRead();
              showAppMessage(context, 'تم تحديد جميع الإشعارات كمقروءة.');
            }
          : null,
      icon: Icon(
        Icons.done_all_rounded,
        size: 18,
        color: enabled ? AppColors.primary : AppColors.textMuted,
      ),
      label: Text(
        'تحديد الكل',
        style: TextStyle(
          fontSize: 12.5,
          fontWeight: FontWeight.w600,
          color: enabled ? AppColors.primary : AppColors.textMuted,
        ),
      ),
    );
  }
}

class _GroupHeader extends StatelessWidget {
  const _GroupHeader({required this.label, this.trailing});

  final String label;
  final String? trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        const Dot(size: 6, color: AppColors.textPrimary),
        const SizedBox(width: 9),
        Text(
          label,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        const Spacer(),
        if (trailing != null)
          Text(
            trailing!,
            style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
          ),
      ],
    );
  }
}

class _NotificationCard extends StatelessWidget {
  const _NotificationCard({required this.notification});

  final AppNotification notification;

  @override
  Widget build(BuildContext context) {
    final AppState state = AppScope.of(context);
    final bool unread = !state.isNotificationRead(notification.id);

    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          state.markNotificationRead(notification.id);
          _openTarget(context, notification);
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: AppColors.textPrimary.withValues(alpha: 0.025),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: IntrinsicHeight(
              child: Row(
                children: <Widget>[
                  if (unread)
                    Container(width: 4, color: AppColors.primary)
                  else
                    const SizedBox(width: 4),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(13),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          _ToneAvatar(tone: notification.tone, icon: notification.icon),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Expanded(
                                      child: Text(
                                        notification.title,
                                        style: const TextStyle(
                                          fontSize: 14.5,
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.textPrimary,
                                          height: 1.35,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    if (unread)
                                      AppBadge(
                                        notification.timeLabel,
                                        fontSize: 9.5,
                                      )
                                    else
                                      Padding(
                                        padding: const EdgeInsets.only(top: 2),
                                        child: Text(
                                          notification.timeLabel,
                                          style: const TextStyle(
                                            fontSize: 10.5,
                                            color: AppColors.textMuted,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  state.notificationBody(notification),
                                  style: const TextStyle(
                                    fontSize: 11.5,
                                    color: AppColors.textSecondary,
                                    height: 1.6,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  static void _openTarget(BuildContext context, AppNotification notification) {
    switch (notification.id) {
      case 'dhuhr-adhan':
        Navigator.of(context).pushNamed(AppRoutes.prayerTimes);
      case 'national-day-soon':
        Navigator.of(context).pushNamed(
          AppRoutes.eventDetails,
          arguments: DemoData.featuredEvent.id,
        );
      case 'times-updated':
        Navigator.of(context).pushNamed(AppRoutes.currentLocation);
    }
  }
}

class _ToneAvatar extends StatelessWidget {
  const _ToneAvatar({required this.tone, required this.icon});

  final NotificationTone tone;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final (Color background, Color foreground) = switch (tone) {
      NotificationTone.mint => (AppColors.mint, AppColors.primary),
      NotificationTone.amber => (AppColors.amberIcon, AppColors.goldDeep),
      NotificationTone.neutral => (AppColors.pillGray, AppColors.textSecondary),
    };

    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(color: background, shape: BoxShape.circle),
      child: Icon(icon, size: 21, color: foreground),
    );
  }
}

class _CustomizeCard extends StatelessWidget {
  const _CustomizeCard();

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () =>
            Navigator.of(context).pushNamed(AppRoutes.prayerNotifications),
        child: const AppCard(
          radius: 16,
          padding: EdgeInsets.all(13),
          child: Row(
            children: <Widget>[
              IconTile(Icons.tune_rounded, iconSize: 21),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'تخصيص الإشعارات والتنبيهات',
                      style: TextStyle(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                        height: 1.3,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'تحكم في نغمة الأذان وتنبيهات المناسبات',
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.textSecondary,
                        height: 1.45,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 8),
              Icon(Icons.chevron_right, size: 21, color: AppColors.textMuted),
            ],
          ),
        ),
      ),
    );
  }
}
