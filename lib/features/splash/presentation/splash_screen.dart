import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/l10n/app_language.dart';
import '../../../core/navigation/app_routes.dart';
import '../../../core/state/app_scope.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/islamic_geometric_pattern.dart';
import 'widgets/splash_loading_section.dart';
import 'widgets/splash_top_info.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  static const Duration _sequence = Duration(milliseconds: 2900);
  static const Duration _holdAfterProgress = Duration(milliseconds: 250);

  late final AnimationController _controller;
  late final Animation<double> _patternFade;
  late final Animation<double> _pillsFade;
  late final Animation<double> _pillsSlide;
  late final Animation<double> _titleFade;
  late final Animation<double> _titleScale;
  late final Animation<double> _taglineFade;
  late final Animation<double> _taglineSlide;
  late final Animation<double> _badgeFade;
  late final Animation<double> _progress;

  Timer? _exitTimer;
  bool _navigated = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: _sequence)
      ..addStatusListener(_onSequenceStatus);

    // Interval bounds below are milliseconds / 2900.
    _patternFade = _fade(0.0, 0.172);
    _pillsFade = _fade(0.069, 0.241);
    _pillsSlide = Tween<double>(begin: -14, end: 0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.069, 0.241, curve: Curves.easeOutCubic),
      ),
    );
    _titleFade = _fade(0.138, 0.310);
    _titleScale = Tween<double>(begin: 0.96, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.138, 0.310, curve: Curves.easeOutCubic),
      ),
    );
    _taglineFade = _fade(0.207, 0.362);
    _taglineSlide = Tween<double>(begin: 10, end: 0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.207, 0.362, curve: Curves.easeOutCubic),
      ),
    );
    _badgeFade = _fade(0.259, 0.397);

    _progress = TweenSequence<double>(<TweenSequenceItem<double>>[
      _step(0.0, 0.25),
      _step(0.25, 0.55),
      _step(0.55, 0.80),
      _step(0.80, 1.0),
    ]).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.310, 1.0)),
    );

    _controller.forward();
  }

  Animation<double> _fade(double begin, double end) {
    return CurvedAnimation(
      parent: _controller,
      curve: Interval(begin, end, curve: Curves.easeOut),
    );
  }

  TweenSequenceItem<double> _step(double begin, double end) {
    return TweenSequenceItem<double>(
      tween: Tween<double>(begin: begin, end: end)
          .chain(CurveTween(curve: Curves.easeInOut)),
      weight: 1,
    );
  }

  void _onSequenceStatus(AnimationStatus status) {
    if (status != AnimationStatus.completed || _navigated) {
      return;
    }
    _exitTimer = Timer(_holdAfterProgress, _goToLocationScreen);
  }

  void _goToLocationScreen() {
    if (_navigated || !mounted) {
      return;
    }
    _navigated = true;
    final String next = AppScope.read(context).onboardingComplete
        ? AppRoutes.shell
        : AppRoutes.locationPermission;
    Navigator.of(context).pushReplacementNamed(next);
  }

  @override
  void dispose() {
    _exitTimer?.cancel();
    _controller.removeStatusListener(_onSequenceStatus);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: AppColors.splashGradient.last,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        body: DecoratedBox(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: AppColors.splashGradient,
              stops: AppColors.splashGradientStops,
            ),
          ),
          child: Stack(
            children: <Widget>[
              Positioned.fill(
                child: FadeTransition(
                  opacity: _patternFade,
                  child: const IslamicGeometricPattern(),
                ),
              ),
              SafeArea(
                child: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 22),
                      child: Column(
                        children: <Widget>[
                          const SizedBox(height: 14),
                          AnimatedBuilder(
                            animation: _controller,
                            builder: (BuildContext context, Widget? child) {
                              return Opacity(
                                opacity: _pillsFade.value,
                                child: Transform.translate(
                                  offset: Offset(0, _pillsSlide.value),
                                  child: child,
                                ),
                              );
                            },
                            child: const SplashTopInfo(),
                          ),
                          const Spacer(flex: 47),
                          _BrandBlock(
                            titleFade: _titleFade,
                            titleScale: _titleScale,
                            taglineFade: _taglineFade,
                            taglineSlide: _taglineSlide,
                            badgeFade: _badgeFade,
                          ),
                          const Spacer(flex: 53),
                          SplashLoadingSection(progress: _progress),
                          const SizedBox(height: 40),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BrandBlock extends StatelessWidget {
  const _BrandBlock({
    required this.titleFade,
    required this.titleScale,
    required this.taglineFade,
    required this.taglineSlide,
    required this.badgeFade,
  });

  final Animation<double> titleFade;
  final Animation<double> titleScale;
  final Animation<double> taglineFade;
  final Animation<double> taglineSlide;
  final Animation<double> badgeFade;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        FadeTransition(
          opacity: titleFade,
          child: ScaleTransition(
            scale: titleScale,
            child: Text(
              context.l10n.appName,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                height: 1.25,
                letterSpacing: 0,
              ),
            ),
          ),
        ),
        const SizedBox(height: 6),
        AnimatedBuilder(
          animation: taglineFade,
          builder: (BuildContext context, Widget? child) {
            return Opacity(
              opacity: taglineFade.value,
              child: Transform.translate(
                offset: Offset(0, taglineSlide.value),
                child: child,
              ),
            );
          },
          child: Text(
            context.l10n.splashTagline,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.w500,
              color: AppColors.goldText,
              height: 1.4,
            ),
          ),
        ),
        const SizedBox(height: 22),
        FadeTransition(opacity: badgeFade, child: const _UmmAlQuraBadge()),
      ],
    );
  }
}

class _UmmAlQuraBadge extends StatelessWidget {
  const _UmmAlQuraBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsetsDirectional.only(
        start: 14,
        end: 18,
        top: 9,
        bottom: 9,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.gold.withValues(alpha: 0.42)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            width: 18,
            height: 18,
            decoration: const BoxDecoration(
              color: AppColors.gold,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: const Icon(Icons.star, size: 11, color: AppColors.darkGreen),
          ),
          const SizedBox(width: 9),
          Flexible(
            child: Text(
              context.l10n.splashCompanion,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Colors.white.withValues(alpha: 0.94),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
