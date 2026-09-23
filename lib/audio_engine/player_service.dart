import 'dart:async';
import 'package:audio_service/audio_service.dart';
import 'package:audio_session/audio_session.dart';
import 'package:just_audio/just_audio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/entities/audio_item_entity.dart';

/// Provider for the global audio handler.
/// Initialized once at app startup.
final audioHandlerProvider = Provider<PattuPettiAudioHandler>((ref) {
  return PattuPettiAudioHandler();
});

/// The main AudioHandler — extends BaseAudioHandler to get:
/// - Background playback (foreground service on Android)
/// - Lock screen controls
/// - Notification media controls
/// - Bluetooth headset buttons
/// - CarPlay/Android Auto (future)
///
/// Virtual clip playback: we use a position listener to stop at clip.endMs.
/// No physical file is created for ordinary clips.
class PattuPettiAudioHandler extends BaseAudioHandler with QueueHandler, SeekHandler {
  PattuPettiAudioHandler() {
    _init();
  }

  final AudioPlayer _player = AudioPlayer();

  // Current virtual clip bounds (null = not playing a clip)
  int? _clipStartMs;
  int? _clipEndMs;
  StreamSubscription<Duration>? _clipEndSubscription;

  // Playback state
  double _playbackSpeed = 1.0;
  bool _isShuffled = false;
  AudioServiceRepeatMode _repeatMode = AudioServiceRepeatMode.none;

  // Queue management
  final List<AudioItemEntity> _queueItems = [];
  int _currentIndex = 0;

  List<AudioItemEntity> get currentQueue => List.unmodifiable(_queueItems);
  AudioItemEntity? get currentEntity =>
      _queueItems.isNotEmpty && _currentIndex >= 0 && _currentIndex < _queueItems.length
          ? _queueItems[_currentIndex]
          : null;

  Stream<Duration?> get durationStream => _player.durationStream;

  Future<void> setQueue(List<AudioItemEntity> items, {int initialIndex = 0}) async {
    _queueItems.clear();
    _queueItems.addAll(items);
    _currentIndex = initialIndex.clamp(0, items.isEmpty ? 0 : items.length - 1);
    queue.add(items.map(_toMediaItem).toList());
    if (items.isNotEmpty) {
      await loadAndPlaySong(items[_currentIndex]);
    }
  }

  // Sleep timer
  Timer? _sleepTimer;

  Future<void> _init() async {
    // Configure audio session
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.music());

    // Handle audio interruptions
    session.interruptionEventStream.listen((event) {
      if (event.begin) {
        // Interruption started (phone call, other app)
        if (event.type == AudioInterruptionType.duck) {
          _player.setVolume(0.5); // Duck volume, don't mute
        } else {
          _player.pause();
        }
      } else {
        // Interruption ended
        if (event.type == AudioInterruptionType.duck) {
          _player.setVolume(1.0);
        } else if (event.type == AudioInterruptionType.pause) {
          // Resume only if we were playing
          _player.play();
        }
      }
    });

    // Handle headphone unplug
    session.becomingNoisyEventStream.listen((_) {
      _player.pause();
    });

    // Forward player state to audio_service
    _player.playbackEventStream.listen(_broadcastState);
    _player.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        _handleTrackComplete();
      }
    });

    // Forward duration from just_audio
    _player.durationStream.listen((duration) {
      if (duration != null && mediaItem.value != null) {
        mediaItem.add(mediaItem.value!.copyWith(duration: duration));
      }
    });
  }

  // ─── Playback ─────────────────────────────────────────────────────────────

  @override
  Future<void> play() => _player.play();

  @override
  Future<void> pause() => _player.pause();

  @override
  Future<void> stop() async {
    await _player.stop();
    _clearClipBounds();
  }

  @override
  Future<void> seek(Duration position) async {
    // Clip bounds: clamp seek within clip range
    if (_clipStartMs != null && _clipEndMs != null) {
      final clampedMs = position.inMilliseconds.clamp(_clipStartMs!, _clipEndMs!);
      await _player.seek(Duration(milliseconds: clampedMs));
    } else {
      await _player.seek(position);
    }
  }

  @override
  Future<void> skipToQueueItem(int index) async {
    if (index < 0 || index >= _queueItems.length) return;
    _currentIndex = index;
    await loadAndPlaySong(_queueItems[index]);
  }

  @override
  Future<void> skipToNext() async {
    if (_queueItems.isEmpty) return;
    int nextIndex = _currentIndex + 1;
    if (_isShuffled && _queueItems.length > 1) {
      nextIndex = (DateTime.now().millisecond) % _queueItems.length;
    }
    if (nextIndex < _queueItems.length) {
      await skipToQueueItem(nextIndex);
    } else if (_repeatMode == AudioServiceRepeatMode.all) {
      await skipToQueueItem(0);
    }
  }

  @override
  Future<void> skipToPrevious() async {
    // If > 3 seconds in, restart current song
    if (_player.position.inSeconds > 3) {
      await seek(Duration.zero);
      return;
    }
    if (_queueItems.isEmpty) {
      await seek(Duration.zero);
      return;
    }
    if (_currentIndex > 0) {
      await skipToQueueItem(_currentIndex - 1);
    } else {
      await seek(Duration.zero);
    }
  }

  @override
  Future<void> setSpeed(double speed) async {
    _playbackSpeed = speed;
    await _player.setSpeed(speed);
  }

  @override
  Future<void> setRepeatMode(AudioServiceRepeatMode repeatMode) async {
    _repeatMode = repeatMode;
    playbackState.add(playbackState.value.copyWith(
      repeatMode: repeatMode,
    ));
    // Apply to player
    switch (repeatMode) {
      case AudioServiceRepeatMode.none:
        await _player.setLoopMode(LoopMode.off);
        break;
      case AudioServiceRepeatMode.one:
        await _player.setLoopMode(LoopMode.one);
        break;
      case AudioServiceRepeatMode.all:
        await _player.setLoopMode(LoopMode.off); // We handle queue repeat manually
        break;
      default:
        await _player.setLoopMode(LoopMode.off);
    }
  }

  @override
  Future<void> setShuffleMode(AudioServiceShuffleMode shuffleMode) async {
    _isShuffled = shuffleMode != AudioServiceShuffleMode.none;
    playbackState.add(playbackState.value.copyWith(shuffleMode: shuffleMode));
  }

  // ─── Load Audio ───────────────────────────────────────────────────────────

  /// Load and play a regular song.
  Future<void> loadAndPlaySong(AudioItemEntity item) async {
    if (item.filePath == null) return;
    _clearClipBounds();

    final idx = _queueItems.indexWhere((q) => q.id == item.id);
    if (idx != -1) {
      _currentIndex = idx;
    } else {
      _queueItems.add(item);
      _currentIndex = _queueItems.length - 1;
      queue.add(_queueItems.map(_toMediaItem).toList());
    }

    final mItem = _toMediaItem(item);
    mediaItem.add(mItem);

    final dur = await _player.setAudioSource(AudioSource.file(item.filePath!));
    if (dur != null) {
      mediaItem.add(mItem.copyWith(duration: dur));
    }
    await _player.play();
  }

  /// Load and play a virtual clip.
  /// Seeks to clipStartMs and stops at clipEndMs.
  /// NO physical file is created.
  Future<void> loadAndPlayClip(ResolvedClipEntity resolved) async {
    final sourcePath = resolved.sourceFilePath;
    if (sourcePath == null) return;

    _clipStartMs = resolved.absoluteStartMs;
    _clipEndMs = resolved.absoluteEndMs;

    final mediaItem = _toMediaItemFromClip(resolved);
    this.mediaItem.add(mediaItem);

    // Load the source file
    await _player.setAudioSource(AudioSource.file(sourcePath));

    // Seek to clip start
    await _player.seek(Duration(milliseconds: _clipStartMs!));

    // Set up clip end monitoring
    _clipEndSubscription?.cancel();
    _clipEndSubscription = _player.positionStream.listen((position) {
      if (_clipEndMs != null && position.inMilliseconds >= _clipEndMs!) {
        _onClipEnd();
      }
    });

    await _player.play();
  }

  /// Preview a clip range without queuing it.
  Future<void> previewClipRange({
    required String filePath,
    required int startMs,
    required int endMs,
  }) async {
    _clipStartMs = startMs;
    _clipEndMs = endMs;

    await _player.setAudioSource(AudioSource.file(filePath));
    await _player.seek(Duration(milliseconds: startMs));

    _clipEndSubscription?.cancel();
    _clipEndSubscription = _player.positionStream.listen((pos) {
      if (pos.inMilliseconds >= endMs) {
        _player.pause();
        _clearClipBounds();
      }
    });

    await _player.play();
  }

  // ─── Sleep Timer ──────────────────────────────────────────────────────────

  void setSleepTimer(Duration duration) {
    _sleepTimer?.cancel();
    _sleepTimer = Timer(duration, () {
      _player.pause();
      _sleepTimer = null;
    });
  }

  void cancelSleepTimer() {
    _sleepTimer?.cancel();
    _sleepTimer = null;
  }

  bool get isSleepTimerActive => _sleepTimer?.isActive ?? false;

  // ─── Position stream (for UI) ─────────────────────────────────────────────

  Stream<Duration> get positionStream => _player.positionStream;
  Duration get currentPosition => _player.position;
  Duration? get currentDuration => _player.duration;
  bool get isPlaying => _player.playing;
  double get speed => _playbackSpeed;
  bool get isShuffled => _isShuffled;

  // ─── Private helpers ──────────────────────────────────────────────────────

  void _onClipEnd() {
    _clipEndSubscription?.cancel();
    _clipEndSubscription = null;
    _clearClipBounds();
    _handleTrackComplete();
  }

  void _clearClipBounds() {
    _clipStartMs = null;
    _clipEndMs = null;
    _clipEndSubscription?.cancel();
    _clipEndSubscription = null;
  }

  void _handleTrackComplete() {
    if (_repeatMode == AudioServiceRepeatMode.one) {
      if (_clipStartMs != null) {
        _player.seek(Duration(milliseconds: _clipStartMs!));
      } else {
        _player.seek(Duration.zero);
      }
      _player.play();
    } else {
      skipToNext();
    }
  }

  void _broadcastState(PlaybackEvent event) {
    final isPlaying = _player.playing;
    playbackState.add(
      playbackState.value.copyWith(
        controls: [
          MediaControl.skipToPrevious,
          if (isPlaying) MediaControl.pause else MediaControl.play,
          MediaControl.skipToNext,
        ],
        androidCompactActionIndices: const [0, 1, 2],
        processingState: switch (_player.processingState) {
          ProcessingState.idle => AudioProcessingState.idle,
          ProcessingState.loading => AudioProcessingState.loading,
          ProcessingState.buffering => AudioProcessingState.buffering,
          ProcessingState.ready => AudioProcessingState.ready,
          ProcessingState.completed => AudioProcessingState.completed,
        },
        playing: isPlaying,
        updatePosition: _player.position,
        bufferedPosition: _player.bufferedPosition,
        speed: _player.speed,
        queueIndex: queue.value.indexWhere((m) => m.id == mediaItem.value?.id),
      ),
    );
  }

  MediaItem _toMediaItem(AudioItemEntity item) {
    return MediaItem(
      id: item.id,
      title: item.title,
      artist: item.artist,
      album: item.album,
      duration: item.duration,
      artUri: item.artworkPath != null ? Uri.file(item.artworkPath!) : null,
      extras: {
        'itemType': item.itemType.value,
        'filePath': item.filePath,
      },
    );
  }

  MediaItem _toMediaItemFromClip(ResolvedClipEntity resolved) {
    return MediaItem(
      id: resolved.clip.id,
      title: resolved.clip.title,
      artist: resolved.clip.artist ?? resolved.source.artist,
      album: resolved.clip.album ?? resolved.source.album,
      duration: Duration(
        milliseconds: resolved.absoluteEndMs - resolved.absoluteStartMs,
      ),
      artUri: (resolved.clip.artworkPath ?? resolved.source.artworkPath) != null
          ? Uri.file(resolved.clip.artworkPath ?? resolved.source.artworkPath!)
          : null,
      extras: {
        'itemType': 'clip',
        'sourceId': resolved.source.id,
        'startMs': resolved.absoluteStartMs,
        'endMs': resolved.absoluteEndMs,
      },
    );
  }

  Future<void> dispose() async {
    _clipEndSubscription?.cancel();
    _sleepTimer?.cancel();
    await _player.dispose();
  }
}
