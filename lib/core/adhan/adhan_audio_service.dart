import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';

import 'adhan_audio_catalog.dart';

enum AdhanPlaybackState { idle, loading, playing, paused, completed, error }

abstract class AdhanAudioService extends ChangeNotifier {
  AdhanPlaybackState get playbackState;
  AdhanMosque? get mosque;
  AdhanAudioType? get type;
  String? get assetPath;
  String? get errorMessage;
  Duration get position;
  Duration get duration;
  bool get isPlaying => playbackState == AdhanPlaybackState.playing;
  bool get isBusy => playbackState == AdhanPlaybackState.loading;

  Future<void> play({
    required AdhanMosque mosque,
    required AdhanAudioType type,
  });
  Future<void> pause();
  Future<void> resume();
  Future<void> stop();
  Future<void> replay();
}

class JustAudioAdhanAudioService extends AdhanAudioService {
  JustAudioAdhanAudioService({AdhanAudioCatalog? catalog})
    : _catalog = catalog ?? const AdhanAudioCatalog() {
    _player.playerStateStream.listen(_onPlayerState);
    _player.positionStream.listen((Duration value) {
      _position = value;
      notifyListeners();
    });
    _player.durationStream.listen((Duration? value) {
      if (value != null) {
        _duration = value;
        notifyListeners();
      }
    });
  }

  final AdhanAudioCatalog _catalog;
  final AudioPlayer _player = AudioPlayer();

  AdhanPlaybackState _playbackState = AdhanPlaybackState.idle;
  AdhanMosque? _mosque;
  AdhanAudioType? _type;
  String? _assetPath;
  String? _errorMessage;
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;

  @override
  AdhanPlaybackState get playbackState => _playbackState;
  @override
  AdhanMosque? get mosque => _mosque;
  @override
  AdhanAudioType? get type => _type;
  @override
  String? get assetPath => _assetPath;
  @override
  String? get errorMessage => _errorMessage;
  @override
  Duration get position => _position;
  @override
  Duration get duration => _duration;

  @override
  Future<void> play({
    required AdhanMosque mosque,
    required AdhanAudioType type,
  }) async {
    await _player.stop();
    _mosque = mosque;
    _type = type;
    _assetPath = _catalog.assetFor(mosque: mosque, type: type);
    _errorMessage = null;
    _playbackState = AdhanPlaybackState.loading;
    _position = Duration.zero;
    notifyListeners();
    try {
      await _player.setAsset(_assetPath!);
      await _player.play();
    } catch (error) {
      _playbackState = AdhanPlaybackState.error;
      _errorMessage = 'تعذر تشغيل ملف الأذان المحدد.';
      notifyListeners();
    }
  }

  @override
  Future<void> pause() async {
    await _player.pause();
  }

  @override
  Future<void> resume() async {
    await _player.play();
  }

  @override
  Future<void> stop() async {
    await _player.stop();
    _playbackState = AdhanPlaybackState.idle;
    _position = Duration.zero;
    notifyListeners();
  }

  @override
  Future<void> replay() async {
    if (_mosque == null || _type == null) {
      return;
    }
    await play(mosque: _mosque!, type: _type!);
  }

  void _onPlayerState(PlayerState state) {
    if (_playbackState == AdhanPlaybackState.error) {
      return;
    }
    if (state.processingState == ProcessingState.completed) {
      _playbackState = AdhanPlaybackState.completed;
      notifyListeners();
      return;
    }
    if (state.playing) {
      _playbackState = AdhanPlaybackState.playing;
    } else if (state.processingState == ProcessingState.loading ||
        state.processingState == ProcessingState.buffering) {
      _playbackState = AdhanPlaybackState.loading;
    } else if (_playbackState == AdhanPlaybackState.playing) {
      _playbackState = AdhanPlaybackState.paused;
    }
    notifyListeners();
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }
}

class FakeAdhanAudioService extends AdhanAudioService {
  FakeAdhanAudioService({this.failAsset});

  final String? failAsset;
  AdhanPlaybackState _playbackState = AdhanPlaybackState.idle;
  AdhanMosque? _mosque;
  AdhanAudioType? _type;
  String? _assetPath;
  String? _errorMessage;
  Duration _position = Duration.zero;
  final Duration _duration = const Duration(seconds: 10);
  int playCount = 0;

  @override
  AdhanPlaybackState get playbackState => _playbackState;
  @override
  AdhanMosque? get mosque => _mosque;
  @override
  AdhanAudioType? get type => _type;
  @override
  String? get assetPath => _assetPath;
  @override
  String? get errorMessage => _errorMessage;
  @override
  Duration get position => _position;
  @override
  Duration get duration => _duration;

  @override
  Future<void> play({
    required AdhanMosque mosque,
    required AdhanAudioType type,
  }) async {
    playCount += 1;
    _mosque = mosque;
    _type = type;
    _assetPath = const AdhanAudioCatalog().assetFor(mosque: mosque, type: type);
    if (failAsset != null && _assetPath == failAsset) {
      _playbackState = AdhanPlaybackState.error;
      _errorMessage = 'تعذر تشغيل ملف الأذان المحدد.';
      notifyListeners();
      return;
    }
    _playbackState = AdhanPlaybackState.playing;
    _position = Duration.zero;
    notifyListeners();
  }

  @override
  Future<void> pause() async {
    _playbackState = AdhanPlaybackState.paused;
    notifyListeners();
  }

  @override
  Future<void> resume() async {
    _playbackState = AdhanPlaybackState.playing;
    notifyListeners();
  }

  @override
  Future<void> stop() async {
    _playbackState = AdhanPlaybackState.idle;
    _position = Duration.zero;
    notifyListeners();
  }

  @override
  Future<void> replay() async {
    if (_mosque == null || _type == null) {
      return;
    }
    await play(mosque: _mosque!, type: _type!);
  }

  void complete() {
    _playbackState = AdhanPlaybackState.completed;
    notifyListeners();
  }
}
