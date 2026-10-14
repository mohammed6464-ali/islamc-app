import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/l10n/app_copy.dart';
import '../../../core/l10n/app_language.dart';
import '../../../core/navigation/app_routes.dart';
import '../../../core/state/app_scope.dart';
import '../../../core/theme/app_colors.dart';

class LocationPermissionScreen extends StatefulWidget {
  const LocationPermissionScreen({super.key});

  @override
  State<LocationPermissionScreen> createState() =>
      _LocationPermissionScreenState();
}

class _LocationPermissionScreenState extends State<LocationPermissionScreen> {
  bool _busy = false;

  Future<void> _openHome() async {
    await AppScope.read(context).completeOnboarding();
    if (!mounted) {
      return;
    }
    Navigator.of(context).pushReplacementNamed(AppRoutes.shell);
  }

  Future<void> _allowLocation() async {
    if (_busy) {
      return;
    }
    setState(() => _busy = true);
    final bool ok = await AppScope.read(context).requestCurrentLocation();
    if (!mounted) {
      return;
    }
    setState(() => _busy = false);
    if (ok) {
      await _openHome();
      return;
    }
    final copy = AppCopy(context.l10n);
    final failure = AppScope.read(context).locationError;
    final String message = failure != null
        ? copy.locationFailure(failure)
        : copy.l10n.locationFailed;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppColors.primary,
          content: Text(
            message,
            style: const TextStyle(
              fontFamily: 'IBMPlexSansArabic',
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      );
  }

  void _openManualCity() {
    Navigator.of(context).pushNamed(
      AppRoutes.currentLocation,
      arguments: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: AppColors.background,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: SafeArea(
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              return SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: IntrinsicHeight(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        children: <Widget>[
                          const SizedBox(height: 18),
                          _TopRow(onSkip: _openHome),
                          const Spacer(flex: 52),
                          const _LocationIllustration(),
                          const SizedBox(height: 32),
                          Text(
                            context.l10n.locationTitle,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                              height: 1.3,
                            ),
                          ),
                          const SizedBox(height: 14),
                          ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 312),
                            child: Text(
                              context.l10n.locationBody,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 13.5,
                                fontWeight: FontWeight.w400,
                                color: AppColors.textSecondary,
                                height: 1.75,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          const _CityPill(),
                          const SizedBox(height: 16),
                          const _PrivacyNote(),
                          const Spacer(flex: 48),
                          _AllowButton(onPressed: _allowLocation, busy: _busy),
                          const SizedBox(height: 18),
                          _ManualCityAction(onPressed: _openManualCity),
                          const SizedBox(height: 46),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _TopRow extends StatelessWidget {
  const _TopRow({required this.onSkip});

  final VoidCallback onSkip;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36,
      child: Stack(
        children: <Widget>[
          const Align(alignment: Alignment.center, child: _PageIndicator()),
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: _SkipButton(onPressed: onSkip),
          ),
        ],
      ),
    );
  }
}

class _SkipButton extends StatelessWidget {
  const _SkipButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        child: Text(
          context.l10n.skip,
          style: const TextStyle(
            fontSize: 13.5,
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
          ),
        ),
      ),
    );
  }
}

class _PageIndicator extends StatelessWidget {
  const _PageIndicator();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          width: 25,
          height: 7,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 9),
        const _Dot(),
        const SizedBox(width: 9),
        const _Dot(),
      ],
    );
  }
}

class _Dot extends StatelessWidget {
  const _Dot();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 6,
      height: 6,
      decoration: const BoxDecoration(
        color: AppColors.border,
        shape: BoxShape.circle,
      ),
    );
  }
}

class _LocationIllustration extends StatelessWidget {
  const _LocationIllustration();

  @override
  Widget build(BuildContext context) {
    // Sized against screen width (not LayoutBuilder) so the surrounding
    // IntrinsicHeight column can still measure this subtree.
    final double outer = (MediaQuery.sizeOf(context).width * 0.50)
        .clamp(150.0, 200.0)
        .toDouble();
    final double middle = outer * 0.71;
    final double inner = outer * 0.49;

    return SizedBox(
      height: outer + 18,
      child: Stack(
        alignment: Alignment.topCenter,
        children: <Widget>[
          Container(
            width: outer,
            height: outer,
            decoration: const BoxDecoration(
              color: AppColors.mintSoft,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Container(
              width: middle,
              height: middle,
              decoration: const BoxDecoration(
                color: AppColors.mintMid,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Container(
                width: inner,
                height: inner,
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  shape: BoxShape.circle,
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.07),
                      blurRadius: 18,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: Icon(
                  Icons.location_on_outlined,
                  size: inner * 0.38,
                  color: AppColors.primary,
                ),
              ),
            ),
          ),
          const Positioned(bottom: 0, child: _AccuracyBadge()),
        ],
      ),
    );
  }
}

class _AccuracyBadge extends StatelessWidget {
  const _AccuracyBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: AppColors.textPrimary.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Icon(Icons.explore_outlined, size: 14, color: AppColors.primary),
          const SizedBox(width: 7),
          Text(
            context.l10n.highAccuracy,
            style: TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}

class _CityPill extends StatelessWidget {
  const _CityPill();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
      decoration: BoxDecoration(
        color: AppColors.pillGray,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Icon(Icons.near_me_outlined, size: 16, color: AppColors.primary),
          const SizedBox(width: 9),
          Flexible(
            child: Text(
              AppCopy(context.l10n).cityFullName(AppScope.of(context).city),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PrivacyNote extends StatelessWidget {
  const _PrivacyNote();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const Icon(Icons.lock_outline_rounded, size: 13, color: AppColors.textMuted),
        const SizedBox(width: 7),
        Flexible(
          child: Text(
            context.l10n.locationPrivate,
            style: TextStyle(
              fontSize: 10.5,
              fontWeight: FontWeight.w400,
              color: AppColors.textMuted,
            ),
          ),
        ),
      ],
    );
  }
}

class _AllowButton extends StatelessWidget {
  const _AllowButton({required this.onPressed, required this.busy});

  final VoidCallback onPressed;
  final bool busy;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: busy ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          disabledBackgroundColor: AppColors.primary,
          disabledForegroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(17),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (busy)
              const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            else
              const Icon(Icons.gps_fixed_rounded, size: 18),
            const SizedBox(width: 10),
            Flexible(
              child: Text(
                context.l10n.allowLocation,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ManualCityAction extends StatelessWidget {
  const _ManualCityAction({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primary,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Icon(Icons.search_rounded, size: 17),
          const SizedBox(width: 9),
          Flexible(
            child: Text(
              context.l10n.chooseCityManually,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
