import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/data/demo_data.dart';
import '../../../core/data/models.dart';
import '../../../core/state/app_scope.dart';
import '../../../core/state/app_state.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_feedback.dart';
import '../../../core/widgets/app_screen_header.dart';
import '../../../core/widgets/app_toggle.dart';
import '../../../core/widgets/common_widgets.dart';
import 'widgets/map_placeholder.dart';

class CurrentLocationScreen extends StatefulWidget {
  const CurrentLocationScreen({super.key});

  @override
  State<CurrentLocationScreen> createState() => _CurrentLocationScreenState();
}

class _CurrentLocationScreenState extends State<CurrentLocationScreen> {
  final TextEditingController _search = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  List<CityData> get _matches {
    if (_query.trim().isEmpty) return DemoData.cities;
    return DemoData.cities
        .where((CityData c) => c.name.contains(_query.trim()))
        .toList(growable: false);
  }

  @override
  Widget build(BuildContext context) {
    final AppState state = AppScope.of(context);
    final List<CityData> matches = _matches;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: AppColors.background,
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
                title: 'موقعك الحالي',
                subtitle: state.city.fullName,
                titleColor: AppColors.textPrimary,
                actions: <Widget>[
                  HeaderIconButton(
                    icon: Icons.explore_outlined,
                    tooltip: 'اتجاه القبلة',
                    onPressed: () => Navigator.of(context).maybePop(),
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
                    const _MapCard(),
                    const SizedBox(height: 14),
                    const _CurrentCityCard(),
                    const SizedBox(height: 20),
                    const SectionTitle(
                      title: 'أو اختر مدينة يدويًا',
                      trailing: 'المملكة العربية السعودية',
                    ),
                    const SizedBox(height: 12),
                    _SearchField(
                      controller: _search,
                      onChanged: (String value) =>
                          setState(() => _query = value),
                    ),
                    const SizedBox(height: 16),
                    SectionTitle(
                      title: 'المدن الشائعة والمقدسة',
                      titleColor: AppColors.textSecondary,
                      trailing: '${DemoData.cities.length} مدن متوفرة',
                    ),
                    const SizedBox(height: 12),
                    const _CityChips(),
                    const SizedBox(height: 18),
                    if (matches.isEmpty)
                      const InfoNote(
                        icon: Icons.search_off_rounded,
                        text: 'لا توجد مدينة مطابقة لبحثك.',
                      )
                    else
                      for (final CityData city in matches) ...<Widget>[
                        _CityRowCard(city: city),
                        const SizedBox(height: 10),
                      ],
                    const SizedBox(height: 6),
                    InfoNote(
                      icon: Icons.verified_outlined,
                      title:
                          'طريقة الحساب المعتمدة: ${state.calculationMethod}',
                      text:
                          'تتم مطابقة زوايا الفجر والعشاء واتجاه القبلة مع '
                          'المعايير الرسمية لوزارة الشؤون الإسلامية.',
                    ),
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

class _MapCard extends StatelessWidget {
  const _MapCard();

  @override
  Widget build(BuildContext context) {
    final AppState state = AppScope.of(context);

    return AppCard(
      radius: 20,
      padding: const EdgeInsets.all(8),
      child: Stack(
        children: <Widget>[
          MapPlaceholder(cityId: state.city.id),
          PositionedDirectional(
            top: 10,
            start: 10,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: AppColors.textPrimary.withValues(alpha: 0.08),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Dot(size: 7, color: AppColors.primary),
                  SizedBox(width: 8),
                  Text(
                    'إشارة GPS قوية دقيقة',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          PositionedDirectional(
            bottom: 10,
            start: 10,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
              decoration: BoxDecoration(
                color: AppColors.textPrimary.withValues(alpha: 0.62),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Text(
                '24.7136° N, 46.6753° E',
                textDirection: TextDirection.ltr,
                style: TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w600,
                  color: AppColors.surface,
                ),
              ),
            ),
          ),
          PositionedDirectional(
            bottom: 10,
            end: 10,
            child: Material(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () => showAppMessage(
                  context,
                  'الخريطة تمثيلية فقط في النسخة التجريبية.',
                ),
                child: const SizedBox(
                  width: 40,
                  height: 40,
                  child: Icon(
                    Icons.fullscreen_rounded,
                    size: 21,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CurrentCityCard extends StatelessWidget {
  const _CurrentCityCard();

  @override
  Widget build(BuildContext context) {
    final AppState state = AppScope.of(context);

    return AppCard(
      radius: 18,
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 10),
      child: Column(
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const IconTile.mint(Icons.location_on_outlined, size: 48, iconSize: 24),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      state.city.fullName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                        height: 1.35,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${DemoData.timezoneName} • دقة التوقيت الفلكي 100%',
                      style: const TextStyle(
                        fontSize: 11.5,
                        color: AppColors.textSecondary,
                        height: 1.45,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              const AppBadge(
                'نشط الآن',
                background: AppColors.mintStrong,
                radius: 12,
                padding: EdgeInsets.symmetric(horizontal: 11, vertical: 6),
              ),
            ],
          ),
          const SizedBox(height: 16),
          PrimaryButton(
            label: 'تحديث الموقع عبر GPS',
            icon: Icons.my_location_rounded,
            onPressed: () => showAppMessage(
              context,
              'تحديد الموقع عبر GPS غير مفعّل — المدينة تُختار يدويًا في '
              'النسخة التجريبية.',
            ),
          ),
          const SizedBox(height: 14),
          const CardDivider(),
          const SizedBox(height: 6),
          Row(
            children: <Widget>[
              const Icon(
                Icons.near_me_outlined,
                size: 19,
                color: AppColors.textPrimary,
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'تحديد الموقع تلقائيًا',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                        height: 1.3,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'تحديث مواقيت الصلاة والأذان عند التنقل بين المدن',
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.textSecondary,
                        height: 1.45,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              AppToggle(
                value: state.autoDetectLocation,
                onChanged: state.setAutoDetectLocation,
              ),
            ],
          ),
          const SizedBox(height: 6),
        ],
      ),
    );
  }
}

class _SearchField extends StatelessWidget {
  const _SearchField({required this.controller, required this.onChanged});

  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      radius: 16,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      child: Row(
        children: <Widget>[
          const Icon(Icons.search, size: 20, color: AppColors.textSecondary),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              textInputAction: TextInputAction.search,
              style: const TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
              decoration: const InputDecoration(
                isDense: true,
                border: InputBorder.none,
                hintText: 'ابحث عن مدينة...',
                hintStyle: TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w400,
                  color: AppColors.textMuted,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          const Icon(
            Icons.tune_rounded,
            size: 19,
            color: AppColors.textPrimary,
          ),
        ],
      ),
    );
  }
}

class _CityChips extends StatelessWidget {
  const _CityChips();

  @override
  Widget build(BuildContext context) {
    final AppState state = AppScope.of(context);

    return Wrap(
      spacing: 9,
      runSpacing: 9,
      children: <Widget>[
        for (final CityData city in DemoData.cities)
          _CityChip(city: city, selected: city.id == state.cityId),
      ],
    );
  }
}

class _CityChip extends StatelessWidget {
  const _CityChip({required this.city, required this.selected});

  final CityData city;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final AppState state = AppScope.read(context);

    return Material(
      color: selected ? AppColors.primary : AppColors.surface,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => _select(context, state, city),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: selected ? AppColors.primary : AppColors.border,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              if (selected) ...<Widget>[
                const Icon(Icons.check, size: 15, color: AppColors.surface),
                const SizedBox(width: 7),
              ] else if (city.holy) ...<Widget>[
                const Icon(
                  Icons.mosque_outlined,
                  size: 15,
                  color: AppColors.primary,
                ),
                const SizedBox(width: 7),
              ],
              Text(
                selected ? '${city.name} (محدد حاليًا)' : city.name,
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                  color: selected ? AppColors.surface : AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CityRowCard extends StatelessWidget {
  const _CityRowCard({required this.city});

  final CityData city;

  @override
  Widget build(BuildContext context) {
    final AppState state = AppScope.of(context);
    final bool selected = city.id == state.cityId;
    final int offsetDelta = city.offsetMinutes - state.city.offsetMinutes;
    final PrayerTime asr = _asrFor(city);

    final StringBuffer subtitle = StringBuffer()
      ..write(city.region)
      ..write(' • صلاة العصر ')
      ..write(asr.paddedTimeWithPeriod);
    if (!selected && offsetDelta != 0) {
      subtitle.write(
        ' (فارق ${offsetDelta > 0 ? '+' : '-'}${offsetDelta.abs()} دقيقة)',
      );
    }

    return Material(
      color: selected ? AppColors.mintTint : AppColors.surface,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => _select(context, state, city),
        child: Container(
          padding: const EdgeInsets.all(13),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: selected ? AppColors.primary : AppColors.border,
              width: selected ? 1.5 : 1,
            ),
          ),
          child: Row(
            children: <Widget>[
              selected
                  ? const IconTile.dark(Icons.mosque_outlined, iconSize: 22)
                  : IconTile(_cityIcon(city), iconSize: 22),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Flexible(
                          child: Text(
                            city.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 15.5,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                              height: 1.3,
                            ),
                          ),
                        ),
                        if (selected) ...<Widget>[
                          const SizedBox(width: 8),
                          const AppBadge(
                            'المدينة الحالية',
                            background: AppColors.primary,
                            foreground: AppColors.surface,
                            fontSize: 9.5,
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text(
                      subtitle.toString(),
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.textSecondary,
                        height: 1.45,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              if (selected)
                Container(
                  width: 28,
                  height: 28,
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check,
                    size: 17,
                    color: AppColors.surface,
                  ),
                )
              else
                const Icon(
                  Icons.chevron_right,
                  size: 21,
                  color: AppColors.textMuted,
                ),
            ],
          ),
        ),
      ),
    );
  }

  static IconData _cityIcon(CityData city) =>
      city.holy ? Icons.mosque_outlined : Icons.apartment_rounded;

  /// Asr for an arbitrary city, independent of the currently selected one.
  static PrayerTime _asrFor(CityData city) {
    final PrayerTemplate template = DemoData.prayerTemplates.firstWhere(
      (PrayerTemplate t) => t.id == 'asr',
    );
    return PrayerTime(
      id: template.id,
      name: template.name,
      longName: template.longName,
      note: template.upcomingNote,
      icon: template.icon,
      minutes: template.baseMinutes + city.offsetMinutes,
      status: PrayerStatus.upcoming,
      supportsAlert: true,
    );
  }
}

void _select(BuildContext context, AppState state, CityData city) {
  if (city.id == state.cityId) return;
  state.selectCity(city.id);
  showAppMessage(context, 'تم تحديث المواقيت والطقس على مدينة ${city.name}.');
}
