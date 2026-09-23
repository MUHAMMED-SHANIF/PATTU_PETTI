import 'dart:io';
import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import '../../../../data/local/database/app_database.dart';
import '../../../../data/local/database/app_database_dao.dart';
import 'recording_file_manager.dart';

class RecordingRepository {
  const RecordingRepository({
    required this.db,
    required this.fileManager,
  });

  final AppDatabase db;
  final RecordingFileManager fileManager;

  /// Saves a recording into the application database as an AudioItem of type 'recording'.
  Future<AudioItem> saveRecording({
    required String userId,
    required String filePath,
    required String title,
    String? artist,
    String? album,
    String? genre,
    String? description,
    String? artworkPath,
    int? durationMs,
  }) async {
    final audioItemId = const Uuid().v4();
    final audioFileId = const Uuid().v4();

    int? fileSizeBytes;
    try {
      final file = File(filePath);
      if (await file.exists()) {
        fileSizeBytes = await file.length();
      }
    } catch (_) {}

    final itemCompanion = AudioItemsCompanion.insert(
      id: audioItemId,
      userId: userId,
      itemType: 'recording',
      title: title.isNotEmpty ? title : 'New Recording',
      artist: Value(artist ?? 'Unknown Artist'),
      album: Value(album ?? 'Recordings'),
      genre: Value(genre ?? 'Recording'),
      artworkPath: Value(artworkPath),
      durationMs: Value(durationMs),
    );

    await db.insertAudioItem(itemCompanion);

    final fileCompanion = AudioFilesCompanion.insert(
      id: audioFileId,
      audioItemId: audioItemId,
      filePath: filePath,
      fileSizeBytes: Value(fileSizeBytes),
      mimeType: const Value('audio/m4a'),
    );

    await db.insertAudioFile(fileCompanion);

    final savedItem = await db.getAudioItemById(audioItemId);
    return savedItem!;
  }

  /// Deletes a recording, removing both physical file and DB references.
  Future<void> deleteRecording(String audioItemId) async {
    // 1. Check & clean dependent clips
    try {
      final dependentClips = await db.getAllDependentClips(audioItemId);
      for (final clip in dependentClips) {
        await db.deleteAudioItem(clip.audioItemId);
      }
    } catch (_) {}

    // 2. Lookup physical file and remove
    final fileRef = await db.getFileForItem(audioItemId);
    if (fileRef != null && fileRef.filePath.isNotEmpty) {
      await fileManager.deleteFile(fileRef.filePath);
    }

    // 3. Delete database record (cascading removes AudioFiles & PlaylistItems)
    await db.deleteAudioItem(audioItemId);
  }

  /// Updates recording title or metadata.
  Future<void> updateMetadata({
    required String audioItemId,
    required String title,
    String? artist,
    String? album,
    String? genre,
    String? artworkPath,
  }) async {
    await (db.update(db.audioItems)..where((t) => t.id.equals(audioItemId))).write(
      AudioItemsCompanion(
        title: Value(title),
        artist: Value(artist),
        album: Value(album),
        genre: Value(genre),
        artworkPath: Value(artworkPath),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }
}
