import 'package:flutter/material.dart';

import '../../../../core/app_info.dart';
import '../../../../core/l10n/app_language.dart';
import '../../../../core/legal/app_legal.dart';
import '../../../../core/theme/app_colors.dart';

/// Progress bar plus the three stacked status lines at the bottom of the
/// splash screen.
class SplashLoadingSection extends StatelessWidget {
  const SplashLoadingSection({super.key, required this.progress});

  final Animation<double> progress;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        FractionallySizedBox(
          widthFactor: 0.49,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: SizedBox(
              height: 5,
              child: Stack(
                children: <Widget>[
                  const ColoredBox(
                    color: AppColors.darkGreen,
                    child: SizedBox.expand(),
                  ),
                  AnimatedBuilder(
                    animation: progress,
                    builder: (BuildContext context, Widget? child) {
                      return FractionallySizedBox(
                        alignment: AlignmentDirectional.centerStart,
                        widthFactor: progress.value.clamp(0.0, 1.0),
                        child: child,
                      );
                    },
                    child: const DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: <Color>[
                            AppColors.lightMint,
                            AppColors.mintSoft,
                          ],
                        ),
                      ),
                      child: SizedBox.expand(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 26),
        Text(
          context.l10n.splashLoadingTimes,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 12.5,
            fontWeight: FontWeight.w400,
            color: AppColors.mintText.withValues(alpha: 0.95),
          ),
        ),
        const SizedBox(height: 22),
        Text(
          context.l10n.splashAstronomical,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: AppColors.goldText,
          ),
        ),
        const SizedBox(height: 20),
        Text(
          context.l10n.appVersionLabel(AppLegal.appName, AppInfo.version),
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w400,
            color: Colors.white.withValues(alpha: 0.32),
          ),
        ),
      ],
    );
  }
}
