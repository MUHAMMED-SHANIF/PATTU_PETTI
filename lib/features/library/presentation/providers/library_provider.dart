import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/providers/global_providers.dart';
import '../../../../data/local/database/app_database.dart';
import '../../../../data/local/database/app_database_dao.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

/// Provider for recently played items.
final recentlyPlayedProvider = FutureProvider<List<AudioItem>>((ref) async {
  final db = ref.watch(appDatabaseProvider);
  final authState = ref.watch(authStateProvider);
  final userId = authState.valueOrNull?.user?.id;
  if (userId == null) return [];
  return db.getRecentlyPlayed(userId, limit: 20);
});

/// Provider for recently added items.
final recentlyAddedProvider = FutureProvider<List<AudioItem>>((ref) async {
  final db = ref.watch(appDatabaseProvider);
  final authState = ref.watch(authStateProvider);
  final userId = authState.valueOrNull?.user?.id;
  if (userId == null) return [];
  return db.getRecentlyAdded(userId, limit: 20);
});

/// Provider for all songs (streamed).
final allSongsProvider = StreamProvider<List<AudioItem>>((ref) {
  final db = ref.watch(appDatabaseProvider);
  final authState = ref.watch(authStateProvider);
  final userId = authState.valueOrNull?.user?.id;
  if (userId == null) return const Stream.empty();
  return db.watchAllSongs(userId);
});

/// Provider for liked songs (streamed).
final likedSongsProvider = StreamProvider<List<AudioItem>>((ref) {
  final db = ref.watch(appDatabaseProvider);
  final authState = ref.watch(authStateProvider);
  final userId = authState.valueOrNull?.user?.id;
  if (userId == null) return const Stream.empty();
  return db.watchLikedSongs(userId);
});

/// Provider for starred clips (streamed).
final starredClipsProvider = StreamProvider<List<AudioItem>>((ref) {
  final db = ref.watch(appDatabaseProvider);
  final authState = ref.watch(authStateProvider);
  final userId = authState.valueOrNull?.user?.id;
  if (userId == null) return const Stream.empty();
  return db.watchStarredClips(userId);
});

/// Provider for all clips.
final allClipsProvider = FutureProvider<List<AudioItem>>((ref) async {
  final db = ref.watch(appDatabaseProvider);
  final authState = ref.watch(authStateProvider);
  final userId = authState.valueOrNull?.user?.id;
  if (userId == null) return [];
  return db.getAllClips(userId);
});

/// Provider for all recordings.
final allRecordingsProvider = FutureProvider<List<AudioItem>>((ref) async {
  final db = ref.watch(appDatabaseProvider);
  final authState = ref.watch(authStateProvider);
  final userId = authState.valueOrNull?.user?.id;
  if (userId == null) return [];
  return db.getAllRecordings(userId);
});

/// Provider for most played items.
final mostPlayedProvider = FutureProvider<List<AudioItem>>((ref) async {
  final db = ref.watch(appDatabaseProvider);
  final authState = ref.watch(authStateProvider);
  final userId = authState.valueOrNull?.user?.id;
  if (userId == null) return [];
  return db.getMostPlayed(userId, limit: 20);
});

/// Provider for folder sources (streamed).
final folderSourcesProvider = StreamProvider<List<FolderSource>>((ref) {
  final db = ref.watch(appDatabaseProvider);
  final authState = ref.watch(authStateProvider);
  final userId = authState.valueOrNull?.user?.id;
  if (userId == null) return const Stream.empty();
  return db.watchFolderSources(userId);
});

