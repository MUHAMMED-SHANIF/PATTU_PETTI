import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:uuid/uuid.dart';
import '../../../../shared/providers/global_providers.dart';
import '../../../../data/local/database/app_database.dart';
import '../../../../data/local/database/app_database_dao.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../library/presentation/providers/library_provider.dart';
import '../../../player/presentation/providers/player_provider.dart';
import '../../data/recording_file_manager.dart';
import '../../data/recording_repository.dart';
import '../../data/recording_service.dart';
import '../../domain/entities/recording_state.dart';

final recordingServiceProvider = Provider<RecordingService>((ref) {
  final service = RecordingService();
  ref.onDispose(() => service.dispose());
  return service;
});

final recordingFileManagerProvider = Provider<RecordingFileManager>((ref) {
  return const RecordingFileManager();
});

final recordingRepositoryProvider = Provider<RecordingRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  final fileManager = ref.watch(recordingFileManagerProvider);
  return RecordingRepository(db: db, fileManager: fileManager);
});

final recordingNotifierProvider =
    StateNotifierProvider.autoDispose<RecordingNotifier, RecordingSessionState>((ref) {
  return RecordingNotifier(
    service: ref.watch(recordingServiceProvider),
    fileManager: ref.watch(recordingFileManagerProvider),
    repository: ref.watch(recordingRepositoryProvider),
    ref: ref,
  );
});

class RecordingNotifier extends StateNotifier<RecordingSessionState> {
  RecordingNotifier({
    required this.service,
    required this.fileManager,
    required this.repository,
    required this.ref,
  }) : super(const RecordingSessionState());

  final RecordingService service;
  final RecordingFileManager fileManager;
  final RecordingRepository repository;
  final Ref ref;

  Timer? _timer;
  StreamSubscription? _amplitudeSub;
  DateTime? _sessionStartTime;
  Duration _accumulatedTime = Duration.zero;

  /// Safely cancel any active recording and reset notifier to clean idle state.
  Future<void> resetToIdle() async {
    _timer?.cancel();
    await _amplitudeSub?.cancel();
    await service.cancelRecording();
    _accumulatedTime = Duration.zero;
    _sessionStartTime = null;
    state = const RecordingSessionState();
  }


  /// Start a new recording session.
  /// Strictly checks and requests microphone permission ONLY at this point.
  Future<void> startRecording() async {
    // 1. Check microphone permission
    var status = await Permission.microphone.status;
    if (status.isPermanentlyDenied) {
      state = state.copyWith(
        status: RecordingStatus.error,
        permissionDenied: true,
        permissionPermanentlyDenied: true,
        errorMessage:
            'Microphone permission is permanently denied. Please open Settings to grant access.',
      );
      return;
    }

    if (!status.isGranted) {
      status = await Permission.microphone.request();
      if (status.isPermanentlyDenied) {
        state = state.copyWith(
          status: RecordingStatus.error,
          permissionDenied: true,
          permissionPermanentlyDenied: true,
          errorMessage:
              'Microphone permission is permanently denied. Please open Settings to grant access.',
        );
        return;
      }
      if (!status.isGranted) {
        state = state.copyWith(
          status: RecordingStatus.error,
          permissionDenied: true,
          permissionPermanentlyDenied: false,
          errorMessage: 'Microphone permission is required to record audio.',
        );
        return;
      }
    }

    // Pause any active app audio playback to prevent audio focus conflicts
    try {
      await ref.read(playerNotifierProvider.notifier).pause();
    } catch (_) {}

    // 2. Prepare recorder
    state = state.copyWith(
      status: RecordingStatus.preparing,
      clearError: true,
      permissionDenied: false,
      permissionPermanentlyDenied: false,
      duration: Duration.zero,
      recentAmplitudes: [],
    );

    try {
      final tempPath = await fileManager.createTempRecordingPath();
      await service.startRecording(destinationPath: tempPath);

      _accumulatedTime = Duration.zero;
      _sessionStartTime = DateTime.now();

      // 3. Start timer
      _timer?.cancel();
      _timer = Timer.periodic(const Duration(milliseconds: 100), (_) {
        if (_sessionStartTime != null) {
          final currentSession = DateTime.now().difference(_sessionStartTime!);
          state = state.copyWith(duration: _accumulatedTime + currentSession);
        }
      });

      // 4. Amplitude stream for dynamic waveform visualizer
      _amplitudeSub?.cancel();
      _amplitudeSub = service.getAmplitudeStream().listen((amp) {
        final currentDb = amp.current.clamp(-60.0, 0.0);
        // Normalize between 0.05 and 1.0 for visual height
        final normalized = ((currentDb + 60.0) / 60.0).clamp(0.05, 1.0);
        final list = List<double>.from(state.recentAmplitudes);
        list.add(normalized);
        if (list.length > 50) {
          list.removeAt(0);
        }
        state = state.copyWith(
          currentDecibels: currentDb,
          recentAmplitudes: list,
        );
      });

      state = state.copyWith(
        status: RecordingStatus.recording,
        tempFilePath: tempPath,
      );
    } catch (e) {
      debugPrint('Error starting recording: $e');
      state = state.copyWith(
        status: RecordingStatus.error,
        errorMessage: 'Failed to initialize audio recorder: $e',
      );
    }
  }

  /// Pause current recording.
  Future<void> pauseRecording() async {
    if (state.status != RecordingStatus.recording) return;

    try {
      await service.pauseRecording();
      if (_sessionStartTime != null) {
        _accumulatedTime += DateTime.now().difference(_sessionStartTime!);
        _sessionStartTime = null;
      }
      _timer?.cancel();
      state = state.copyWith(status: RecordingStatus.paused);
    } catch (e) {
      debugPrint('Error pausing recording: $e');
    }
  }

  /// Resume current recording from paused state.
  Future<void> resumeRecording() async {
    if (state.status != RecordingStatus.paused) return;

    try {
      await service.resumeRecording();
      _sessionStartTime = DateTime.now();
      _timer?.cancel();
      _timer = Timer.periodic(const Duration(milliseconds: 100), (_) {
        if (_sessionStartTime != null) {
          final currentSession = DateTime.now().difference(_sessionStartTime!);
          state = state.copyWith(duration: _accumulatedTime + currentSession);
        }
      });
      state = state.copyWith(status: RecordingStatus.recording);
    } catch (e) {
      debugPrint('Error resuming recording: $e');
    }
  }

  /// Stop recording and proceed to Preview view.
  Future<void> stopRecording() async {
    if (state.status != RecordingStatus.recording &&
        state.status != RecordingStatus.paused) {
      return;
    }

    state = state.copyWith(status: RecordingStatus.stopping);
    _timer?.cancel();
    await _amplitudeSub?.cancel();

    if (_sessionStartTime != null) {
      _accumulatedTime += DateTime.now().difference(_sessionStartTime!);
      _sessionStartTime = null;
    }

    final totalDuration = _accumulatedTime;

    try {
      final recordedPath = await service.stopRecording();
      final path = recordedPath ?? state.tempFilePath;

      state = state.copyWith(
        status: RecordingStatus.preview,
        tempFilePath: path,
        duration: totalDuration,
        trimStartMs: 0,
        trimEndMs: totalDuration.inMilliseconds,
      );
    } catch (e) {
      debugPrint('Error stopping recording: $e');
      state = state.copyWith(
        status: RecordingStatus.error,
        errorMessage: 'Failed to stop recording: $e',
      );
    }
  }

  /// Discard the current recording and start fresh.
  Future<void> retakeRecording() async {
    _timer?.cancel();
    await _amplitudeSub?.cancel();
    await service.cancelRecording();
    await fileManager.deleteFile(state.tempFilePath);

    state = const RecordingSessionState();
    await startRecording();
  }

  /// Cancel current recording and reset to idle.
  Future<void> cancelRecording() async {
    _timer?.cancel();
    await _amplitudeSub?.cancel();
    await service.cancelRecording();
    await fileManager.deleteFile(state.tempFilePath);
    await fileManager.deleteFile(state.finalFilePath);

    state = const RecordingSessionState();
  }

  /// Update trim boundary in preview.
  void updateTrimRange({required int startMs, required int endMs}) {
    state = state.copyWith(
      trimStartMs: startMs,
      trimEndMs: endMs,
    );
  }

  /// Saves the recorded (and optionally trimmed) audio into PattuPetti/Recordings
  /// and registers it in the application library and optionally in a playlist.
  Future<bool> saveRecording({
    required String title,
    String? artist,
    String? album,
    String? genre,
    String? description,
    String? artworkPath,
    bool addToSongsLibrary = true,
    String? targetPlaylistId,
  }) async {
    final tempPath = state.tempFilePath;
    if (tempPath == null || tempPath.isEmpty) {
      state = state.copyWith(
        status: RecordingStatus.error,
        errorMessage: 'No recorded audio file found to save.',
      );
      return false;
    }

    final user = ref.read(authStateProvider).valueOrNull?.user;
    final effectiveUserId = user?.id ?? 'local-offline-user';

    state = state.copyWith(status: RecordingStatus.saving);

    try {
      // 1. Generate unique permanent target path in PattuPetti/Recordings
      final targetPath =
          await fileManager.generateUniqueRecordingPath(customTitle: title);

      // 2. Perform trim if requested, else copy
      final totalMs = state.duration.inMilliseconds;
      final trimStart = state.trimStartMs ?? 0;
      final trimEnd = state.trimEndMs ?? totalMs;
      final isTrimmed = trimStart > 0 || (trimEnd < totalMs && trimEnd > 0);

      int finalDurationMs = totalMs;
      if (isTrimmed && trimEnd > trimStart) {
        final startSec = trimStart / 1000.0;
        final durSec = (trimEnd - trimStart) / 1000.0;
        finalDurationMs = trimEnd - trimStart;

        await fileManager.trimAudio(
          inputPath: tempPath,
          outputPath: targetPath,
          startSeconds: startSec,
          durationSeconds: durSec,
        );
      } else {
        await fileManager.trimAudio(
          inputPath: tempPath,
          outputPath: targetPath,
          startSeconds: 0,
          durationSeconds: totalMs > 0 ? (totalMs / 1000.0) : 0.1,
        );
      }

      // 3. Remove temporary recording file
      await fileManager.deleteFile(tempPath);

      // 4. Determine itemType and genre
      final itemType = addToSongsLibrary ? 'song' : 'recording';
      final effectiveGenre = (genre != null && genre.trim().isNotEmpty)
          ? genre.trim()
          : 'Recording';

      // 5. Save into Drift local database
      final savedItem = await repository.saveRecording(
        userId: effectiveUserId,
        filePath: targetPath,
        title: title.trim().isNotEmpty ? title.trim() : 'Recording',
        artist: (artist != null && artist.trim().isNotEmpty)
            ? artist.trim()
            : 'Voice Recording',
        album: (album != null && album.trim().isNotEmpty)
            ? album.trim()
            : 'Recordings',
        genre: effectiveGenre,
        description: description?.trim(),
        artworkPath: artworkPath,
        durationMs: finalDurationMs,
        itemType: itemType,
      );

      // 6. If user selected a target playlist, add the item to that playlist
      if (targetPlaylistId != null && targetPlaylistId.isNotEmpty) {
        try {
          final db = ref.read(appDatabaseProvider);
          final existingItems = await db.getPlaylistItems(targetPlaylistId);
          await db.addToPlaylist(
            PlaylistItemsCompanion.insert(
              id: const Uuid().v4(),
              playlistId: targetPlaylistId,
              audioItemId: savedItem.id,
              position: existingItems.length,
            ),
          );
        } catch (e) {
          debugPrint('Error adding recording to playlist: $e');
        }
      }

      // 7. Invalidate library streams to update UI instantly across tabs & home
      ref.invalidate(allRecordingsProvider);
      ref.invalidate(allSongsProvider);
      ref.invalidate(recentlyAddedProvider);

      state = state.copyWith(
        status: RecordingStatus.saved,
        finalFilePath: targetPath,
        savedAudioItemId: savedItem.id,
      );

      return true;
    } catch (e) {
      debugPrint('Error saving recording: $e');
      state = state.copyWith(
        status: RecordingStatus.error,
        errorMessage: 'Failed to save recording: $e',
      );
      return false;
    }
  }

  /// Native share sheet for current recording
  Future<void> shareCurrentRecording({String? title}) async {
    final path = state.finalFilePath ?? state.tempFilePath;
    if (path == null) return;
    await RecordingFileManager.shareRecording(path, title: title);
  }

  @override
  void dispose() {
    _timer?.cancel();
    _amplitudeSub?.cancel();
    super.dispose();
  }
}
