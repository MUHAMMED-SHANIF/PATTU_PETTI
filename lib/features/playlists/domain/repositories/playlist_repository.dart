import '../../../../domain/entities/audio_item_entity.dart';
import '../entities/playlist_entity.dart';

/// Repository interface for playlist persistence and querying.
abstract class PlaylistRepository {
  /// Watches all custom playlists for a user with live counts and durations.
  Stream<List<PlaylistEntity>> watchPlaylists(String userId);

  /// Watches liked playlists for a user.
  Stream<List<PlaylistEntity>> watchLikedPlaylists(String userId);

  /// Retrieves a specific playlist by ID.
  Future<PlaylistEntity?> getPlaylist(String playlistId);

  /// Watches items inside a playlist in custom ordered position.
  Stream<List<PlaylistItemEntity>> watchPlaylistItems(String playlistId);

  /// Gets items inside a playlist in custom ordered position.
  Future<List<PlaylistItemEntity>> getPlaylistItems(String playlistId);

  /// Creates a new playlist and returns the created playlist ID.
  Future<String> createPlaylist({
    required String userId,
    required String name,
    String? description,
    String? artworkPath,
    List<String>? initialAudioItemIds,
  });

  /// Updates playlist name, description, or artwork.
  Future<void> updatePlaylistMetadata(
    String playlistId, {
    String? name,
    String? description,
    String? artworkPath,
  });

  /// Toggles playlist like state independently from song likes.
  Future<void> toggleLike(String playlistId, bool isLiked);

  /// Adds audio items to a playlist, preventing duplicates.
  Future<int> addItemsToPlaylist(String playlistId, List<String> audioItemIds);

  /// Removes an audio item reference from a playlist without deleting audio.
  Future<void> removeItemFromPlaylist(String playlistId, String audioItemId);

  /// Reorders items in a playlist and persists the sequential positions.
  Future<void> reorderPlaylist(String playlistId, List<String> orderedAudioItemIds);

  /// Duplicates a playlist and its references with a new ID.
  Future<String?> duplicatePlaylist(String playlistId, String newName);

  /// Deletes a playlist and its item references (original audio files untouched).
  Future<void> deletePlaylist(String playlistId);

  /// Watches dynamic smart playlist audio items.
  Stream<List<AudioItemEntity>> watchSmartPlaylist(String userId, SmartPlaylistType type);

  /// Gets dynamic smart playlist audio items.
  Future<List<AudioItemEntity>> getSmartPlaylist(String userId, SmartPlaylistType type);
}
