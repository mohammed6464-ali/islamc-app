import 'package:flutter/material.dart';

import '../../../../core/l10n/app_copy.dart';
import '../../../../core/l10n/app_language.dart';
import '../../../../core/navigation/app_routes.dart';
import '../../../../core/navigation/main_shell.dart';
import '../../../../core/state/app_scope.dart';
import '../../../../core/theme/app_colors.dart';

/// Top bar: location on the start side, notifications + settings on the end.
class HomeTopBar extends StatelessWidget {
  const HomeTopBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
      child: Row(
        children: <Widget>[
          Expanded(
            child: InkWell(
              onTap: () =>
                  Navigator.of(context).pushNamed(AppRoutes.currentLocation),
              child: Row(
                children: <Widget>[
                  const Icon(
                    Icons.location_on_outlined,
                    size: 18,
                    color: AppColors.textPrimary,
                  ),
                  const SizedBox(width: 7),
                  Flexible(
                    child: Text(
                      AppCopy(context.l10n).cityFullName(AppScope.of(context).city),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 2),
                  const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    size: 17,
                    color: AppColors.textSecondary,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 10),
          const _NotificationBell(),
          const SizedBox(width: 14),
          IconButton(
            tooltip: context.l10n.settings,
            visualDensity: VisualDensity.compact,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
            onPressed: () => MainShell.goToTab(context, 3),
            icon: const Icon(
              Icons.settings_outlined,
              size: 20,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class _NotificationBell extends StatelessWidget {
  const _NotificationBell();

  @override
  Widget build(BuildContext context) {
    final bool hasUnread = AppScope.of(context).hasUnreadNotifications;

    return Semantics(
      button: true,
      label: context.l10n.notifications,
      child: InkResponse(
        radius: 22,
        onTap: () => Navigator.of(context).pushNamed(AppRoutes.notifications),
        child: SizedBox(
          width: 22,
          height: 22,
          child: Stack(
            clipBehavior: Clip.none,
            children: <Widget>[
              const Align(
                alignment: Alignment.bottomCenter,
                child: Icon(
                  Icons.notifications_none_rounded,
                  size: 21,
                  color: AppColors.textPrimary,
                ),
              ),
              if (hasUnread)
                Positioned.directional(
                  textDirection: Directionality.of(context),
                  top: -2,
                  end: 0,
                  child: Container(
                    width: 7,
                    height: 7,
                    decoration: const BoxDecoration(
                      color: AppColors.notificationDot,
                      shape: BoxShape.circle,
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

/// Greeting row with the profile tile and the timezone pill.
class HomeGreeting extends StatelessWidget {
  const HomeGreeting({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: AppColors.pillGray,
            borderRadius: BorderRadius.circular(14),
          ),
          alignment: Alignment.center,
          child: const Icon(
            Icons.person_outline_rounded,
            size: 21,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                context.l10n.welcome,
                style: TextStyle(
                  fontSize: 10.5,
                  fontWeight: FontWeight.w400,
                  color: AppColors.textSecondary,
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                context.l10n.homeTagline,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                  height: 1.35,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 10),
        const _TimezonePill(),
      ],
    );
  }
}

class _TimezonePill extends StatelessWidget {
  const _TimezonePill();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
      decoration: BoxDecoration(
        color: AppColors.pillGray,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const _GreenDot(),
          const SizedBox(width: 6),
          Text(
            context.l10n.timezoneOf(
              AppCopy(context.l10n).cityName(AppScope.of(context).city),
            ),
            style: const TextStyle(
              fontSize: 10.5,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class _GreenDot extends StatelessWidget {
  const _GreenDot();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 6,
      height: 6,
      decoration: const BoxDecoration(
        color: AppColors.primary,
        shape: BoxShape.circle,
      ),
    );
  }
}
