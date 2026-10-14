import 'package:flutter/material.dart';

import '../l10n/app_language.dart';
import '../theme/app_colors.dart';

class CustomBottomNavigation extends StatelessWidget {
  const CustomBottomNavigation({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final List<_NavItem> items = <_NavItem>[
      _NavItem(l10n.navHome, Icons.home_outlined),
      _NavItem(l10n.navWeather, Icons.wb_sunny_outlined),
      _NavItem(l10n.navCalendar, Icons.calendar_month_outlined),
      _NavItem(l10n.navSettings, Icons.settings_outlined),
    ];
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: Theme.of(context).brightness == Brightness.dark
                ? AppColors.darkBorder
                : AppColors.divider,
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 66,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
            child: Row(
              children: <Widget>[
                for (int i = 0; i < items.length; i++)
                  Expanded(
                    child: _NavButton(
                      item: items[i],
                      selected: i == currentIndex,
                      onTap: () => onTap(i),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  const _NavItem(this.label, this.icon);

  final String label;
  final IconData icon;
}

class _NavButton extends StatelessWidget {
  const _NavButton({
    required this.item,
    required this.selected,
    required this.onTap,
  });

  final _NavItem item;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final Color contentColor =
        selected ? AppColors.primary : AppColors.textPrimary;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 6),
        decoration: selected
            ? BoxDecoration(
                color: AppColors.mintStrong,
                borderRadius: BorderRadius.circular(16),
              )
            : null,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(item.icon, size: 21, color: contentColor),
            const SizedBox(height: 4),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                item.label,
                maxLines: 1,
                style: TextStyle(
                  fontSize: 10.5,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                  color: contentColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
