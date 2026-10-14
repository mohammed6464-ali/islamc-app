import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Rounded-square icon container that precedes almost every row and card
/// title in the designs.
class IconTile extends StatelessWidget {
  const IconTile(
    this.icon, {
    super.key,
    this.size = 44,
    this.radius = 14,
    this.background = AppColors.pillGray,
    this.foreground = AppColors.primary,
    this.iconSize,
  });

  const IconTile.mint(
    IconData icon, {
    Key? key,
    double size = 44,
    double radius = 14,
    double? iconSize,
  }) : this(
         icon,
         key: key,
         size: size,
         radius: radius,
         background: AppColors.mint,
         foreground: AppColors.primary,
         iconSize: iconSize,
       );

  const IconTile.dark(
    IconData icon, {
    Key? key,
    double size = 44,
    double radius = 14,
    double? iconSize,
  }) : this(
         icon,
         key: key,
         size: size,
         radius: radius,
         background: AppColors.primary,
         foreground: AppColors.surface,
         iconSize: iconSize,
       );

  const IconTile.amber(
    IconData icon, {
    Key? key,
    double size = 44,
    double radius = 14,
    double? iconSize,
  }) : this(
         icon,
         key: key,
         size: size,
         radius: radius,
         background: AppColors.amberBg,
         foreground: AppColors.goldDeep,
         iconSize: iconSize,
       );

  final IconData icon;
  final double size;
  final double radius;
  final Color background;
  final Color foreground;
  final double? iconSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(radius),
      ),
      child: Icon(icon, size: iconSize ?? size * 0.46, color: foreground),
    );
  }
}

/// Small rounded label (`الحالي`, `مناسبة وطنية`, `6 مواقيت`, ...).
class AppBadge extends StatelessWidget {
  const AppBadge(
    this.label, {
    super.key,
    this.background = AppColors.mint,
    this.foreground = AppColors.primary,
    this.fontSize = 10.5,
    this.fontWeight = FontWeight.w600,
    this.padding = const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
    this.radius = 9,
  });

  final String label;
  final Color background;
  final Color foreground;
  final double fontSize;
  final FontWeight fontWeight;
  final EdgeInsetsGeometry padding;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(radius),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: foreground,
          height: 1.3,
        ),
      ),
    );
  }
}

/// Full-width dark-green call to action.
class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.height = 52,
    this.radius = 15,
  });

  final String label;
  final VoidCallback onPressed;
  final IconData? icon;
  final double height;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: height,
      child: Material(
        color: AppColors.accentGreen,
        borderRadius: BorderRadius.circular(radius),
        child: InkWell(
          borderRadius: BorderRadius.circular(radius),
          onTap: onPressed,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              if (icon != null) ...<Widget>[
                Icon(icon, size: 19, color: AppColors.surface),
                const SizedBox(width: 10),
              ],
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.surface,
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

/// `مؤشرات الطقس الآن` ........ `دقة لحظية`
class SectionTitle extends StatelessWidget {
  const SectionTitle({
    super.key,
    required this.title,
    this.icon,
    this.trailing,
    this.titleColor = AppColors.textPrimary,
  });

  final String title;
  final IconData? icon;
  final String? trailing;
  final Color titleColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        if (icon != null) ...<Widget>[
          Icon(icon, size: 17, color: AppColors.primary),
          const SizedBox(width: 8),
        ],
        Expanded(
          child: Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: titleColor,
              height: 1.3,
            ),
          ),
        ),
        if (trailing != null) ...<Widget>[
          const SizedBox(width: 10),
          Text(
            trailing!,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.end,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: AppColors.textMuted,
            ),
          ),
        ],
      ],
    );
  }
}

/// Soft grey callout used at the bottom of several screens.
class InfoNote extends StatelessWidget {
  const InfoNote({
    super.key,
    required this.icon,
    required this.text,
    this.title,
    this.background = AppColors.pillGray,
    this.iconColor = AppColors.primary,
  });

  final IconData icon;
  final String text;
  final String? title;
  final Color background;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(14, 13, 14, 13),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(icon, size: 17, color: iconColor),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                if (title != null) ...<Widget>[
                  Text(
                    title!,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 3),
                ],
                Text(
                  text,
                  style: const TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textSecondary,
                    height: 1.55,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Small bullet used before `الصلاة القادمة` / `دقة البوصلة: ممتازة`.
class Dot extends StatelessWidget {
  const Dot({super.key, this.size = 6, this.color = AppColors.primary});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}

/// Thin separator inside cards.
class CardDivider extends StatelessWidget {
  const CardDivider({super.key, this.indent = 0});

  final double indent;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.only(start: indent, end: indent),
      child: const Divider(height: 1, thickness: 1, color: AppColors.divider),
    );
  }
}
