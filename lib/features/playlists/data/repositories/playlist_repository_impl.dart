import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import '../../../../data/local/database/app_database.dart';
import '../../../../data/local/database/app_database_dao.dart';
import '../../../../domain/entities/audio_item_entity.dart';
import '../../domain/entities/playlist_entity.dart';
import '../../domain/repositories/playlist_repository.dart';

class PlaylistRepositoryImpl implements PlaylistRepository {
  const PlaylistRepositoryImpl(this._db);

  final AppDatabase _db;

  @override
  Stream<List<PlaylistEntity>> watchPlaylists(String userId) {
    return _db.watchPlaylistsWithStats(userId).map((list) {
      return list.map((item) {
        return PlaylistEntity(
          id: item.playlist.id,
          userId: item.playlist.userId,
          name: item.playlist.name,
          description: item.playlist.description,
          artworkPath: item.playlist.artworkPath,
          isLiked: item.playlist.isLiked,
          isSmart: item.playlist.isSmart,
          smartCriteria: item.playlist.smartCriteria,
          itemCount: item.itemCount,
          totalDurationMs: item.totalDurationMs,
          createdAt: item.playlist.createdAt,
          updatedAt: item.playlist.updatedAt,
        );
      }).toList();
    });
  }

  @override
  Stream<List<PlaylistEntity>> watchLikedPlaylists(String userId) {
    return watchPlaylists(userId).map((list) => list.where((p) => p.isLiked).toList());
  }

  @override
  Future<PlaylistEntity?> getPlaylist(String playlistId) async {
    final pl = await _db.getPlaylistById(playlistId);
    if (pl == null) return null;
    final items = await _db.getPlaylistItemsJoined(playlistId);
    int totalDur = 0;
    for (final it in items) {
      totalDur += it.audio.durationMs ?? 0;
    }
    return PlaylistEntity(
      id: pl.id,
      userId: pl.userId,
      name: pl.name,
      description: pl.description,
      artworkPath: pl.artworkPath,
      isLiked: pl.isLiked,
      isSmart: pl.isSmart,
      smartCriteria: pl.smartCriteria,
      itemCount: items.length,
      totalDurationMs: totalDur,
      createdAt: pl.createdAt,
      updatedAt: pl.updatedAt,
    );
  }

  @override
  Stream<List<PlaylistItemEntity>> watchPlaylistItems(String playlistId) {
    return _db.watchPlaylistItemsJoined(playlistId).asyncMap((rows) async {
      final list = <PlaylistItemEntity>[];
      for (final row in rows) {
        String? sourcePath;
        if (row.clip != null) {
          final sf = await _db.getFileForItem(row.clip!.sourceAudioItemId);
          sourcePath = sf?.filePath;
        }
        list.add(PlaylistItemEntity(
          id: row.item.id,
          playlistId: row.item.playlistId,
          audioItemId: row.item.audioItemId,
          position: row.item.position,
          addedAt: row.item.addedAt,
          audioItem: _mapJoinedToEntity(row, sourcePath),
        ));
      }
      return list;
    });
  }

  @override
  Future<List<PlaylistItemEntity>> getPlaylistItems(String playlistId) async {
    final rows = await _db.getPlaylistItemsJoined(playlistId);
    final list = <PlaylistItemEntity>[];
    for (final row in rows) {
      String? sourcePath;
      if (row.clip != null) {
        final sf = await _db.getFileForItem(row.clip!.sourceAudioItemId);
        sourcePath = sf?.filePath;
      }
      list.add(PlaylistItemEntity(
        id: row.item.id,
        playlistId: row.item.playlistId,
        audioItemId: row.item.audioItemId,
        position: row.item.position,
        addedAt: row.item.addedAt,
        audioItem: _mapJoinedToEntity(row, sourcePath),
      ));
    }
    return list;
  }

  @override
  Future<String> createPlaylist({
    required String userId,
    required String name,
    String? description,
    String? artworkPath,
    List<String>? initialAudioItemIds,
  }) async {
    final cleanName = name.trim();
    if (cleanName.isEmpty) {
      throw ArgumentError('Playlist name cannot be empty');
    }
    if (cleanName.length > 100) {
      throw ArgumentError('Playlist name must be 100 characters or less');
    }
    final playlistId = const Uuid().v4();
    final now = DateTime.now();

    await _db.insertPlaylist(
      PlaylistsCompanion.insert(
        id: playlistId,
        userId: userId,
        name: cleanName,
        description: Value(description?.trim()),
        artworkPath: Value(artworkPath),
        isLiked: const Value(false),
        isSmart: const Value(false),
        createdAt: Value(now),
        updatedAt: Value(now),
      ),
    );

    if (initialAudioItemIds != null && initialAudioItemIds.isNotEmpty) {
      await addItemsToPlaylist(playlistId, initialAudioItemIds);
    }

    return playlistId;
  }

  @override
  Future<void> updatePlaylistMetadata(
    String playlistId, {
    String? name,
    String? description,
    String? artworkPath,
  }) async {
    final current = await _db.getPlaylistById(playlistId);
    if (current == null) return;

    await _db.updatePlaylist(
      PlaylistsCompanion(
        id: Value(playlistId),
        name: name != null && name.trim().isNotEmpty ? Value(name.trim()) : Value(current.name),
        description: description != null ? Value(description.trim()) : Value(current.description),
        artworkPath: artworkPath != null ? Value(artworkPath) : Value(current.artworkPath),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  @override
  Future<void> toggleLike(String playlistId, bool isLiked) =>
      _db.togglePlaylistLike(playlistId, isLiked);

  @override
  Future<int> addItemsToPlaylist(String playlistId, List<String> audioItemIds) =>
      _db.addItemsToPlaylist(playlistId, audioItemIds);

  @override
  Future<void> removeItemFromPlaylist(String playlistId, String audioItemId) =>
      _db.removeFromPlaylist(playlistId, audioItemId);

  @override
  Future<void> reorderPlaylist(String playlistId, List<String> orderedAudioItemIds) =>
      _db.reorderPlaylist(playlistId, orderedAudioItemIds);

  @override
  Future<String?> duplicatePlaylist(String playlistId, String newName) =>
      _db.duplicatePlaylist(playlistId, newName);

  @override
  Future<void> deletePlaylist(String playlistId) async {
    await _db.deletePlaylist(playlistId);
  }

  @override
  Stream<List<AudioItemEntity>> watchSmartPlaylist(String userId, SmartPlaylistType type) {
    final stream = switch (type) {
      SmartPlaylistType.likedSongs => _db.watchLikedSongs(userId),
      SmartPlaylistType.recentlyPlayed => _db.watchRecentlyPlayed(userId),
      SmartPlaylistType.recentlyAdded => _db.watchRecentlyAdded(userId),
      SmartPlaylistType.mostPlayed => _db.watchMostPlayed(userId),
      SmartPlaylistType.savedClips => _db.watchStarredClips(userId),
      SmartPlaylistType.recordings => _db.watchAllRecordings(userId),
      SmartPlaylistType.longAudio => _db.watchLongAudio(userId),
    };

    return stream.asyncMap((audioList) => _resolveEntities(audioList));
  }

  @override
  Future<List<AudioItemEntity>> getSmartPlaylist(String userId, SmartPlaylistType type) async {
    final list = switch (type) {
      SmartPlaylistType.likedSongs => await _db.getAllSongs(userId).then(
          (all) => all.where((s) => s.isLiked).toList(),
        ),
      SmartPlaylistType.recentlyPlayed => await _db.getRecentlyPlayed(userId),
      SmartPlaylistType.recentlyAdded => await _db.getRecentlyAdded(userId),
      SmartPlaylistType.mostPlayed => await _db.getMostPlayed(userId),
      SmartPlaylistType.savedClips => await _db.getAllClips(userId).then(
          (all) => all.where((c) => c.starNumber != null).toList(),
        ),
      SmartPlaylistType.recordings => await _db.getAllRecordings(userId),
      SmartPlaylistType.longAudio => await _db.getLongAudio(userId),
    };

    return _resolveEntities(list);
  }

  Future<List<AudioItemEntity>> _resolveEntities(List<AudioItem> items) async {
    final resolved = <AudioItemEntity>[];
    for (final it in items) {
      final file = await _db.getFileForItem(it.id);
      final clip = await _db.getClipRecord(it.id);
      String? sourcePath;
      if (clip != null) {
        final sf = await _db.getFileForItem(clip.sourceAudioItemId);
        sourcePath = sf?.filePath;
      }
      resolved.add(AudioItemEntity(
        id: it.id,
        userId: it.userId,
        itemType: AudioItemType.fromString(it.itemType),
        title: it.title,
        artist: it.artist,
        album: it.album,
        albumArtist: it.albumArtist,
        genre: it.genre,
        year: it.year,
        trackNumber: it.trackNumber,
        composer: it.composer,
        durationMs: it.durationMs,
        artworkPath: it.artworkPath,
        isLiked: it.isLiked,
        starNumber: it.starNumber,
        playCount: it.playCount,
        lastPlayedAt: it.lastPlayedAt,
        resumePositionMs: it.resumePositionMs,
        isAvailable: it.isAvailable && ((file?.isAvailable ?? true) || sourcePath != null),
        createdAt: it.createdAt,
        updatedAt: it.updatedAt,
        filePath: file?.filePath ?? sourcePath,
        fileHash: file?.fileHash,
        fileSizeBytes: file?.fileSizeBytes,
        mimeType: file?.mimeType,
        clipStartMs: clip?.startMs,
        clipEndMs: clip?.endMs,
        sourceAudioItemId: clip?.sourceAudioItemId,
        parentClipId: clip?.parentClipId,
        isPhysicalClip: clip?.isPhysical ?? false,
      ));
    }
    return resolved;
  }

  AudioItemEntity _mapJoinedToEntity(PlaylistItemJoinedData row, String? sourcePath) {
    return AudioItemEntity(
      id: row.audio.id,
      userId: row.audio.userId,
      itemType: AudioItemType.fromString(row.audio.itemType),
      title: row.audio.title,
      artist: row.audio.artist,
      album: row.audio.album,
      albumArtist: row.audio.albumArtist,
      genre: row.audio.genre,
      year: row.audio.year,
      trackNumber: row.audio.trackNumber,
      composer: row.audio.composer,
      durationMs: row.audio.durationMs,
      artworkPath: row.audio.artworkPath,
      isLiked: row.audio.isLiked,
      starNumber: row.audio.starNumber,
      playCount: row.audio.playCount,
      lastPlayedAt: row.audio.lastPlayedAt,
      resumePositionMs: row.audio.resumePositionMs,
      isAvailable: row.audio.isAvailable && ((row.file?.isAvailable ?? true) || sourcePath != null),
      createdAt: row.audio.createdAt,
      updatedAt: row.audio.updatedAt,
      filePath: row.file?.filePath ?? sourcePath,
      fileHash: row.file?.fileHash,
      fileSizeBytes: row.file?.fileSizeBytes,
      mimeType: row.file?.mimeType,
      clipStartMs: row.clip?.startMs,
      clipEndMs: row.clip?.endMs,
      sourceAudioItemId: row.clip?.sourceAudioItemId,
      parentClipId: row.clip?.parentClipId,
      isPhysicalClip: row.clip?.isPhysical ?? false,
    );
  }
}
