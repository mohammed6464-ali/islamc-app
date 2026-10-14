import 'package:flutter/material.dart';

import '../l10n/app_language.dart';
import '../theme/app_colors.dart';

/// Top bar shared by the detail screens: a leading control, a right aligned
/// title block, then the action icons on the opposite edge.
class AppScreenHeader extends StatelessWidget {
  const AppScreenHeader({
    super.key,
    this.leading,
    this.title,
    this.subtitle,
    this.titleColor = AppColors.primary,
    this.titleSize = 17,
    this.actions = const <Widget>[],
    this.showDivider = true,
  });

  final Widget? leading;
  final String? title;
  final String? subtitle;
  final Color titleColor;
  final double titleSize;
  final List<Widget> actions;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(14, 8, 14, 12),
          child: Row(
            children: <Widget>[
              if (leading != null) ...<Widget>[
                leading!,
                const SizedBox(width: 10),
              ],
              if (title != null)
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        title!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: titleSize,
                          fontWeight: FontWeight.w700,
                          color: titleColor,
                          height: 1.25,
                        ),
                      ),
                      if (subtitle != null)
                        Text(
                          subtitle!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w400,
                            color: AppColors.textSecondary,
                            height: 1.4,
                          ),
                        ),
                    ],
                  ),
                )
              else
                const Spacer(),
              for (final Widget action in actions) ...<Widget>[
                const SizedBox(width: 6),
                action,
              ],
            ],
          ),
        ),
        if (showDivider)
          const Divider(height: 1, thickness: 1, color: AppColors.divider),
      ],
    );
  }
}

/// `>` chevron that returns to the previous screen (RTL back affordance).
class HeaderBackButton extends StatelessWidget {
  const HeaderBackButton({super.key, this.boxed = false, this.onPressed});

  final bool boxed;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final Widget icon = const Icon(
      Icons.arrow_back,
      size: 24,
      color: AppColors.textPrimary,
    );

    return _HeaderTapTarget(
      onPressed: onPressed ?? () => Navigator.of(context).maybePop(),
      tooltip: context.l10n.back,
      boxed: boxed,
      child: icon,
    );
  }
}

/// Round/boxed icon button used for the header actions.
class HeaderIconButton extends StatelessWidget {
  const HeaderIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    required this.tooltip,
    this.boxed = false,
    this.circled = false,
    this.color = AppColors.textPrimary,
  });

  final IconData icon;
  final VoidCallback onPressed;
  final String tooltip;
  final bool boxed;
  final bool circled;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return _HeaderTapTarget(
      onPressed: onPressed,
      tooltip: tooltip,
      boxed: boxed,
      circled: circled,
      child: Icon(icon, size: 21, color: color),
    );
  }
}

class _HeaderTapTarget extends StatelessWidget {
  const _HeaderTapTarget({
    required this.child,
    required this.onPressed,
    required this.tooltip,
    this.boxed = false,
    this.circled = false,
  });

  final Widget child;
  final VoidCallback onPressed;
  final String tooltip;
  final bool boxed;
  final bool circled;

  @override
  Widget build(BuildContext context) {
    final BorderRadius radius = BorderRadius.circular(circled ? 21 : 13);

    return Tooltip(
      message: tooltip,
      child: Material(
        color: boxed || circled ? AppColors.pillGray : Colors.transparent,
        borderRadius: radius,
        child: InkWell(
          borderRadius: radius,
          onTap: onPressed,
          child: SizedBox(width: 42, height: 42, child: Center(child: child)),
        ),
      ),
    );
  }
}
