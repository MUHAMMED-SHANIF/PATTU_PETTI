import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
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
        ..where((t) =>
            t.userId.equals(userId) &
            (t.itemType.equals('recording') |
                (t.itemType.equals('song') & t.genre.equals('Recording'))) &
            t.isAvailable.equals(true))
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

  Stream<List<AudioItem>> watchRecentlyPlayed(String userId, {int limit = 100}) =>
      (select(audioItems)
        ..where((t) => t.userId.equals(userId) & t.lastPlayedAt.isNotNull() & t.isAvailable.equals(true))
        ..orderBy([(t) => OrderingTerm.desc(t.lastPlayedAt)])
        ..limit(limit))
          .watch();

  Stream<List<AudioItem>> watchMostPlayed(String userId, {int limit = 100}) =>
      (select(audioItems)
        ..where((t) => t.userId.equals(userId) & t.playCount.isBiggerThanValue(0) & t.isAvailable.equals(true))
        ..orderBy([(t) => OrderingTerm.desc(t.playCount)])
        ..limit(limit))
          .watch();

  Stream<List<AudioItem>> watchRecentlyAdded(String userId, {int limit = 100}) =>
      (select(audioItems)
        ..where((t) => t.userId.equals(userId) & t.isAvailable.equals(true))
        ..orderBy([(t) => OrderingTerm.desc(t.createdAt)])
        ..limit(limit))
          .watch();

  Stream<List<AudioItem>> watchAllRecordings(String userId) =>
      (select(audioItems)
        ..where((t) =>
            t.userId.equals(userId) &
            (t.itemType.equals('recording') |
                (t.itemType.equals('song') & t.genre.equals('Recording'))) &
            t.isAvailable.equals(true))
        ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
          .watch();

  Stream<List<AudioItem>> watchLongAudio(String userId, {int thresholdMs = 600000}) =>
      (select(audioItems)
        ..where((t) =>
            t.userId.equals(userId) &
            t.durationMs.isBiggerOrEqualValue(thresholdMs) &
            t.isAvailable.equals(true))
        ..orderBy([(t) => OrderingTerm.desc(t.durationMs)]))
          .watch();

  Future<List<AudioItem>> getLongAudio(String userId, {int thresholdMs = 600000}) =>
      (select(audioItems)
        ..where((t) =>
            t.userId.equals(userId) &
            t.durationMs.isBiggerOrEqualValue(thresholdMs) &
            t.isAvailable.equals(true))
        ..orderBy([(t) => OrderingTerm.desc(t.durationMs)]))
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

/// Joined result for a playlist item containing audio item, optional file, and optional clip record.
class PlaylistItemJoinedData {
  final PlaylistItem item;
  final AudioItem audio;
  final AudioFile? file;
  final ClipRecord? clip;

  PlaylistItemJoinedData({
    required this.item,
    required this.audio,
    this.file,
    this.clip,
  });
}

/// Aggregated stats for a playlist.
class PlaylistWithStats {
  final Playlist playlist;
  final int itemCount;
  final int totalDurationMs;

  PlaylistWithStats({
    required this.playlist,
    required this.itemCount,
    required this.totalDurationMs,
  });
}

/// DAO for playlists.
extension PlaylistsDao on AppDatabase {
  Stream<List<Playlist>> watchPlaylists(String userId) =>
      (select(playlists)
        ..where((t) => t.userId.equals(userId))
        ..orderBy([(t) => OrderingTerm.desc(t.updatedAt), (t) => OrderingTerm.asc(t.name)]))
          .watch();

  Stream<List<Playlist>> watchLikedPlaylists(String userId) =>
      (select(playlists)
        ..where((t) => t.userId.equals(userId) & t.isLiked.equals(true))
        ..orderBy([(t) => OrderingTerm.desc(t.updatedAt)]))
          .watch();

  Stream<List<PlaylistWithStats>> watchPlaylistsWithStats(String userId) {
    return watchPlaylists(userId).asyncMap((list) async {
      final result = <PlaylistWithStats>[];
      for (final pl in list) {
        final items = await getPlaylistItemsJoined(pl.id);
        int totalDur = 0;
        for (final it in items) {
          totalDur += it.audio.durationMs ?? 0;
        }
        result.add(PlaylistWithStats(
          playlist: pl,
          itemCount: items.length,
          totalDurationMs: totalDur,
        ));
      }
      return result;
    });
  }

  Future<Playlist?> getPlaylistById(String id) =>
      (select(playlists)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<void> insertPlaylist(PlaylistsCompanion playlist) =>
      into(playlists).insertOnConflictUpdate(playlist);

  Future<void> updatePlaylist(PlaylistsCompanion playlist) =>
      (update(playlists)..where((t) => t.id.equals(playlist.id.value))).write(playlist);

  Future<int> deletePlaylist(String id) => transaction(() async {
    await (delete(playlistItems)..where((t) => t.playlistId.equals(id))).go();
    return (delete(playlists)..where((t) => t.id.equals(id))).go();
  });

  Future<List<PlaylistItem>> getPlaylistItems(String playlistId) =>
      (select(playlistItems)
        ..where((t) => t.playlistId.equals(playlistId))
        ..orderBy([(t) => OrderingTerm.asc(t.position)]))
          .get();

  Stream<List<PlaylistItemJoinedData>> watchPlaylistItemsJoined(String playlistId) {
    final query = select(playlistItems).join([
      innerJoin(audioItems, audioItems.id.equalsExp(playlistItems.audioItemId)),
      leftOuterJoin(audioFiles, audioFiles.audioItemId.equalsExp(audioItems.id)),
      leftOuterJoin(clipRecords, clipRecords.audioItemId.equalsExp(audioItems.id)),
    ])
      ..where(playlistItems.playlistId.equals(playlistId))
      ..orderBy([OrderingTerm.asc(playlistItems.position)]);

    return query.watch().map((rows) {
      return rows.map((row) {
        return PlaylistItemJoinedData(
          item: row.readTable(playlistItems),
          audio: row.readTable(audioItems),
          file: row.readTableOrNull(audioFiles),
          clip: row.readTableOrNull(clipRecords),
        );
      }).toList();
    });
  }

  Future<List<PlaylistItemJoinedData>> getPlaylistItemsJoined(String playlistId) async {
    final query = select(playlistItems).join([
      innerJoin(audioItems, audioItems.id.equalsExp(playlistItems.audioItemId)),
      leftOuterJoin(audioFiles, audioFiles.audioItemId.equalsExp(audioItems.id)),
      leftOuterJoin(clipRecords, clipRecords.audioItemId.equalsExp(audioItems.id)),
    ])
      ..where(playlistItems.playlistId.equals(playlistId))
      ..orderBy([OrderingTerm.asc(playlistItems.position)]);

    final rows = await query.get();
    return rows.map((row) {
      return PlaylistItemJoinedData(
        item: row.readTable(playlistItems),
        audio: row.readTable(audioItems),
        file: row.readTableOrNull(audioFiles),
        clip: row.readTableOrNull(clipRecords),
      );
    }).toList();
  }

  Future<void> addToPlaylist(PlaylistItemsCompanion item) =>
      into(playlistItems).insertOnConflictUpdate(item);

  Future<int> addItemsToPlaylist(String playlistId, List<String> audioItemIds) async {
    final existing = await getPlaylistItems(playlistId);
    final existingIds = existing.map((e) => e.audioItemId).toSet();
    int maxPos = existing.isEmpty ? 0 : existing.map((e) => e.position).fold(0, (max, p) => p > max ? p : max);
    int addedCount = 0;

    await transaction(() async {
      for (final id in audioItemIds) {
        if (!existingIds.contains(id)) {
          maxPos++;
          await into(playlistItems).insert(
            PlaylistItemsCompanion.insert(
              id: const Uuid().v4(),
              playlistId: playlistId,
              audioItemId: id,
              position: maxPos,
              addedAt: Value(DateTime.now()),
            ),
          );
          existingIds.add(id);
          addedCount++;
        }
      }
      if (addedCount > 0) {
        await (update(playlists)..where((t) => t.id.equals(playlistId))).write(
          PlaylistsCompanion(updatedAt: Value(DateTime.now())),
        );
      }
    });

    return addedCount;
  }

  Future<void> reorderPlaylist(String playlistId, List<String> orderedAudioItemIds) async {
    await transaction(() async {
      for (int i = 0; i < orderedAudioItemIds.length; i++) {
        final audioId = orderedAudioItemIds[i];
        await (update(playlistItems)
          ..where((t) => t.playlistId.equals(playlistId) & t.audioItemId.equals(audioId)))
          .write(PlaylistItemsCompanion(position: Value(i)));
      }
      await (update(playlists)..where((t) => t.id.equals(playlistId))).write(
        PlaylistsCompanion(updatedAt: Value(DateTime.now())),
      );
    });
  }

  Future<void> togglePlaylistLike(String playlistId, bool isLiked) async {
    await (update(playlists)..where((t) => t.id.equals(playlistId))).write(
      PlaylistsCompanion(
        isLiked: Value(isLiked),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<String?> duplicatePlaylist(String playlistId, String newName) async {
    final source = await getPlaylistById(playlistId);
    if (source == null) return null;
    final newId = const Uuid().v4();
    final items = await getPlaylistItems(playlistId);

    await transaction(() async {
      await into(playlists).insert(
        PlaylistsCompanion.insert(
          id: newId,
          userId: source.userId,
          name: newName,
          description: Value(source.description),
          artworkPath: Value(source.artworkPath),
          isLiked: const Value(false),
          isSmart: Value(source.isSmart),
          smartCriteria: Value(source.smartCriteria),
          createdAt: Value(DateTime.now()),
          updatedAt: Value(DateTime.now()),
        ),
      );
      for (final item in items) {
        await into(playlistItems).insert(
          PlaylistItemsCompanion.insert(
            id: const Uuid().v4(),
            playlistId: newId,
            audioItemId: item.audioItemId,
            position: item.position,
            addedAt: Value(DateTime.now()),
          ),
        );
      }
    });
    return newId;
  }

  Future<void> removeFromPlaylist(String playlistId, String audioItemId) async {
    await (delete(playlistItems)
      ..where((t) => t.playlistId.equals(playlistId) & t.audioItemId.equals(audioItemId)))
      .go();
    await (update(playlists)..where((t) => t.id.equals(playlistId))).write(
      PlaylistsCompanion(updatedAt: Value(DateTime.now())),
    );
  }

  Future<List<Playlist>> searchPlaylists(String userId, String query) async {
    final cleanQuery = '%${query.toLowerCase()}%';
    return (select(playlists)
      ..where((t) =>
          t.userId.equals(userId) &
          (t.name.lower().like(cleanQuery) | t.description.lower().like(cleanQuery)))
      ..orderBy([(t) => OrderingTerm.asc(t.name)]))
        .get();
  }
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
