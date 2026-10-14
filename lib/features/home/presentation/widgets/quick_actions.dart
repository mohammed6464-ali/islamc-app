import 'package:flutter/material.dart';

import '../../../../core/l10n/app_language.dart';
import '../../../../core/navigation/app_routes.dart';
import '../../../../core/navigation/main_shell.dart';
import '../../../../core/state/app_scope.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_card.dart';

class QuickActionsRow extends StatelessWidget {
  const QuickActionsRow({super.key});

  @override
  Widget build(BuildContext context) {
    final List<QuickActionCard> actions = <QuickActionCard>[
      QuickActionCard(
        label: context.l10n.qiblaDirection,
        icon: Icons.explore_outlined,
        circleColor: AppColors.mint,
        iconColor: AppColors.primary,
        onTap: () => Navigator.of(context).pushNamed(AppRoutes.qibla),
      ),
      QuickActionCard(
        label: context.l10n.calendar,
        icon: Icons.calendar_month_outlined,
        circleColor: AppColors.iconCircleGray,
        onTap: () => MainShell.goToTab(context, 2),
      ),
      QuickActionCard(
        label: context.l10n.weather,
        icon: Icons.wb_sunny_outlined,
        circleColor: AppColors.iconCircleNeutral,
        onTap: () => MainShell.goToTab(context, 1),
      ),
      QuickActionCard(
        label: context.l10n.occasions,
        icon: Icons.flag_outlined,
        circleColor: AppColors.amberIcon,
        onTap: () {
          final String? id = AppScope.of(context).featuredEvent?.id;
          if (id == null) {
            MainShell.goToTab(context, 2);
            return;
          }
          Navigator.of(context).pushNamed(
            AppRoutes.eventDetails,
            arguments: id,
          );
        },
      ),
    ];

    return Row(
      children: <Widget>[
        for (int i = 0; i < actions.length; i++) ...<Widget>[
          if (i != 0) const SizedBox(width: 11),
          Expanded(child: actions[i]),
        ],
      ],
    );
  }
}

class QuickActionCard extends StatelessWidget {
  const QuickActionCard({
    super.key,
    required this.label,
    required this.icon,
    required this.circleColor,
    required this.onTap,
    this.iconColor = AppColors.textPrimary,
  });

  final String label;
  final IconData icon;
  final Color circleColor;
  final VoidCallback onTap;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: AppCard(
      radius: 18,
      padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 6),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(color: circleColor, shape: BoxShape.circle),
            alignment: Alignment.center,
            child: Icon(icon, size: 21, color: iconColor),
          ),
          const SizedBox(height: 10),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              label,
              maxLines: 1,
              style: const TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
      ),
    );
  }
}
