// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint

// ─── Drift Database Schema for Pattu Petti ──────────────────────────────────
// This is the LOCAL offline-first SQLite database.
// Supabase is used for auth, sync, and admin features.
// All local music data lives here first.

import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'app_database.g.dart';

// ─── Tables ──────────────────────────────────────────────────────────────────

/// Represents a locally known user profile (cached from Supabase).
class LocalProfiles extends Table {
  TextColumn get id => text()(); // Supabase user UUID
  TextColumn get username => text()();
  TextColumn get displayName => text().nullable()();
  TextColumn get email => text().nullable()();
  TextColumn get avatarPath => text().nullable()();
  TextColumn get role => text().withDefault(const Constant('normal'))();
  BoolColumn get isLoggedIn => boolean().withDefault(const Constant(false))();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

/// Folder paths registered by the user for scanning.
class FolderSources extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get userId => text()();
  TextColumn get folderPath => text()();
  TextColumn get displayName => text().nullable()();
  DateTimeColumn get lastScannedAt => dateTime().nullable()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  List<Set<Column>> get uniqueKeys => [
    {userId, folderPath},
  ];
}

/// Core audio items: songs, clips, merged tracks, recordings.
class AudioItems extends Table {
  TextColumn get id => text()(); // UUID
  TextColumn get userId => text()();
  TextColumn get itemType => text()(); // 'song' | 'clip' | 'merged' | 'recording'
  TextColumn get title => text()();
  TextColumn get artist => text().nullable()();
  TextColumn get album => text().nullable()();
  TextColumn get albumArtist => text().nullable()();
  TextColumn get genre => text().nullable()();
  IntColumn get year => integer().nullable()();
  IntColumn get trackNumber => integer().nullable()();
  TextColumn get composer => text().nullable()();
  IntColumn get durationMs => integer().nullable()();
  TextColumn get artworkPath => text().nullable()(); // local cached artwork
  BoolColumn get isLiked => boolean().withDefault(const Constant(false))();
  IntColumn get starNumber => integer().nullable()(); // NULL=not starred, 1..N
  IntColumn get playCount => integer().withDefault(const Constant(0))();
  DateTimeColumn get lastPlayedAt => dateTime().nullable()();
  IntColumn get resumePositionMs => integer().withDefault(const Constant(0))();
  BoolColumn get isAvailable => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

/// Physical file references for songs and rendered clips.
class AudioFiles extends Table {
  TextColumn get id => text()(); // UUID
  TextColumn get audioItemId => text().references(AudioItems, #id, onDelete: KeyAction.cascade)();
  TextColumn get filePath => text()();
  TextColumn get fileHash => text().nullable()(); // SHA-256 for duplicate detection
  IntColumn get fileSizeBytes => integer().nullable()();
  TextColumn get mimeType => text().nullable()();
  IntColumn get bitRate => integer().nullable()();
  IntColumn get sampleRate => integer().nullable()();
  IntColumn get channels => integer().nullable()();
  BoolColumn get isAvailable => boolean().withDefault(const Constant(true))();
  DateTimeColumn get lastVerifiedAt => dateTime().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

/// Virtual clip records: timestamp-based references to source audio.
/// NO physical file is created by default.
class ClipRecords extends Table {
  TextColumn get id => text()(); // UUID
  TextColumn get audioItemId => text().references(AudioItems, #id, onDelete: KeyAction.cascade)();
  TextColumn get sourceAudioItemId => text().references(AudioItems, #id, onDelete: KeyAction.restrict)();
  TextColumn get parentClipId => text().nullable()(); // for nested clips
  IntColumn get startMs => integer()(); // 0.1s precision
  IntColumn get endMs => integer()();
  BoolColumn get isPhysical => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

/// Merged track records (virtual composition, no physical file by default).
class MergedTracks extends Table {
  TextColumn get id => text()(); // UUID — same as AudioItems.id
  BoolColumn get isPhysical => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

/// Ordered items within a merged track.
class MergeItems extends Table {
  TextColumn get id => text()();
  TextColumn get mergedTrackId => text().references(MergedTracks, #id, onDelete: KeyAction.cascade)();
  TextColumn get audioItemId => text().references(AudioItems, #id, onDelete: KeyAction.restrict)();
  IntColumn get position => integer()();
  IntColumn get fadeInMs => integer().withDefault(const Constant(500))();
  IntColumn get fadeOutMs => integer().withDefault(const Constant(500))();

  @override
  Set<Column> get primaryKey => {id};
}

/// Playlists (manual and smart).
class Playlists extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text()();
  TextColumn get name => text()();
  TextColumn get description => text().nullable()();
  TextColumn get artworkPath => text().nullable()();
  BoolColumn get isSmart => boolean().withDefault(const Constant(false))();
  TextColumn get smartCriteria => text().nullable()(); // JSON string
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

/// Items within a playlist.
class PlaylistItems extends Table {
  TextColumn get id => text()();
  TextColumn get playlistId => text().references(Playlists, #id, onDelete: KeyAction.cascade)();
  TextColumn get audioItemId => text().references(AudioItems, #id, onDelete: KeyAction.cascade)();
  IntColumn get position => integer()();
  DateTimeColumn get addedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

/// Play history entries.
class PlayHistory extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text()();
  TextColumn get audioItemId => text().references(AudioItems, #id, onDelete: KeyAction.cascade)();
  DateTimeColumn get playedAt => dateTime().withDefault(currentDateAndTime)();
  IntColumn get durationPlayedMs => integer().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Persisted queue state.
class QueueSnapshot extends Table {
  TextColumn get userId => text()();
  TextColumn get itemIds => text()(); // JSON array of audio item UUIDs
  IntColumn get currentIndex => integer().withDefault(const Constant(0))();
  IntColumn get currentPositionMs => integer().withDefault(const Constant(0))();
  BoolColumn get shuffleEnabled => boolean().withDefault(const Constant(false))();
  TextColumn get repeatMode => text().withDefault(const Constant('off'))();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {userId};
}

/// Locally cached notifications from Supabase.
class LocalNotifications extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text()();
  TextColumn get title => text()();
  TextColumn get body => text()();
  TextColumn get type => text()();
  BoolColumn get isRead => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

/// Locally cached feature flags from Supabase.
class LocalFeatureFlags extends Table {
  TextColumn get featureKey => text()();
  BoolColumn get enabled => boolean().withDefault(const Constant(true))();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {featureKey};
}

/// Per-user feature overrides cached locally.
class LocalFeatureOverrides extends Table {
  TextColumn get userId => text()();
  TextColumn get featureKey => text()();
  BoolColumn get enabled => boolean()();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {userId, featureKey};
}

// ─── Database ─────────────────────────────────────────────────────────────────

@DriftDatabase(tables: [
  LocalProfiles,
  FolderSources,
  AudioItems,
  AudioFiles,
  ClipRecords,
  MergedTracks,
  MergeItems,
  Playlists,
  PlaylistItems,
  PlayHistory,
  QueueSnapshot,
  LocalNotifications,
  LocalFeatureFlags,
  LocalFeatureOverrides,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());
  AppDatabase.forTesting(super.e);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) => m.createAll(),
    onUpgrade: (m, from, to) async {
      // Future migrations go here
    },
  );

  static QueryExecutor _openConnection() {
    return driftDatabase(name: 'patt_petti_local');
  }
}
