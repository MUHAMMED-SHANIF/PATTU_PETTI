import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/providers/global_providers.dart';
import '../../../../domain/entities/audio_item_entity.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../player/presentation/providers/player_provider.dart';
import '../../data/repositories/playlist_repository_impl.dart';
import '../../domain/entities/playlist_entity.dart';
import '../../domain/repositories/playlist_repository.dart';

/// Provides the active PlaylistRepository instance.
final playlistRepositoryProvider = Provider<PlaylistRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return PlaylistRepositoryImpl(db);
});

/// Current user ID for playlist scoping (offline guest fallback).
final playlistUserIdProvider = Provider<String>((ref) {
  final user = ref.watch(authStateProvider).valueOrNull?.user;
  return user?.id ?? 'local-offline-user';
});

/// Watches all user playlists with item count and total duration stats.
final playlistsStreamProvider = StreamProvider<List<PlaylistEntity>>((ref) {
  final repo = ref.watch(playlistRepositoryProvider);
  final userId = ref.watch(playlistUserIdProvider);
  return repo.watchPlaylists(userId);
});

/// Watches liked user playlists.
final likedPlaylistsProvider = StreamProvider<List<PlaylistEntity>>((ref) {
  final repo = ref.watch(playlistRepositoryProvider);
  final userId = ref.watch(playlistUserIdProvider);
  return repo.watchLikedPlaylists(userId);
});

/// Single playlist metadata provider by ID.
final singlePlaylistProvider = FutureProvider.family<PlaylistEntity?, String>((ref, playlistId) {
  final repo = ref.watch(playlistRepositoryProvider);
  return repo.getPlaylist(playlistId);
});

/// Watches ordered items inside a custom playlist.
final playlistItemsStreamProvider =
    StreamProvider.family<List<PlaylistItemEntity>, String>((ref, playlistId) {
  final repo = ref.watch(playlistRepositoryProvider);
  return repo.watchPlaylistItems(playlistId);
});

/// Watches dynamic audio items inside a smart playlist.
final smartPlaylistItemsStreamProvider =
    StreamProvider.family<List<AudioItemEntity>, SmartPlaylistType>((ref, type) {
  final repo = ref.watch(playlistRepositoryProvider);
  final userId = ref.watch(playlistUserIdProvider);
  return repo.watchSmartPlaylist(userId, type);
});

/// Watches the dynamic item count for a specific smart playlist type.
final smartPlaylistCountProvider =
    StreamProvider.family<int, SmartPlaylistType>((ref, type) {
  final repo = ref.watch(playlistRepositoryProvider);
  final userId = ref.watch(playlistUserIdProvider);
  return repo.watchSmartPlaylist(userId, type).map((items) => items.length);
});

/// Controller for performing playlist actions.
final playlistControllerProvider = Provider<PlaylistController>((ref) {
  return PlaylistController(ref);
});

class PlaylistController {
  const PlaylistController(this._ref);

  final Ref _ref;

  PlaylistRepository get _repo => _ref.read(playlistRepositoryProvider);
  String get _userId => _ref.read(playlistUserIdProvider);

  /// Creates a new playlist with validation and optional initial audio item references.
  Future<String> createPlaylist({
    required String name,
    String? description,
    String? artworkPath,
    List<String>? initialItemIds,
  }) async {
    final trimmedName = name.trim();
    if (trimmedName.isEmpty) {
      throw ArgumentError('Playlist name cannot be empty');
    }
    if (trimmedName.length > 100) {
      throw ArgumentError('Playlist name must be 100 characters or less');
    }

    final id = await _repo.createPlaylist(
      userId: _userId,
      name: trimmedName,
      description: description,
      artworkPath: artworkPath,
      initialAudioItemIds: initialItemIds,
    );

    _ref.invalidate(playlistsStreamProvider);
    return id;
  }

  /// Renames a playlist.
  Future<void> renamePlaylist(String playlistId, String newName) async {
    final trimmed = newName.trim();
    if (trimmed.isEmpty) return;
    await _repo.updatePlaylistMetadata(playlistId, name: trimmed);
    _ref.invalidate(singlePlaylistProvider(playlistId));
    _ref.invalidate(playlistsStreamProvider);
  }

  /// Edits playlist description.
  Future<void> editDescription(String playlistId, String description) async {
    await _repo.updatePlaylistMetadata(playlistId, description: description);
    _ref.invalidate(singlePlaylistProvider(playlistId));
    _ref.invalidate(playlistsStreamProvider);
  }

  /// Changes playlist artwork path.
  Future<void> changeArtwork(String playlistId, String? artworkPath) async {
    await _repo.updatePlaylistMetadata(playlistId, artworkPath: artworkPath);
    _ref.invalidate(singlePlaylistProvider(playlistId));
    _ref.invalidate(playlistsStreamProvider);
  }

  /// Toggles playlist like state (independent from song likes).
  Future<void> toggleLike(String playlistId, bool isLiked) async {
    await _repo.toggleLike(playlistId, isLiked);
    _ref.invalidate(singlePlaylistProvider(playlistId));
    _ref.invalidate(playlistsStreamProvider);
    _ref.invalidate(likedPlaylistsProvider);
  }

  /// Adds items to playlist, ensuring zero duplicate references.
  Future<int> addItems(String playlistId, List<String> audioItemIds) async {
    final count = await _repo.addItemsToPlaylist(playlistId, audioItemIds);
    _ref.invalidate(playlistItemsStreamProvider(playlistId));
    _ref.invalidate(singlePlaylistProvider(playlistId));
    _ref.invalidate(playlistsStreamProvider);
    return count;
  }

  /// Removes an audio item reference from a playlist.
  Future<void> removeItem(String playlistId, String audioItemId) async {
    await _repo.removeItemFromPlaylist(playlistId, audioItemId);
    _ref.invalidate(playlistItemsStreamProvider(playlistId));
    _ref.invalidate(singlePlaylistProvider(playlistId));
    _ref.invalidate(playlistsStreamProvider);
  }

  /// Persists reordered item positions immediately.
  Future<void> reorder(String playlistId, List<String> orderedAudioItemIds) async {
    await _repo.reorderPlaylist(playlistId, orderedAudioItemIds);
    _ref.invalidate(playlistItemsStreamProvider(playlistId));
  }

  /// Duplicates a playlist and its references with a new name.
  Future<String?> duplicate(String playlistId, [String? customName]) async {
    final pl = await _repo.getPlaylist(playlistId);
    if (pl == null) return null;
    final targetName = customName ?? 'Copy of ${pl.name}';
    final newId = await _repo.duplicatePlaylist(playlistId, targetName);
    _ref.invalidate(playlistsStreamProvider);
    return newId;
  }

  /// Deletes a playlist and its references without deleting underlying audio.
  Future<void> delete(String playlistId) async {
    await _repo.deletePlaylist(playlistId);
    _ref.invalidate(playlistsStreamProvider);
    _ref.invalidate(likedPlaylistsProvider);
  }

  /// Saves the current global playback queue as a new playlist.
  Future<String?> saveQueueAsPlaylist(String name, {String? description}) async {
    final queue = _ref.read(playerProvider).queue;
    if (queue.isEmpty) return null;
    final itemIds = queue.map((e) => e.id).toList();
    return createPlaylist(
      name: name,
      description: description,
      initialItemIds: itemIds,
    );
  }
}
