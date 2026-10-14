import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';

import '../../../core/l10n/app_copy.dart';
import '../../../core/l10n/app_language.dart';
import '../../../core/navigation/app_routes.dart';
import '../../../core/navigation/main_shell.dart';
import '../../../core/qibla/compass_sensor.dart';
import '../../../core/qibla/qibla_calculation_service.dart';
import '../../../core/state/app_scope.dart';
import '../../../core/state/app_state.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_feedback.dart';
import '../../../core/widgets/app_screen_header.dart';
import '../../../core/widgets/common_widgets.dart';
import '../../../core/widgets/custom_bottom_navigation.dart';
import 'widgets/qibla_compass.dart';

class QiblaScreen extends StatefulWidget {
  const QiblaScreen({super.key, this.compassSensor});

  final CompassSensor? compassSensor;

  @override
  State<QiblaScreen> createState() => _QiblaScreenState();
}

class _QiblaScreenState extends State<QiblaScreen>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  late final AnimationController _controller;
  late final Animation<double> _entry;
  late final CompassSensor _sensor;

  StreamSubscription<CompassReading>? _subscription;
  Ticker? _headingTicker;
  CompassReading _reading = const CompassReading.unavailable();
  double? _displayHeading;
  double? _targetHeading;
  double _lastLat = 0;
  double _lastLng = 0;

  static const QiblaCalculationService _qibla = QiblaCalculationService();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _sensor = widget.compassSensor ?? FlutterCompassSensor();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _entry = CurvedAnimation(parent: _controller, curve: Curves.easeOutBack);
    _controller.forward();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final AppState state = AppScope.of(context);
    _subscribeIfLocationChanged(state);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      final AppState appState = AppScope.of(context);
      _subscribe(appState.location.latitude, appState.location.longitude);
    } else if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused) {
      _unsubscribe();
    }
  }

  void _subscribeIfLocationChanged(AppState state) {
    final double lat = state.location.latitude;
    final double lng = state.location.longitude;
    if (_subscription != null && lat == _lastLat && lng == _lastLng) {
      return;
    }
    _subscribe(lat, lng);
  }

  void _subscribe(double latitude, double longitude) {
    _unsubscribe();
    _lastLat = latitude;
    _lastLng = longitude;
    try {
      _subscription = _sensor
          .headings(latitude: latitude, longitude: longitude)
          .listen(_onReading, onError: (_) {
            if (!mounted) {
              return;
            }
            setState(() {
              _reading = const CompassReading.unavailable();
              _targetHeading = null;
              _displayHeading = null;
            });
          });
    } catch (_) {
      _reading = const CompassReading.unavailable();
    }
  }

  void _onReading(CompassReading reading) {
    if (!mounted) {
      return;
    }
    _reading = reading;
    if (!reading.hasHeading) {
      _targetHeading = null;
      _displayHeading = null;
      _headingTicker?.stop();
      setState(() {});
      return;
    }
    _targetHeading = reading.trueHeading;
    _headingTicker ??= createTicker(_tickHeading)..start();
    if (_headingTicker?.isTicking == false) {
      _headingTicker!.start();
    }
  }

  void _tickHeading(Duration _) {
    final double? target = _targetHeading;
    if (!mounted || target == null) {
      return;
    }
    setState(() {
      if (_displayHeading == null) {
        _displayHeading = target;
        return;
      }
      _displayHeading = QiblaCalculationService.lerpAngle(
        _displayHeading!,
        target,
        0.18,
      );
    });
  }

  void _unsubscribe() {
    _subscription?.cancel();
    _subscription = null;
    _headingTicker?.stop();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _unsubscribe();
    _headingTicker?.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AppState state = AppScope.of(context);
    _subscribeIfLocationChanged(state);
    final QiblaResult qibla = _qibla.calculate(
      latitude: state.location.latitude,
      longitude: state.location.longitude,
    );

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: AppColors.surface,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: SafeArea(
          bottom: false,
          child: Column(
            children: <Widget>[
              AppScreenHeader(
                leading: const HeaderBackButton(),
                title: context.l10n.qiblaDirection,
                actions: <Widget>[
                  HeaderIconButton(
                    icon: Icons.explore_outlined,
                    tooltip: context.l10n.qiblaCalibrate,
                    onPressed: () {
                      _controller
                        ..reset()
                        ..forward();
                      showAppMessage(
                        context,
                        AppCopy(context.l10n).compassMessage(_reading.accuracy) ??
                            context.l10n.qiblaCalibrateBody,
                      );
                    },
                  ),
                ],
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
                  physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics(),
                  ),
                  children: <Widget>[
                    const Center(child: _LocationPill()),
                    const SizedBox(height: 12),
                    Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          const Icon(
                            Icons.near_me_outlined,
                            size: 15,
                            color: AppColors.textSecondary,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            context.l10n.distanceToMakkah(qibla.distanceKm),
                            style: const TextStyle(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 22),
                    AnimatedBuilder(
                      animation: _entry,
                      builder: (BuildContext context, _) => QiblaCompass(
                        qiblaAngle: qibla.bearing,
                        heading: _displayHeading,
                        progress: _entry.value.clamp(0.0, 1.0),
                      ),
                    ),
                    const SizedBox(height: 22),
                    _QiblaResultCard(qibla: qibla, reading: _reading),
                    const SizedBox(height: 12),
                    InfoNote(
                      icon: Icons.screen_rotation_outlined,
                      text: AppCopy(context.l10n).compassMessage(_reading.accuracy) ??
                          context.l10n.holdPhoneFlat,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        // The reference shows the bar here with no destination highlighted.
        bottomNavigationBar: CustomBottomNavigation(
          currentIndex: -1,
          onTap: (int index) => MainShell.goToTab(context, index),
        ),
      ),
    );
  }
}

class _LocationPill extends StatelessWidget {
  const _LocationPill();

  @override
  Widget build(BuildContext context) {
    final AppState state = AppScope.of(context);

    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(24),
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: () =>
            Navigator.of(context).pushNamed(AppRoutes.currentLocation),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 11),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Icon(
                Icons.location_on_outlined,
                size: 17,
                color: AppColors.primary,
              ),
              const SizedBox(width: 9),
              Flexible(
                child: Text(
                  AppCopy(context.l10n).cityFullName(state.city),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
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

class _QiblaResultCard extends StatelessWidget {
  const _QiblaResultCard({required this.qibla, required this.reading});

  final QiblaResult qibla;
  final CompassReading reading;

  @override
  Widget build(BuildContext context) {
    final AppState state = AppScope.of(context);
    final AppCopy copy = AppCopy(context.l10n);
    final Color accuracyColor = switch (reading.accuracy) {
      CompassAccuracy.high || CompassAccuracy.medium => AppColors.accentGreen,
      CompassAccuracy.low || CompassAccuracy.uncalibrated =>
        AppColors.sunOrange,
      CompassAccuracy.unavailable || CompassAccuracy.unknown =>
        AppColors.textMuted,
    };

    return AppCard(
      radius: 18,
      padding: const EdgeInsets.all(13),
      child: Row(
        children: <Widget>[
          const IconTile.mint(Icons.explore_outlined, size: 48, iconSize: 24),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: AlignmentDirectional.centerStart,
                  child: Text(
                    copy.qiblaLabel(
                      qibla.bearing,
                      atKaaba: qibla.distanceKm < 2,
                    ),
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                      height: 1.25,
                    ),
                  ),
                ),
                const SizedBox(height: 3),
                Row(
                  children: <Widget>[
                    Dot(size: 6, color: accuracyColor),
                    const SizedBox(width: 7),
                    Flexible(
                      child: Text(
                        context.l10n.compassAccuracy(
                          copy.compassAccuracy(reading.accuracy),
                        ),
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w600,
                          color: accuracyColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            tooltip: context.l10n.qiblaMethodTitle,
            visualDensity: VisualDensity.compact,
            onPressed: () => showAppMessage(
              context,
              context.l10n.qiblaMethodBody(
                reading.declinationApplied ? context.l10n.declinationNote : '',
                copy.calcMethod(state.calculationMethodEnum),
              ),
            ),
            icon: const IconTile(
              Icons.tune_rounded,
              size: 40,
              radius: 13,
              foreground: AppColors.textPrimary,
              iconSize: 19,
            ),
          ),
        ],
      ),
    );
  }
}
