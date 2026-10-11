import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Pill switch used by every settings row. In RTL the knob slides to the
/// visual left when the switch is on, matching the reference screens.
class AppToggle extends StatelessWidget {
  const AppToggle({
    super.key,
    required this.value,
    required this.onChanged,
    this.enabled = true,
  });

  final bool value;
  final ValueChanged<bool> onChanged;
  final bool enabled;

  static const double _width = 46;
  static const double _height = 26;
  static const double _knob = 20;

  @override
  Widget build(BuildContext context) {
    final bool on = value && enabled;

    return Semantics(
      toggled: value,
      enabled: enabled,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: enabled ? () => onChanged(!value) : null,
        child: Opacity(
          opacity: enabled ? 1 : 0.5,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOut,
            width: _width,
            height: _height,
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              color: on ? AppColors.primaryDark : AppColors.toggleOff,
              borderRadius: BorderRadius.circular(_height / 2),
            ),
            child: AnimatedAlign(
              duration: const Duration(milliseconds: 180),
              curve: Curves.easeOut,
              alignment: on
                  ? AlignmentDirectional.centerEnd
                  : AlignmentDirectional.centerStart,
              child: Container(
                width: _knob,
                height: _knob,
                decoration: const BoxDecoration(
                  color: AppColors.surface,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Filled circle radio used by the pre-alert options.
class AppRadio extends StatelessWidget {
  const AppRadio({super.key, required this.selected});

  final bool selected;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 160),
      width: 22,
      height: 22,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: selected ? AppColors.primaryDark : Colors.transparent,
        border: Border.all(
          color: selected ? AppColors.primaryDark : const Color(0xFFCBD2CD),
          width: 2,
        ),
      ),
      child: selected
          ? Center(
              child: Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: AppColors.surface,
                  shape: BoxShape.circle,
                ),
              ),
            )
          : null,
    );
  }
}
