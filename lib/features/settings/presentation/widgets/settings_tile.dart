import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/common_widgets.dart';

/// Row of the settings list: icon tile, title + subtitle, then either a
/// value, a chevron or a trailing control.
class SettingsTile extends StatelessWidget {
  const SettingsTile({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.value,
    this.valuePill = false,
    this.trailing,
    this.onTap,
    this.iconBackground = AppColors.pillGray,
    this.iconForeground = AppColors.primary,
  });

  final IconData icon;
  final String title;
  final String? subtitle;

  /// Shown just before the chevron (`الرياض`, `العربية`).
  final String? value;

  /// Renders [value] inside a grey pill instead of plain green text.
  final bool valuePill;
  final Widget? trailing;
  final VoidCallback? onTap;
  final Color iconBackground;
  final Color iconForeground;

  @override
  Widget build(BuildContext context) {
    final Widget content = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
      child: Row(
        children: <Widget>[
          IconTile(
            icon,
            size: 42,
            radius: 13,
            iconSize: 20,
            background: iconBackground,
            foreground: iconForeground,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                    height: 1.3,
                  ),
                ),
                if (subtitle != null) ...<Widget>[
                  const SizedBox(height: 2),
                  Text(
                    subtitle!,
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.textSecondary,
                      height: 1.5,
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 10),
          if (value != null) ...<Widget>[
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 120),
              child: valuePill
                  ? AppBadge(
                      value!,
                      background: AppColors.pillGray,
                      foreground: AppColors.textSecondary,
                      fontSize: 11,
                      radius: 11,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 7,
                      ),
                    )
                  : Text(
                      value!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.end,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
            ),
            const SizedBox(width: 6),
          ],
          if (trailing != null)
            trailing!
          else if (onTap != null)
            const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16,
              color: AppColors.textMuted,
            ),
        ],
      ),
    );

    if (onTap == null) return content;

    return Material(
      color: Colors.transparent,
      child: InkWell(onTap: onTap, child: content),
    );
  }
}

/// White rounded container that groups a set of [SettingsTile]s.
class SettingsGroup extends StatelessWidget {
  const SettingsGroup({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surface,
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
        child: Column(
          children: <Widget>[
            for (int i = 0; i < children.length; i++) ...<Widget>[
              if (i > 0) const CardDivider(indent: 14),
              children[i],
            ],
          ],
        ),
      ),
    );
  }
}
