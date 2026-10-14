import 'package:flutter/material.dart';

import '../../../../core/adhan/adhan_audio_catalog.dart';
import '../../../../core/adhan/adhan_audio_service.dart';
import '../../../../core/l10n/app_copy.dart';
import '../../../../core/l10n/app_language.dart';
import '../../../../core/state/app_scope.dart';
import '../../../../core/state/app_state.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_feedback.dart';
import '../../../../core/widgets/app_toggle.dart';
import '../../../../core/widgets/common_widgets.dart';

class AdhanTrialCard extends StatefulWidget {
  const AdhanTrialCard({super.key, this.audioService});

  final AdhanAudioService? audioService;

  @override
  State<AdhanTrialCard> createState() => _AdhanTrialCardState();
}

class _AdhanTrialCardState extends State<AdhanTrialCard> {
  late final AdhanAudioService _audio;
  late final bool _ownsAudio;
  AdhanAudioType _type = AdhanAudioType.regular;

  @override
  void initState() {
    super.initState();
    _ownsAudio = widget.audioService == null;
    _audio = widget.audioService ?? JustAudioAdhanAudioService();
    _audio.addListener(_rebuild);
  }

  void _rebuild() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _audio.removeListener(_rebuild);
    if (_ownsAudio) {
      _audio.dispose();
    }
    super.dispose();
  }

  Future<void> _play(AppState state) async {
    await _audio.play(mosque: state.adhanMosque, type: _type);
    if (!mounted) {
      return;
    }
    if (_audio.playbackState == AdhanPlaybackState.error) {
      showAppMessage(
        context,
        _audio.errorMessage ?? context.l10n.adhanFailed,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final AppState state = AppScope.of(context);
    final AppCopy copy = AppCopy(context.l10n);
    final bool playing = _audio.isPlaying;
    final double progress = _audio.duration.inMilliseconds == 0
        ? 0
        : _audio.position.inMilliseconds / _audio.duration.inMilliseconds;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(13, 14, 13, 13),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SectionTitle(
              title: context.l10n.adhanPreview,
              icon: Icons.volume_up_outlined,
            ),
            const SizedBox(height: 12),
            Text(
              context.l10n.mosque,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            _Choice(
              label: copy.mosqueShort(AdhanMosque.makkah),
              selected: state.adhanMosque == AdhanMosque.makkah,
              onTap: () async {
                await _audio.stop();
                state.setAdhanMosque(AdhanMosque.makkah);
              },
            ),
            const SizedBox(height: 8),
            _Choice(
              label: copy.mosqueShort(AdhanMosque.madinah),
              selected: state.adhanMosque == AdhanMosque.madinah,
              onTap: () async {
                await _audio.stop();
                state.setAdhanMosque(AdhanMosque.madinah);
              },
            ),
            const SizedBox(height: 14),
            Text(
              context.l10n.adhanType,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            _Choice(
              label: copy.adhanType(AdhanAudioType.fajr),
              selected: _type == AdhanAudioType.fajr,
              onTap: () async {
                await _audio.stop();
                setState(() => _type = AdhanAudioType.fajr);
              },
            ),
            const SizedBox(height: 8),
            _Choice(
              label: copy.adhanType(AdhanAudioType.regular),
              selected: _type == AdhanAudioType.regular,
              onTap: () async {
                await _audio.stop();
                setState(() => _type = AdhanAudioType.regular);
              },
            ),
            const SizedBox(height: 14),
            if (_audio.isBusy || playing || _audio.playbackState == AdhanPlaybackState.paused)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: LinearProgressIndicator(
                  value: _audio.isBusy ? null : progress.clamp(0.0, 1.0),
                  minHeight: 4,
                  borderRadius: BorderRadius.circular(8),
                  color: AppColors.primary,
                  backgroundColor: AppColors.mint,
                ),
              ),
            Row(
              children: <Widget>[
                Expanded(
                  child: PrimaryButton(
                    label: _audio.isBusy
                        ? context.l10n.adhanLoading
                        : context.l10n.playAdhan,
                    icon: Icons.play_arrow_rounded,
                    height: 46,
                    onPressed: _audio.isBusy ? () {} : () => _play(state),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Material(
                    color: AppColors.pillGray,
                    borderRadius: BorderRadius.circular(15),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(15),
                      onTap: () => _audio.stop(),
                      child: SizedBox(
                        height: 46,
                        child: Center(
                          child: Text(
                            context.l10n.stopAdhan,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Choice extends StatelessWidget {
  const _Choice({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? AppColors.mintTint : AppColors.surface,
      borderRadius: BorderRadius.circular(13),
      child: InkWell(
        borderRadius: BorderRadius.circular(13),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(13),
            border: Border.all(
              color: selected ? AppColors.mintBorder : AppColors.border,
            ),
          ),
          child: Row(
            children: <Widget>[
              AppRadio(selected: selected),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 13.5,
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
