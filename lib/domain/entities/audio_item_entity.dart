import 'package:equatable/equatable.dart';

/// Core audio item entity used throughout the app.
/// Represents a song, clip, merged track, or recording.
/// itemType determines the actual behavior.
class AudioItemEntity extends Equatable {
  const AudioItemEntity({
    required this.id,
    required this.userId,
    required this.itemType,
    required this.title,
    this.artist,
    this.album,
    this.albumArtist,
    this.genre,
    this.year,
    this.trackNumber,
    this.composer,
    this.durationMs,
    this.artworkPath,
    this.isLiked = false,
    this.starNumber,
    this.playCount = 0,
    this.lastPlayedAt,
    this.resumePositionMs = 0,
    this.isAvailable = true,
    required this.createdAt,
    required this.updatedAt,
    // File info (for songs and physical clips)
    this.filePath,
    this.fileHash,
    this.fileSizeBytes,
    this.mimeType,
    // Clip info (for virtual clips)
    this.clipStartMs,
    this.clipEndMs,
    this.sourceAudioItemId,
    this.parentClipId,
    this.isPhysicalClip = false,
    // Merge info
    this.mergeItems,
  });

  final String id;
  final String userId;
  final AudioItemType itemType;
  final String title;
  final String? artist;
  final String? album;
  final String? albumArtist;
  final String? genre;
  final int? year;
  final int? trackNumber;
  final String? composer;
  final int? durationMs;
  final String? artworkPath;
  final bool isLiked;
  final int? starNumber; // null = not starred, 1..N = starred
  final int playCount;
  final DateTime? lastPlayedAt;
  final int resumePositionMs;
  final bool isAvailable;
  final DateTime createdAt;
  final DateTime updatedAt;

  // Song/physical file fields
  final String? filePath;
  final String? fileHash;
  final int? fileSizeBytes;
  final String? mimeType;

  // Virtual clip fields
  final int? clipStartMs;
  final int? clipEndMs;
  final String? sourceAudioItemId;
  final String? parentClipId;
  final bool isPhysicalClip;

  // Merged track fields
  final List<MergeItemEntity>? mergeItems;

  bool get isStarred => starNumber != null;
  bool get isClip => itemType == AudioItemType.clip;
  bool get isSong => itemType == AudioItemType.song;
  bool get isMerged => itemType == AudioItemType.merged;
  bool get isRecording => itemType == AudioItemType.recording;
  bool get isVirtualClip => isClip && !isPhysicalClip;

  Duration? get duration =>
      durationMs != null ? Duration(milliseconds: durationMs!) : null;

  Duration? get clipStart =>
      clipStartMs != null ? Duration(milliseconds: clipStartMs!) : null;

  Duration? get clipEnd =>
      clipEndMs != null ? Duration(milliseconds: clipEndMs!) : null;

  String get displayArtist => artist ?? 'Unknown Artist';
  String get displayAlbum => album ?? 'Unknown Album';

  AudioItemEntity copyWith({
    String? id,
    String? userId,
    AudioItemType? itemType,
    String? title,
    String? artist,
    String? album,
    String? albumArtist,
    String? genre,
    int? year,
    int? trackNumber,
    String? composer,
    int? durationMs,
    String? artworkPath,
    bool? isLiked,
    int? starNumber,
    int? playCount,
    DateTime? lastPlayedAt,
    int? resumePositionMs,
    bool? isAvailable,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? filePath,
    String? fileHash,
    int? fileSizeBytes,
    String? mimeType,
    int? clipStartMs,
    int? clipEndMs,
    String? sourceAudioItemId,
    String? parentClipId,
    bool? isPhysicalClip,
    List<MergeItemEntity>? mergeItems,
  }) {
    return AudioItemEntity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      itemType: itemType ?? this.itemType,
      title: title ?? this.title,
      artist: artist ?? this.artist,
      album: album ?? this.album,
      albumArtist: albumArtist ?? this.albumArtist,
      genre: genre ?? this.genre,
      year: year ?? this.year,
      trackNumber: trackNumber ?? this.trackNumber,
      composer: composer ?? this.composer,
      durationMs: durationMs ?? this.durationMs,
      artworkPath: artworkPath ?? this.artworkPath,
      isLiked: isLiked ?? this.isLiked,
      starNumber: starNumber ?? this.starNumber,
      playCount: playCount ?? this.playCount,
      lastPlayedAt: lastPlayedAt ?? this.lastPlayedAt,
      resumePositionMs: resumePositionMs ?? this.resumePositionMs,
      isAvailable: isAvailable ?? this.isAvailable,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      filePath: filePath ?? this.filePath,
      fileHash: fileHash ?? this.fileHash,
      fileSizeBytes: fileSizeBytes ?? this.fileSizeBytes,
      mimeType: mimeType ?? this.mimeType,
      clipStartMs: clipStartMs ?? this.clipStartMs,
      clipEndMs: clipEndMs ?? this.clipEndMs,
      sourceAudioItemId: sourceAudioItemId ?? this.sourceAudioItemId,
      parentClipId: parentClipId ?? this.parentClipId,
      isPhysicalClip: isPhysicalClip ?? this.isPhysicalClip,
      mergeItems: mergeItems ?? this.mergeItems,
    );
  }

  @override
  List<Object?> get props => [id, userId, itemType, title, isLiked, starNumber, playCount];
}

/// Type of audio item.
enum AudioItemType {
  song,
  clip,
  merged,
  recording;

  static AudioItemType fromString(String value) {
    return switch (value) {
      'song' => AudioItemType.song,
      'clip' => AudioItemType.clip,
      'merged' => AudioItemType.merged,
      'recording' => AudioItemType.recording,
      _ => throw ArgumentError('Unknown audio item type: $value'),
    };
  }

  String get value => name;
}

/// Represents one item in a merged track.
class MergeItemEntity extends Equatable {
  const MergeItemEntity({
    required this.id,
    required this.mergedTrackId,
    required this.audioItemId,
    required this.position,
    this.fadeInMs = 500,
    this.fadeOutMs = 500,
    this.audioItem,
  });

  final String id;
  final String mergedTrackId;
  final String audioItemId;
  final int position;
  final int fadeInMs;
  final int fadeOutMs;
  final AudioItemEntity? audioItem; // populated when fetched with join

  @override
  List<Object?> get props => [id, mergedTrackId, audioItemId, position];
}

/// Represents a clip with its fully resolved source (for playback).
class ResolvedClipEntity {
  const ResolvedClipEntity({
    required this.clip,
    required this.source,
  });

  final AudioItemEntity clip;
  final AudioItemEntity source; // fully resolved source song/file

  /// Normalized start time in ms (accounting for nested clips)
  int get absoluteStartMs {
    if (clip.parentClipId == null) {
      return clip.clipStartMs ?? 0;
    }
    // Nested: offset relative to parent
    return (source.clipStartMs ?? 0) + (clip.clipStartMs ?? 0);
  }

  /// Normalized end time in ms
  int get absoluteEndMs {
    if (clip.parentClipId == null) {
      return clip.clipEndMs ?? (source.durationMs ?? 0);
    }
    return (source.clipStartMs ?? 0) + (clip.clipEndMs ?? (source.durationMs ?? 0));
  }

  /// The actual file to play from
  String? get sourceFilePath => source.filePath;
}
