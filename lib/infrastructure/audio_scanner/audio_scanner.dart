import 'dart:io';
import 'package:audio_metadata_reader/audio_metadata_reader.dart';
import 'package:crypto/crypto.dart';
import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:path/path.dart' as p;
import 'package:uuid/uuid.dart';
import '../../core/constants/app_constants.dart';
import '../../data/local/database/app_database.dart';
import '../../data/local/database/app_database_dao.dart';
import '../../shared/providers/global_providers.dart';


final audioScannerProvider = Provider<AudioScanner>((ref) {
  return AudioScanner(db: ref.watch(appDatabaseProvider));
});

/// Audio file scanner for local library.
/// - Scans registered folders for audio files
/// - Reads metadata using audio_metadata_reader
/// - Detects duplicates via SHA-256 hash
/// - Detects missing/moved files
/// - Does NOT upload or modify original files
class AudioScanner {
  AudioScanner({required this.db});

  final AppDatabase db;
  static const _uuid = Uuid();
  final OnAudioQuery _audioQuery = OnAudioQuery();

  /// Scan all registered folder sources for a user.
  /// [onProgress] — called with current file and total count during scan.
  Future<ScanResult> scanAllFolders({
    required String userId,
    void Function(int current, int total, String currentFile)? onProgress,
  }) async {
    final folders = await db.getFolderSources(userId);
    if (folders.isEmpty) {
      // Also scan device media store for convenience
      return _scanMediaStore(userId: userId, onProgress: onProgress);
    }

    int newCount = 0;
    int updatedCount = 0;
    int missingCount = 0;
    final errors = <String>[];

    final allFiles = <File>[];
    for (final folder in folders) {
      final dir = Directory(folder.folderPath);
      if (!dir.existsSync()) {
        missingCount++;
        continue;
      }
      final files = dir
          .listSync(recursive: true)
          .whereType<File>()
          .where((f) => _isSupportedAudio(f.path))
          .toList();
      allFiles.addAll(files);
    }

    for (int i = 0; i < allFiles.length; i++) {
      final file = allFiles[i];
      onProgress?.call(i + 1, allFiles.length, p.basename(file.path));

      try {
        final result = await _processFile(file: file, userId: userId);
        if (result == _ProcessResult.added) newCount++;
        if (result == _ProcessResult.updated) updatedCount++;
      } catch (e) {
        errors.add('${p.basename(file.path)}: ${e.toString()}');
      }
    }

    // Check for missing files
    final songs = await db.getAllSongs(userId);
    for (final song in songs) {
      if (song.isAvailable) {
        final fileRecord = await db.getFileForItem(song.id);
        if (fileRecord != null && !File(fileRecord.filePath).existsSync()) {
          await db.markUnavailable(song.id);
          await db.markFileUnavailable(fileRecord.filePath);
          missingCount++;
        }
      }
    }

    return ScanResult(
      newItems: newCount,
      updatedItems: updatedCount,
      missingItems: missingCount,
      errors: errors,
    );
  }

  /// Add multiple audio files directly (picked by file picker).
  Future<ScanResult> addFiles({
    required List<File> files,
    required String userId,
    void Function(int current, int total, String currentFile)? onProgress,
  }) async {
    int newCount = 0;
    int updatedCount = 0;
    final errors = <String>[];

    for (int i = 0; i < files.length; i++) {
      final file = files[i];
      if (!_isSupportedAudio(file.path)) continue;
      onProgress?.call(i + 1, files.length, p.basename(file.path));

      try {
        final result = await _processFile(file: file, userId: userId);
        if (result == _ProcessResult.added) newCount++;
        if (result == _ProcessResult.updated) updatedCount++;
      } catch (e) {
        errors.add('${p.basename(file.path)}: ${e.toString()}');
      }
    }

    return ScanResult(
      newItems: newCount,
      updatedItems: updatedCount,
      missingItems: 0,
      errors: errors,
    );
  }

  /// Register a folder source in DB and scan all audio inside it immediately.
  Future<ScanResult> addFolderSourceAndScan({
    required String folderPath,
    required String userId,
    void Function(int current, int total, String currentFile)? onProgress,
  }) async {
    await db.insertFolderSource(FolderSourcesCompanion.insert(
      userId: userId,
      folderPath: folderPath,
      displayName: Value(p.basename(folderPath)),
      isActive: const Value(true),
    ));

    return scanFolder(folderPath: folderPath, userId: userId, onProgress: onProgress);
  }

  /// Scan a specific folder for audio files.
  Future<ScanResult> scanFolder({
    required String folderPath,
    required String userId,
    void Function(int current, int total, String currentFile)? onProgress,
  }) async {
    final dir = Directory(folderPath);
    if (!dir.existsSync()) {
      return const ScanResult(
        newItems: 0,
        updatedItems: 0,
        missingItems: 1,
        errors: ['Directory does not exist'],
      );
    }

    int newCount = 0;
    int updatedCount = 0;
    final errors = <String>[];
    final files = dir
        .listSync(recursive: true)
        .whereType<File>()
        .where((f) => _isSupportedAudio(f.path))
        .toList();

    for (int i = 0; i < files.length; i++) {
      final file = files[i];
      onProgress?.call(i + 1, files.length, p.basename(file.path));

      try {
        final result = await _processFile(file: file, userId: userId);
        if (result == _ProcessResult.added) newCount++;
        if (result == _ProcessResult.updated) updatedCount++;
      } catch (e) {
        errors.add('${p.basename(file.path)}: ${e.toString()}');
      }
    }

    return ScanResult(
      newItems: newCount,
      updatedItems: updatedCount,
      missingItems: 0,
      errors: errors,
    );
  }

  /// Remove a registered folder source.
  Future<void> removeFolderSource(int folderId) =>
      db.removeFolderSource(folderId);

  /// Quick scan using Android MediaStore (faster, uses system index).
  Future<ScanResult> _scanMediaStore({
    required String userId,
    void Function(int current, int total, String currentFile)? onProgress,
  }) async {
    final errors = <String>[];
    try {
      final hasPermission = await _audioQuery.checkAndRequest(retryRequest: true);
      if (!hasPermission) {
        return const ScanResult(
          newItems: 0,
          updatedItems: 0,
          missingItems: 0,
          errors: ['Storage/audio permission not granted.'],
        );
      }

      final songs = await _audioQuery.querySongs(
        sortType: SongSortType.DATE_ADDED,
        orderType: OrderType.DESC_OR_GREATER,
      );

      int newCount = 0;

      for (int i = 0; i < songs.length; i++) {
        final song = songs[i];
        if (song.data.isEmpty) continue;
        final file = File(song.data);
        onProgress?.call(i + 1, songs.length, song.title.isNotEmpty ? song.title : p.basename(song.data));

        try {
          final result = await _processFile(file: file, userId: userId);
          if (result == _ProcessResult.added) newCount++;
        } catch (e) {
          errors.add(e.toString());
        }
      }

      return ScanResult(newItems: newCount, updatedItems: 0, missingItems: 0, errors: errors);
    } catch (e) {
      return ScanResult(newItems: 0, updatedItems: 0, missingItems: 0, errors: [e.toString()]);
    }
  }

  /// Process a single audio file: check for duplicate, read metadata, store.
  Future<_ProcessResult> _processFile({
    required File file,
    required String userId,
  }) async {
    if (!file.existsSync()) return _ProcessResult.skipped;

    // Compute hash for duplicate detection (first 1MB for speed)
    final hash = await _computeFileHash(file);

    // Check if we already have this file by hash
    final existing = await db.getFileByHash(hash);
    if (existing != null) {
      // File already indexed; check if path changed (moved file)
      if (existing.filePath != file.path) {
        await db.updateFilePath(existing.id, file.path);
        return _ProcessResult.updated;
      }
      return _ProcessResult.skipped;
    }

    // Read metadata
    final metadata = await _readMetadata(file);
    final itemId = _uuid.v4();
    final fileId = _uuid.v4();

    // Extract and cache artwork
    String? artworkPath;
    if (metadata.artwork != null) {
      artworkPath = await _saveArtwork(metadata.artwork!, itemId);
    }

    // Insert audio item
    await db.insertAudioItem(AudioItemsCompanion.insert(
      id: itemId,
      userId: userId,
      itemType: 'song',
      title: metadata.title ?? p.basenameWithoutExtension(file.path),
      artist: Value(metadata.artist),
      album: Value(metadata.album),
      albumArtist: const Value(null),
      genre: Value(metadata.genre),
      year: Value(metadata.year),
      trackNumber: Value(metadata.trackNumber),
      durationMs: Value(metadata.durationMs),
      artworkPath: Value(artworkPath),
    ));

    // Insert file record
    await db.insertAudioFile(AudioFilesCompanion.insert(
      id: fileId,
      audioItemId: itemId,
      filePath: file.path,
      fileHash: Value(hash),
      fileSizeBytes: Value(await file.length()),
      mimeType: Value(_mimeTypeFromExtension(p.extension(file.path))),
    ));

    return _ProcessResult.added;
  }

  Future<String> _computeFileHash(File file) async {
    final raf = await file.open();
    final bytes = await raf.read(1024 * 1024); // First 1MB
    await raf.close();
    return sha256.convert(bytes).toString();
  }

  Future<_AudioMetadata> _readMetadata(File file) async {
    try {
      final tag = readMetadata(file, getImage: true);
      // AudioMetadata.year is DateTime?, extract int year
      final yearInt = tag.year?.year;
      // genres is List<String> (not nullable)
      final genre = tag.genres.isNotEmpty ? tag.genres.first : null;
      return _AudioMetadata(
        title: tag.title,
        artist: tag.artist,
        album: tag.album,
        genre: genre,
        year: yearInt,
        trackNumber: tag.trackNumber,
        durationMs: tag.duration?.inMilliseconds,
        artwork: tag.pictures.firstOrNull?.bytes,
      );
    } catch (_) {
      return _AudioMetadata();
    }
  }

  Future<String?> _saveArtwork(List<int> bytes, String itemId) async {
    try {
      final dir = Directory(
        '${(await _getAppDocDir()).path}/${AppConstants.folderArtwork}',
      );
      await dir.create(recursive: true);
      final artFile = File('${dir.path}/$itemId.jpg');
      await artFile.writeAsBytes(bytes);
      return artFile.path;
    } catch (_) {
      return null;
    }
  }

  Future<Directory> _getAppDocDir() async {
    // Use external if available (Android), fall back to app documents
    try {
      final external = Directory('/storage/emulated/0');
      if (external.existsSync()) return external;
    } catch (_) {}
    return Directory('.');
  }

  bool _isSupportedAudio(String path) {
    final ext = p.extension(path).toLowerCase().replaceFirst('.', '');
    return AppConstants.supportedAudioExtensions.contains(ext);
  }

  String _mimeTypeFromExtension(String ext) {
    return switch (ext.toLowerCase().replaceFirst('.', '')) {
      'mp3' => 'audio/mpeg',
      'aac' => 'audio/aac',
      'm4a' => 'audio/mp4',
      'flac' => 'audio/flac',
      'wav' => 'audio/wav',
      'ogg' => 'audio/ogg',
      'opus' => 'audio/opus',
      'aiff' || 'aif' => 'audio/aiff',
      _ => 'audio/*',
    };
  }
}

enum _ProcessResult { added, updated, skipped }

class _AudioMetadata {
  _AudioMetadata({
    this.title,
    this.artist,
    this.album,
    this.genre,
    this.year,
    this.trackNumber,
    this.durationMs,
    this.artwork,
  });

  final String? title;
  final String? artist;
  final String? album;
  final String? genre;
  final int? year;
  final int? trackNumber;
  final int? durationMs;
  final List<int>? artwork;
}

class ScanResult {
  const ScanResult({
    required this.newItems,
    required this.updatedItems,
    required this.missingItems,
    required this.errors,
  });

  final int newItems;
  final int updatedItems;
  final int missingItems;
  final List<String> errors;

  bool get hasErrors => errors.isNotEmpty;
  int get totalProcessed => newItems + updatedItems;
}
