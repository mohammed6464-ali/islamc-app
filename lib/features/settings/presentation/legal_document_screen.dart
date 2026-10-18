import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/legal/app_legal.dart';
import '../../../core/l10n/app_language.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_screen_header.dart';
import '../../../core/widgets/decorative_patterns.dart';
import '../../../l10n/app_localizations.dart';

class LegalSection {
  const LegalSection({required this.title, required this.body});

  final String title;
  final String body;
}

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = context.l10n;
    return LegalDocumentScreen(
      title: l10n.privacyPolicy,
      icon: Icons.shield_outlined,
      intro: l10n.privacyBody,
      sections: <LegalSection>[
        LegalSection(title: l10n.privacyDeviceTitle, body: l10n.privacyDeviceBody),
        LegalSection(
          title: l10n.privacyLocationTitle,
          body: l10n.privacyLocationBody,
        ),
        LegalSection(title: l10n.privacyWeatherTitle, body: l10n.privacyWeatherBody),
        LegalSection(
          title: l10n.privacyNotificationsTitle,
          body: l10n.privacyNotificationsBody,
        ),
        LegalSection(title: l10n.privacyShareTitle, body: l10n.privacyShareBody),
      ],
    );
  }
}

class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = context.l10n;
    return LegalDocumentScreen(
      title: l10n.terms,
      icon: Icons.gavel_rounded,
      intro: l10n.termsBody,
      sections: <LegalSection>[
        LegalSection(title: l10n.termsServiceTitle, body: l10n.termsServiceBody),
        LegalSection(title: l10n.termsPrayerTitle, body: l10n.termsPrayerBody),
        LegalSection(title: l10n.termsAccuracyTitle, body: l10n.termsAccuracyBody),
        LegalSection(title: l10n.termsUseTitle, body: l10n.termsUseBody),
        LegalSection(title: l10n.termsLiabilityTitle, body: l10n.termsLiabilityBody),
        LegalSection(title: l10n.termsChangesTitle, body: l10n.termsChangesBody),
      ],
    );
  }
}

class LegalDocumentScreen extends StatelessWidget {
  const LegalDocumentScreen({
    super.key,
    required this.title,
    required this.icon,
    required this.intro,
    required this.sections,
  });

  final String title;
  final IconData icon;
  final String intro;
  final List<LegalSection> sections;

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
          bottom: false,
          child: Column(
            children: <Widget>[
              AppScreenHeader(
                leading: const HeaderBackButton(),
                title: title,
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
                  physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics(),
                  ),
                  children: <Widget>[
                    LegalHeroCard(icon: icon, title: title, subtitle: intro),
                    const SizedBox(height: 14),
                    for (final LegalSection section in sections) ...<Widget>[
                      AppCard(
                        radius: 18,
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              section.title,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primary,
                                height: 1.35,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              section.body,
                              style: const TextStyle(
                                fontSize: 13.5,
                                fontWeight: FontWeight.w400,
                                color: AppColors.textPrimary,
                                height: 1.75,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LegalHeroCard extends StatelessWidget {
  const LegalHeroCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: const LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: <Color>[
            AppColors.accentGreen,
            AppColors.primary,
            AppColors.darkGreen,
          ],
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.22),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: Stack(
          children: <Widget>[
            const Positioned.fill(child: DotGridPattern()),
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(13),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.14),
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Icon(icon, size: 22, color: Colors.white),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              AppLegal.appName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                height: 1.3,
                              ),
                            ),
                            Text(
                              context.l10n.legalLastUpdated,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                                color: Colors.white.withValues(alpha: 0.72),
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: Colors.white.withValues(alpha: 0.88),
                      height: 1.65,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
