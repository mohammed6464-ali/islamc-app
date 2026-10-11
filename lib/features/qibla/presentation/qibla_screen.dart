import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/navigation/app_routes.dart';
import '../../../core/navigation/main_shell.dart';
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
  const QiblaScreen({super.key});

  @override
  State<QiblaScreen> createState() => _QiblaScreenState();
}

class _QiblaScreenState extends State<QiblaScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _entry;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _entry = CurvedAnimation(parent: _controller, curve: Curves.easeOutBack);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AppState state = AppScope.of(context);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: AppColors.surface,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          bottom: false,
          child: Column(
            children: <Widget>[
              AppScreenHeader(
                leading: const HeaderBackButton(),
                title: 'اتجاه القبلة',
                actions: <Widget>[
                  HeaderIconButton(
                    icon: Icons.explore_outlined,
                    tooltip: 'إعادة المعايرة',
                    onPressed: () {
                      _controller
                        ..reset()
                        ..forward();
                      showAppMessage(
                        context,
                        'تمت إعادة معايرة البوصلة (عرض تجريبي بدون مستشعرات).',
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
                            'المسافة إلى مكة المكرمة: '
                            '${state.city.distanceToMakkah} كم',
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
                        qiblaAngle: state.city.qiblaAngle.toDouble(),
                        progress: _entry.value.clamp(0.0, 1.0),
                      ),
                    ),
                    const SizedBox(height: 22),
                    const _QiblaResultCard(),
                    const SizedBox(height: 12),
                    const InfoNote(
                      icon: Icons.screen_rotation_outlined,
                      text:
                          'ضع الهاتف بشكل أفقي على سطح مستوٍ للحصول على قراءة '
                          'أكثر دقة.',
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
                  state.city.fullName,
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
  const _QiblaResultCard();

  @override
  Widget build(BuildContext context) {
    final AppState state = AppScope.of(context);

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
                    state.city.qiblaLabel,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                      height: 1.25,
                    ),
                  ),
                ),
                const SizedBox(height: 3),
                const Row(
                  children: <Widget>[
                    Dot(size: 6, color: AppColors.accentGreen),
                    SizedBox(width: 7),
                    Text(
                      'دقة البوصلة: ممتازة',
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w600,
                        color: AppColors.accentGreen,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            tooltip: 'طريقة الحساب',
            visualDensity: VisualDensity.compact,
            onPressed: () => showAppMessage(
              context,
              'طريقة الحساب المعتمدة: ${state.calculationMethod}.',
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
