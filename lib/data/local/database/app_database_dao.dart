import 'package:drift/drift.dart';
import 'app_database.dart';

/// DAO for all audio item operations.
/// Handles songs, clips, merged tracks, and recordings.
extension AudioItemsDao on AppDatabase {
  // ─── Read ───────────────────────────────────────────────
  Future<List<AudioItem>> getAllSongs(String userId) =>
      (select(audioItems)
        ..where((t) => t.userId.equals(userId) & t.itemType.equals('song') & t.isAvailable.equals(true))
        ..orderBy([(t) => OrderingTerm.asc(t.title)]))
          .get();

  Future<List<AudioItem>> getAllClips(String userId) =>
      (select(audioItems)
        ..where((t) => t.userId.equals(userId) & t.itemType.equals('clip') & t.isAvailable.equals(true))
        ..orderBy([(t) => OrderingTerm.asc(t.title)]))
          .get();

  Future<List<AudioItem>> getAllMerged(String userId) =>
      (select(audioItems)
        ..where((t) => t.userId.equals(userId) & t.itemType.equals('merged') & t.isAvailable.equals(true))
        ..orderBy([(t) => OrderingTerm.asc(t.title)]))
          .get();

  Future<List<AudioItem>> getAllRecordings(String userId) =>
      (select(audioItems)
        ..where((t) => t.userId.equals(userId) & t.itemType.equals('recording') & t.isAvailable.equals(true))
        ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
          .get();

  Future<AudioItem?> getAudioItemById(String id) =>
      (select(audioItems)..where((t) => t.id.equals(id))).getSingleOrNull();

  Stream<List<AudioItem>> watchAllSongs(String userId) =>
      (select(audioItems)
        ..where((t) => t.userId.equals(userId) & t.itemType.equals('song') & t.isAvailable.equals(true))
        ..orderBy([(t) => OrderingTerm.asc(t.title)]))
          .watch();

  Stream<List<AudioItem>> watchLikedSongs(String userId) =>
      (select(audioItems)
        ..where((t) =>
            t.userId.equals(userId) &
            t.isLiked.equals(true) &
            t.isAvailable.equals(true))
        ..orderBy([(t) => OrderingTerm.asc(t.title)]))
          .watch();

  Stream<List<AudioItem>> watchStarredClips(String userId) =>
      (select(audioItems)
        ..where((t) =>
            t.userId.equals(userId) &
            t.starNumber.isNotNull() &
            t.itemType.equals('clip') &
            t.isAvailable.equals(true))
        ..orderBy([(t) => OrderingTerm.asc(t.starNumber)]))
          .watch();

  Future<List<AudioItem>> getRecentlyPlayed(String userId, {int limit = 20}) =>
      (select(audioItems)
        ..where((t) => t.userId.equals(userId) & t.lastPlayedAt.isNotNull() & t.isAvailable.equals(true))
        ..orderBy([(t) => OrderingTerm.desc(t.lastPlayedAt)])
        ..limit(limit))
          .get();

  Future<List<AudioItem>> getMostPlayed(String userId, {int limit = 20}) =>
      (select(audioItems)
        ..where((t) => t.userId.equals(userId) & t.playCount.isBiggerThanValue(0) & t.isAvailable.equals(true))
        ..orderBy([(t) => OrderingTerm.desc(t.playCount)])
        ..limit(limit))
          .get();

  Future<List<AudioItem>> getRecentlyAdded(String userId, {int limit = 20}) =>
      (select(audioItems)
        ..where((t) => t.userId.equals(userId) & t.isAvailable.equals(true))
        ..orderBy([(t) => OrderingTerm.desc(t.createdAt)])
        ..limit(limit))
          .get();

  // ─── Write ──────────────────────────────────────────────
  Future<void> insertAudioItem(AudioItemsCompanion item) =>
      into(audioItems).insertOnConflictUpdate(item);

  Future<void> updateAudioItem(AudioItemsCompanion item) =>
      (update(audioItems)..where((t) => t.id.equals(item.id.value))).write(item);

  Future<void> toggleLike(String id, bool liked) =>
      (update(audioItems)..where((t) => t.id.equals(id))).write(
        AudioItemsCompanion(isLiked: Value(liked), updatedAt: Value(DateTime.now())),
      );

  Future<void> updateStarNumber(String id, int? starNumber) =>
      (update(audioItems)..where((t) => t.id.equals(id))).write(
        AudioItemsCompanion(starNumber: Value(starNumber), updatedAt: Value(DateTime.now())),
      );

  Future<void> incrementPlayCount(String id) async {
    final item = await getAudioItemById(id);
    if (item == null) return;
    await (update(audioItems)..where((t) => t.id.equals(id))).write(
      AudioItemsCompanion(
        playCount: Value(item.playCount + 1),
        lastPlayedAt: Value(DateTime.now()),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<void> updateResumePosition(String id, int positionMs) =>
      (update(audioItems)..where((t) => t.id.equals(id))).write(
        AudioItemsCompanion(
          resumePositionMs: Value(positionMs),
          updatedAt: Value(DateTime.now()),
        ),
      );

  Future<void> markUnavailable(String id) =>
      (update(audioItems)..where((t) => t.id.equals(id))).write(
        AudioItemsCompanion(
          isAvailable: const Value(false),
          updatedAt: Value(DateTime.now()),
        ),
      );

  Future<int> deleteAudioItem(String id) =>
      (delete(audioItems)..where((t) => t.id.equals(id))).go();
}

/// DAO for audio file references.
extension AudioFilesDao on AppDatabase {
  Future<AudioFile?> getFileByPath(String path) =>
      (select(audioFiles)..where((t) => t.filePath.equals(path))).getSingleOrNull();

  Future<AudioFile?> getFileByHash(String hash) =>
      (select(audioFiles)..where((t) => t.fileHash.equals(hash))).getSingleOrNull();

  Future<AudioFile?> getFileForItem(String audioItemId) =>
      (select(audioFiles)..where((t) => t.audioItemId.equals(audioItemId))).getSingleOrNull();

  Future<void> insertAudioFile(AudioFilesCompanion file) =>
      into(audioFiles).insertOnConflictUpdate(file);

  Future<void> markFileUnavailable(String filePath) =>
      (update(audioFiles)..where((t) => t.filePath.equals(filePath))).write(
        AudioFilesCompanion(
          isAvailable: const Value(false),
          lastVerifiedAt: Value(DateTime.now()),
        ),
      );

  Future<void> updateFilePath(String id, String newPath) =>
      (update(audioFiles)..where((t) => t.id.equals(id))).write(
        AudioFilesCompanion(filePath: Value(newPath)),
      );
}

/// DAO for virtual clip operations.
extension ClipRecordsDao on AppDatabase {
  Future<ClipRecord?> getClipRecord(String audioItemId) =>
      (select(clipRecords)..where((t) => t.audioItemId.equals(audioItemId))).getSingleOrNull();

  Future<List<ClipRecord>> getClipsForSource(String sourceAudioItemId) =>
      (select(clipRecords)
        ..where((t) => t.sourceAudioItemId.equals(sourceAudioItemId)))
          .get();

  Future<List<ClipRecord>> getNestedClips(String parentClipId) =>
      (select(clipRecords)
        ..where((t) => t.parentClipId.equals(parentClipId)))
          .get();

  Future<void> insertClipRecord(ClipRecordsCompanion clip) =>
      into(clipRecords).insertOnConflictUpdate(clip);

  Future<void> markClipPhysical(String clipId) =>
      (update(clipRecords)..where((t) => t.id.equals(clipId))).write(
        const ClipRecordsCompanion(isPhysical: Value(true)),
      );

  Future<int> deleteClipRecord(String audioItemId) =>
      (delete(clipRecords)..where((t) => t.audioItemId.equals(audioItemId))).go();

  /// Returns all clips that depend on a given source (including nested ones).
  Future<List<ClipRecord>> getAllDependentClips(String sourceAudioItemId) async {
    final direct = await getClipsForSource(sourceAudioItemId);
    final List<ClipRecord> all = [...direct];
    for (final clip in direct) {
      final nested = await getAllDependentClips(clip.audioItemId);
      all.addAll(nested);
    }
    return all;
  }
}

/// DAO for merged tracks.
extension MergedTracksDao on AppDatabase {
  Future<MergedTrack?> getMergedTrack(String id) =>
      (select(mergedTracks)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<List<MergeItem>> getMergeItems(String mergedTrackId) =>
      (select(mergeItems)
        ..where((t) => t.mergedTrackId.equals(mergedTrackId))
        ..orderBy([(t) => OrderingTerm.asc(t.position)]))
          .get();

  Future<void> insertMergedTrack(MergedTracksCompanion track) =>
      into(mergedTracks).insertOnConflictUpdate(track);

  Future<void> insertMergeItem(MergeItemsCompanion item) =>
      into(mergeItems).insert(item);

  Future<void> deleteMergeItems(String mergedTrackId) =>
      (delete(mergeItems)..where((t) => t.mergedTrackId.equals(mergedTrackId))).go();
}

/// DAO for playlists.
extension PlaylistsDao on AppDatabase {
  Stream<List<Playlist>> watchPlaylists(String userId) =>
      (select(playlists)
        ..where((t) => t.userId.equals(userId))
        ..orderBy([(t) => OrderingTerm.asc(t.name)]))
          .watch();

  Future<Playlist?> getPlaylistById(String id) =>
      (select(playlists)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<void> insertPlaylist(PlaylistsCompanion playlist) =>
      into(playlists).insertOnConflictUpdate(playlist);

  Future<void> updatePlaylist(PlaylistsCompanion playlist) =>
      (update(playlists)..where((t) => t.id.equals(playlist.id.value))).write(playlist);

  Future<int> deletePlaylist(String id) =>
      (delete(playlists)..where((t) => t.id.equals(id))).go();

  Future<List<PlaylistItem>> getPlaylistItems(String playlistId) =>
      (select(playlistItems)
        ..where((t) => t.playlistId.equals(playlistId))
        ..orderBy([(t) => OrderingTerm.asc(t.position)]))
          .get();

  Future<void> addToPlaylist(PlaylistItemsCompanion item) =>
      into(playlistItems).insertOnConflictUpdate(item);

  Future<void> removeFromPlaylist(String playlistId, String audioItemId) =>
      (delete(playlistItems)
        ..where((t) => t.playlistId.equals(playlistId) & t.audioItemId.equals(audioItemId)))
          .go();
}

/// DAO for queue and history.
extension QueueHistoryDao on AppDatabase {
  Future<QueueSnapshotData?> getQueueSnapshot(String userId) =>
      (select(queueSnapshot)..where((t) => t.userId.equals(userId))).getSingleOrNull();

  Future<void> saveQueueSnapshot(QueueSnapshotCompanion snapshot) =>
      into(queueSnapshot).insertOnConflictUpdate(snapshot);

  Future<void> insertHistoryEntry(PlayHistoryCompanion entry) =>
      into(playHistory).insert(entry);

  Future<List<PlayHistoryData>> getRecentHistory(String userId, {int limit = 100}) =>
      (select(playHistory)
        ..where((t) => t.userId.equals(userId))
        ..orderBy([(t) => OrderingTerm.desc(t.playedAt)])
        ..limit(limit))
          .get();
}

/// DAO for feature flags and folder sources.
extension SettingsDao on AppDatabase {
  Future<List<FolderSource>> getFolderSources(String userId) =>
      (select(folderSources)
        ..where((t) => t.userId.equals(userId) & t.isActive.equals(true)))
          .get();

  Stream<List<FolderSource>> watchFolderSources(String userId) =>
      (select(folderSources)
        ..where((t) => t.userId.equals(userId) & t.isActive.equals(true)))
          .watch();

  Future<void> insertFolderSource(FolderSourcesCompanion source) =>
      into(folderSources).insertOnConflictUpdate(source);

  Future<void> removeFolderSource(int id) =>
      (delete(folderSources)..where((t) => t.id.equals(id))).go();

  Future<List<LocalFeatureFlag>> getAllFeatureFlags() =>
      select(localFeatureFlags).get();

  Future<bool?> getFeatureFlag(String key, String userId) async {
    // Check user override first
    final override = await (select(localFeatureOverrides)
      ..where((t) => t.userId.equals(userId) & t.featureKey.equals(key)))
        .getSingleOrNull();
    if (override != null) return override.enabled;
    // Fall back to global flag
    final flag = await (select(localFeatureFlags)
      ..where((t) => t.featureKey.equals(key)))
        .getSingleOrNull();
    return flag?.enabled;
  }

  Future<void> upsertFeatureFlag(LocalFeatureFlagsCompanion flag) =>
      into(localFeatureFlags).insertOnConflictUpdate(flag);

  Future<void> upsertFeatureOverride(LocalFeatureOverridesCompanion override) =>
      into(localFeatureOverrides).insertOnConflictUpdate(override);
}
