import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:audio_service/audio_service.dart';
import '../../../../audio_engine/player_service.dart';
import '../../../../domain/entities/audio_item_entity.dart';
import '../../../../shared/providers/global_providers.dart';
import '../../../../data/local/database/app_database.dart';
import '../../../../data/local/database/app_database_dao.dart';

import 'package:drift/drift.dart' show Value;
import 'package:uuid/uuid.dart';

/// Current playback state for the UI.
class PlayerState {
  const PlayerState({
    this.currentItem,
    this.isPlaying = false,
    this.position = Duration.zero,
    this.duration,
    this.playbackSpeed = 1.0,
    this.repeatMode = AppRepeatMode.off,
    this.shuffleEnabled = false,
    this.queue = const [],
    this.queueIndex = 0,
    this.sleepTimerActive = false,
  });

  final AudioItemEntity? currentItem;
  final bool isPlaying;
  final Duration position;
  final Duration? duration;
  final double playbackSpeed;
  final AppRepeatMode repeatMode;
  final bool shuffleEnabled;
  final List<AudioItemEntity> queue;
  final int queueIndex;
  final bool sleepTimerActive;

  bool get hasItem => currentItem != null;

  double get progress {
    if (duration == null || duration!.inMilliseconds == 0) return 0;
    return position.inMilliseconds / duration!.inMilliseconds;
  }

  PlayerState copyWith({
    AudioItemEntity? currentItem,
    bool? isPlaying,
    Duration? position,
    Duration? duration,
    double? playbackSpeed,
    AppRepeatMode? repeatMode,
    bool? shuffleEnabled,
    List<AudioItemEntity>? queue,
    int? queueIndex,
    bool? sleepTimerActive,
  }) {
    return PlayerState(
      currentItem: currentItem ?? this.currentItem,
      isPlaying: isPlaying ?? this.isPlaying,
      position: position ?? this.position,
      duration: duration ?? this.duration,
      playbackSpeed: playbackSpeed ?? this.playbackSpeed,
      repeatMode: repeatMode ?? this.repeatMode,
      shuffleEnabled: shuffleEnabled ?? this.shuffleEnabled,
      queue: queue ?? this.queue,
      queueIndex: queueIndex ?? this.queueIndex,
      sleepTimerActive: sleepTimerActive ?? this.sleepTimerActive,
    );
  }
}

enum AppRepeatMode { off, repeatOne, repeatAll, repeatClip }

/// Player state provider — notifier wrapping the AudioHandler.
class PlayerNotifier extends StateNotifier<PlayerState> {
  PlayerNotifier(this._handler, this._db) : super(const PlayerState()) {
    _listenToHandler();
  }

  final PattuPettiAudioHandler _handler;
  final AppDatabase _db;

  void _listenToHandler() {
    _handler.positionStream.listen((pos) {
      state = state.copyWith(position: pos);
    });

    _handler.durationStream.listen((dur) {
      if (dur != null && dur.inMilliseconds > 0) {
        state = state.copyWith(duration: dur);
      }
    });

    _handler.mediaItem.listen((m) {
      if (m != null) {
        final current = _handler.currentEntity;
        state = state.copyWith(
          currentItem: current ?? state.currentItem,
          duration: m.duration ?? state.duration,
        );
      }
    });

    _handler.playbackState.listen((ps) {
      state = state.copyWith(isPlaying: ps.playing);
    });
  }

  Future<void> playDbItem(dynamic item, {List<dynamic>? playlist}) async {
    final file = await _db.getFileForItem(item.id as String);
    final entity = AudioItemEntity(
      id: item.id as String,
      userId: item.userId as String,
      itemType: AudioItemType.fromString(item.itemType as String),
      title: item.title as String,
      artist: item.artist as String?,
      album: item.album as String?,
      artworkPath: item.artworkPath as String?,
      durationMs: item.durationMs as int?,
      filePath: file?.filePath,
      isLiked: item.isLiked as bool? ?? false,
      createdAt: item.createdAt as DateTime,
      updatedAt: item.updatedAt as DateTime,
    );

    // Record play count & play history
    await _db.incrementPlayCount(item.id as String);
    try {
      await _db.insertHistoryEntry(PlayHistoryCompanion.insert(
        id: const Uuid().v4(),
        userId: item.userId as String,
        audioItemId: item.id as String,
        playedAt: Value(DateTime.now()),
      ));
    } catch (_) {}

    // Load full playlist into queue so Previous & Next navigate through library
    final rawList = playlist ?? await _db.getAllSongs(item.userId as String);
    final queueList = <AudioItemEntity>[];
    int clickedIndex = 0;

    for (int i = 0; i < rawList.length; i++) {
      final s = rawList[i];
      if (s.id == item.id) {
        clickedIndex = queueList.length;
        queueList.add(entity);
      } else {
        final f = await _db.getFileForItem(s.id as String);
        if (f != null && f.filePath.isNotEmpty) {
          queueList.add(AudioItemEntity(
            id: s.id as String,
            userId: s.userId as String,
            itemType: AudioItemType.fromString(s.itemType as String),
            title: s.title as String,
            artist: s.artist as String?,
            album: s.album as String?,
            artworkPath: s.artworkPath as String?,
            durationMs: s.durationMs as int?,
            filePath: f.filePath,
            isLiked: s.isLiked as bool? ?? false,
            createdAt: s.createdAt as DateTime,
            updatedAt: s.updatedAt as DateTime,
          ));
        }
      }
    }

    if (queueList.isNotEmpty) {
      state = state.copyWith(
        currentItem: entity,
        queue: queueList,
        queueIndex: clickedIndex,
      );
      await _handler.setQueue(queueList, initialIndex: clickedIndex);
    } else {
      await playSong(entity);
    }
  }

  Future<void> toggleLike() async {
    if (state.currentItem == null) return;
    final newLiked = !state.currentItem!.isLiked;
    await _db.toggleLike(state.currentItem!.id, newLiked);
    state = state.copyWith(
      currentItem: state.currentItem!.copyWith(isLiked: newLiked),
    );
  }

  Future<void> playSong(AudioItemEntity item) async {
    state = state.copyWith(currentItem: item, isPlaying: false);
    await _handler.loadAndPlaySong(item);
  }

  Future<void> playClip(ResolvedClipEntity resolved) async {
    state = state.copyWith(currentItem: resolved.clip, isPlaying: false);
    await _handler.loadAndPlayClip(resolved);
  }

  Future<void> togglePlayPause() async {
    if (_handler.isPlaying) {
      await _handler.pause();
    } else {
      await _handler.play();
    }
  }

  Future<void> stop() async {
    state = state.copyWith(isPlaying: false, currentItem: null);
    await _handler.stop();
  }

  Future<void> seekTo(Duration position) => _handler.seek(position);

  Future<void> skipNext() => _handler.skipToNext();
  Future<void> skipPrevious() => _handler.skipToPrevious();

  Future<void> setSpeed(double speed) async {
    state = state.copyWith(playbackSpeed: speed);
    await _handler.setSpeed(speed);
  }

  Future<void> setRepeatMode(AppRepeatMode mode) async {
    state = state.copyWith(repeatMode: mode);
    // Convert to audio_service RepeatMode
    final asMode = switch (mode) {
      AppRepeatMode.off => AudioServiceRepeatMode.none,
      AppRepeatMode.repeatOne => AudioServiceRepeatMode.one,
      AppRepeatMode.repeatAll => AudioServiceRepeatMode.all,
      AppRepeatMode.repeatClip => AudioServiceRepeatMode.one,
    };
    await _handler.setRepeatMode(asMode);
  }

  Future<void> toggleShuffle() async {
    final newShuffle = !state.shuffleEnabled;
    state = state.copyWith(shuffleEnabled: newShuffle);
    await _handler.setShuffleMode(
      newShuffle ? AudioServiceShuffleMode.all : AudioServiceShuffleMode.none,
    );
  }

  void setSleepTimer(Duration duration) {
    _handler.setSleepTimer(duration);
    state = state.copyWith(sleepTimerActive: true);
  }

  void cancelSleepTimer() {
    _handler.cancelSleepTimer();
    state = state.copyWith(sleepTimerActive: false);
  }
}

final playerNotifierProvider =
    StateNotifierProvider<PlayerNotifier, PlayerState>((ref) {
  final handler = ref.watch(audioHandlerProvider);
  final db = ref.watch(appDatabaseProvider);
  return PlayerNotifier(handler, db);
});
