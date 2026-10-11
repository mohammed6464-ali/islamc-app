import 'package:flutter/material.dart';

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
                    color: Color(0xFF1B3931),
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
                            Color(0xFF6FD3AC),
                            Color(0xFF9BF0CB),
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
          'جاري ضبط المواقيت حسب إحداثيات موقعك...',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 12.5,
            fontWeight: FontWeight.w400,
            color: AppColors.mintText.withValues(alpha: 0.95),
          ),
        ),
        const SizedBox(height: 22),
        const Text(
          'بيانات فلكية موثقة وفق تقويم أم القرى',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: AppColors.goldText,
          ),
        ),
        const SizedBox(height: 20),
        Text(
          'الإصدار 1.0.0',
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
