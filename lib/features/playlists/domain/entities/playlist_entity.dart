import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import '../../../../domain/entities/audio_item_entity.dart';

/// Represents a playlist in Pattu Petti.
/// Playlists store references to audio items without duplicating physical audio files.
class PlaylistEntity extends Equatable {
  const PlaylistEntity({
    required this.id,
    required this.userId,
    required this.name,
    this.description,
    this.artworkPath,
    this.isLiked = false,
    this.isSmart = false,
    this.smartCriteria,
    this.itemCount = 0,
    this.totalDurationMs = 0,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String userId;
  final String name;
  final String? description;
  final String? artworkPath;
  final bool isLiked;
  final bool isSmart;
  final String? smartCriteria;
  final int itemCount;
  final int totalDurationMs;
  final DateTime createdAt;
  final DateTime updatedAt;

  Duration get totalDuration => Duration(milliseconds: totalDurationMs);

  String get formattedDuration {
    if (totalDurationMs <= 0) return '0 min';
    final dur = Duration(milliseconds: totalDurationMs);
    final hours = dur.inHours;
    final minutes = dur.inMinutes.remainder(60);
    if (hours > 0) {
      return '$hours hr ${minutes > 0 ? '$minutes min' : ''}'.trim();
    }
    return '$minutes min';
  }

  String get formattedItemCount {
    if (itemCount == 1) return '1 item';
    return '$itemCount items';
  }

  PlaylistEntity copyWith({
    String? id,
    String? userId,
    String? name,
    String? description,
    String? artworkPath,
    bool? isLiked,
    bool? isSmart,
    String? smartCriteria,
    int? itemCount,
    int? totalDurationMs,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return PlaylistEntity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      description: description ?? this.description,
      artworkPath: artworkPath ?? this.artworkPath,
      isLiked: isLiked ?? this.isLiked,
      isSmart: isSmart ?? this.isSmart,
      smartCriteria: smartCriteria ?? this.smartCriteria,
      itemCount: itemCount ?? this.itemCount,
      totalDurationMs: totalDurationMs ?? this.totalDurationMs,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        userId,
        name,
        description,
        artworkPath,
        isLiked,
        isSmart,
        itemCount,
        totalDurationMs,
        updatedAt,
      ];
}

/// Represents an item reference inside a playlist.
class PlaylistItemEntity extends Equatable {
  const PlaylistItemEntity({
    required this.id,
    required this.playlistId,
    required this.audioItemId,
    required this.position,
    required this.addedAt,
    required this.audioItem,
  });

  final String id;
  final String playlistId;
  final String audioItemId;
  final int position;
  final DateTime addedAt;
  final AudioItemEntity audioItem;

  PlaylistItemEntity copyWith({
    String? id,
    String? playlistId,
    String? audioItemId,
    int? position,
    DateTime? addedAt,
    AudioItemEntity? audioItem,
  }) {
    return PlaylistItemEntity(
      id: id ?? this.id,
      playlistId: playlistId ?? this.playlistId,
      audioItemId: audioItemId ?? this.audioItemId,
      position: position ?? this.position,
      addedAt: addedAt ?? this.addedAt,
      audioItem: audioItem ?? this.audioItem,
    );
  }

  @override
  List<Object?> get props => [id, playlistId, audioItemId, position, audioItem];
}

/// Dynamic smart playlist types evaluated on-demand from audio metadata.
enum SmartPlaylistType {
  likedSongs,
  recentlyPlayed,
  recentlyAdded,
  mostPlayed,
  savedClips,
  recordings,
  longAudio;

  String get displayName => switch (this) {
        SmartPlaylistType.likedSongs => 'Liked Songs',
        SmartPlaylistType.recentlyPlayed => 'Recently Played',
        SmartPlaylistType.recentlyAdded => 'Recently Added',
        SmartPlaylistType.mostPlayed => 'Most Played',
        SmartPlaylistType.savedClips => 'Saved Clips',
        SmartPlaylistType.recordings => 'Recordings',
        SmartPlaylistType.longAudio => 'Long Audio',
      };

  String get description => switch (this) {
        SmartPlaylistType.likedSongs => 'All your favorite liked tracks',
        SmartPlaylistType.recentlyPlayed => 'Tracks you listened to recently',
        SmartPlaylistType.recentlyAdded => 'Latest audio additions to your library',
        SmartPlaylistType.mostPlayed => 'Your top tracks sorted by play count',
        SmartPlaylistType.savedClips => 'Clips you have starred and bookmarked',
        SmartPlaylistType.recordings => 'Voice and studio microphone recordings',
        SmartPlaylistType.longAudio => 'Tracks and recordings longer than 10 minutes',
      };

  IconData get icon => switch (this) {
        SmartPlaylistType.likedSongs => Icons.favorite_rounded,
        SmartPlaylistType.recentlyPlayed => Icons.history_rounded,
        SmartPlaylistType.recentlyAdded => Icons.fiber_new_rounded,
        SmartPlaylistType.mostPlayed => Icons.local_fire_department_rounded,
        SmartPlaylistType.savedClips => Icons.content_cut_rounded,
        SmartPlaylistType.recordings => Icons.mic_rounded,
        SmartPlaylistType.longAudio => Icons.timer_rounded,
      };

  List<Color> get gradientColors => switch (this) {
        SmartPlaylistType.likedSongs => const [Color(0xFFE91E63), Color(0xFF9C27B0)],
        SmartPlaylistType.recentlyPlayed => const [Color(0xFF2196F3), Color(0xFF3F51B5)],
        SmartPlaylistType.recentlyAdded => const [Color(0xFF4CAF50), Color(0xFF009688)],
        SmartPlaylistType.mostPlayed => const [Color(0xFFFF9800), Color(0xFFF44336)],
        SmartPlaylistType.savedClips => const [Color(0xFFFFB300), Color(0xFFFF6F00)],
        SmartPlaylistType.recordings => const [Color(0xFF00BCD4), Color(0xFF009688)],
        SmartPlaylistType.longAudio => const [Color(0xFF673AB7), Color(0xFF3F51B5)],
      };
}
