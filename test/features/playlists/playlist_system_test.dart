import 'dart:convert';
import 'package:drift/drift.dart' as drift;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:patt_petti/data/local/database/app_database.dart';
import 'package:patt_petti/data/local/database/app_database_dao.dart';
import 'package:patt_petti/domain/entities/audio_item_entity.dart';
import 'package:patt_petti/features/playlists/data/repositories/playlist_repository_impl.dart';
import 'package:patt_petti/features/playlists/data/services/playlist_export_service.dart';
import 'package:patt_petti/features/playlists/domain/entities/playlist_entity.dart';

void main() {
  group('PlaylistEntity Domain Model', () {
    test('calculates and formats total duration correctly', () {
      final now = DateTime(2025, 1, 1);
      final pl1 = PlaylistEntity(
        id: 'pl-1',
        userId: 'user-1',
        name: 'Chill Vibes',
        itemCount: 5,
        totalDurationMs: 3660000, // 1 hr 1 min
        createdAt: now,
        updatedAt: now,
      );

      expect(pl1.formattedDuration, '1 hr 1 min');
      expect(pl1.formattedItemCount, '5 items');

      final pl2 = PlaylistEntity(
        id: 'pl-2',
        userId: 'user-1',
        name: 'Quick Jams',
        itemCount: 1,
        totalDurationMs: 180000, // 3 min
        createdAt: now,
        updatedAt: now,
      );

      expect(pl2.formattedDuration, '3 min');
      expect(pl2.formattedItemCount, '1 item');
    });

    test('supports independent playlist like state', () {
      final now = DateTime.now();
      final pl = PlaylistEntity(
        id: 'pl-1',
        userId: 'user-1',
        name: 'Favorites',
        isLiked: false,
        createdAt: now,
        updatedAt: now,
      );

      final liked = pl.copyWith(isLiked: true);
      expect(pl.isLiked, isFalse);
      expect(liked.isLiked, isTrue);
      expect(liked.name, 'Favorites');
    });
  });

  group('PlaylistExportService', () {
    final now = DateTime.now();
    final samplePlaylist = PlaylistEntity(
      id: 'pl-export-1',
      userId: 'user-1',
      name: 'Retro Hits',
      description: 'Golden classics of the 80s and 90s',
      itemCount: 2,
      totalDurationMs: 420000,
      createdAt: now,
      updatedAt: now,
    );

    final sampleItems = [
      AudioItemEntity(
        id: 'item-1',
        userId: 'user-1',
        itemType: AudioItemType.song,
        title: 'Billie Jean',
        artist: 'Michael Jackson',
        album: 'Thriller',
        durationMs: 294000,
        createdAt: now,
        updatedAt: now,
      ),
      AudioItemEntity(
        id: 'item-2',
        userId: 'user-1',
        itemType: AudioItemType.clip,
        title: 'Guitar Solo Clip',
        artist: 'Eddie Van Halen',
        album: '1984',
        durationMs: 126000,
        clipStartMs: 30000,
        clipEndMs: 156000,
        createdAt: now,
        updatedAt: now,
      ),
    ];

    test('exports formatted Plain Text tracklist', () {
      final text = PlaylistExportService.exportAsPlainText(samplePlaylist, sampleItems);

      expect(text, contains('PLAYLIST: Retro Hits'));
      expect(text, contains('DESCRIPTION: Golden classics of the 80s and 90s'));
      expect(text, contains('TOTAL TRACKS: 2'));
      expect(text, contains('01. [SONG] Billie Jean - Michael Jackson (Thriller) [4:54]'));
      expect(text, contains('02. [CLIP] Guitar Solo Clip - Eddie Van Halen (1984) [2:06]'));
    });

    test('exports properly formatted CSV', () {
      final csv = PlaylistExportService.exportAsCsv(samplePlaylist, sampleItems);
      final lines = csv.trim().split('\n');

      expect(lines.length, 3); // Header + 2 items
      expect(lines[0], contains('Playlist Name,Description,Position,Item Title'));
      expect(lines[1], contains('Retro Hits'));
      expect(lines[1], contains('Billie Jean'));
      expect(lines[2], contains('Guitar Solo Clip'));
    });

    test('exports structured JSON matching Pattu Petti schema', () {
      final jsonStr = PlaylistExportService.exportAsJson(samplePlaylist, sampleItems);
      final decoded = json.decode(jsonStr) as Map<String, dynamic>;

      expect(decoded['pattu_petti_version'], '1.0');
      expect(decoded['playlist']['name'], 'Retro Hits');
      expect(decoded['playlist']['total_items'], 2);

      final items = decoded['items'] as List<dynamic>;
      expect(items.length, 2);
      expect(items[0]['title'], 'Billie Jean');
      expect(items[0]['item_type'], 'song');
      expect(items[1]['title'], 'Guitar Solo Clip');
      expect(items[1]['item_type'], 'clip');
      expect(items[1]['clip_start_ms'], 30000);
      expect(items[1]['clip_end_ms'], 156000);
    });
  });

  group('Drift In-Memory Playlist Database & Repository Operations', () {
    late AppDatabase db;
    late PlaylistRepositoryImpl repository;
    const testUserId = 'test-user-uuid';

    setUp(() {
      db = AppDatabase.forTesting(NativeDatabase.memory());
      repository = PlaylistRepositoryImpl(db);
    });

    tearDown(() async {
      await db.close();
    });

    test('createPlaylist validates name and trims whitespace', () async {
      // Empty name throws ArgumentError
      expect(
        repository.createPlaylist(userId: testUserId, name: '   '),
        throwsA(isA<ArgumentError>()),
      );

      // Name exceeding 100 characters throws
      expect(
        repository.createPlaylist(userId: testUserId, name: 'A' * 101),
        throwsA(isA<ArgumentError>()),
      );

      // Valid creation
      final id = await repository.createPlaylist(
        userId: testUserId,
        name: '  Morning Drive  ',
        description: '  Energetic songs  ',
      );

      expect(id, isNotEmpty);
      final pl = await repository.getPlaylist(id);
      expect(pl, isNotNull);
      expect(pl!.name, 'Morning Drive');
      expect(pl.description, 'Energetic songs');
      expect(pl.isLiked, isFalse);
    });

    test('addItemsToPlaylist prevents duplicate references of same audio item', () async {
      final plId = await repository.createPlaylist(
        userId: testUserId,
        name: 'Party Mix',
      );

      // Insert dummy audio items into AudioItems table
      await db.into(db.audioItems).insert(
        AudioItemsCompanion.insert(
          id: 'song-a',
          userId: testUserId,
          itemType: 'song',
          title: 'Song A',
          durationMs: const drift.Value(200000),
        ),
      );
      await db.into(db.audioItems).insert(
        AudioItemsCompanion.insert(
          id: 'song-b',
          userId: testUserId,
          itemType: 'song',
          title: 'Song B',
          durationMs: const drift.Value(180000),
        ),
      );

      // Add items initially
      final added1 = await repository.addItemsToPlaylist(plId, ['song-a', 'song-b']);
      expect(added1, 2);

      var items = await repository.getPlaylistItems(plId);
      expect(items.length, 2);
      expect(items[0].position, 1);
      expect(items[1].position, 2);

      // Attempt to add same items again
      final added2 = await repository.addItemsToPlaylist(plId, ['song-a', 'song-b']);
      expect(added2, 0); // No duplicates added!

      items = await repository.getPlaylistItems(plId);
      expect(items.length, 2); // Count remains 2
    });

    test('reorderPlaylist updates sequential positions immediately without touching audio', () async {
      final plId = await repository.createPlaylist(userId: testUserId, name: 'Reorder Test');

      await db.into(db.audioItems).insert(
        AudioItemsCompanion.insert(id: 'item-1', userId: testUserId, itemType: 'song', title: '1'),
      );
      await db.into(db.audioItems).insert(
        AudioItemsCompanion.insert(id: 'item-2', userId: testUserId, itemType: 'song', title: '2'),
      );
      await db.into(db.audioItems).insert(
        AudioItemsCompanion.insert(id: 'item-3', userId: testUserId, itemType: 'song', title: '3'),
      );

      await repository.addItemsToPlaylist(plId, ['item-1', 'item-2', 'item-3']);

      // Reverse order: item-3, item-1, item-2
      await repository.reorderPlaylist(plId, ['item-3', 'item-1', 'item-2']);

      final reordered = await repository.getPlaylistItems(plId);
      expect(reordered[0].audioItemId, 'item-3');
      expect(reordered[0].position, 0);
      expect(reordered[1].audioItemId, 'item-1');
      expect(reordered[1].position, 1);
      expect(reordered[2].audioItemId, 'item-2');
      expect(reordered[2].position, 2);

      // Verify audio items in AudioItems table remain unchanged
      final aItem = await db.getAudioItemById('item-1');
      expect(aItem, isNotNull);
      expect(aItem!.title, '1');
    });

    test('removeItemFromPlaylist deletes reference row only and never deletes audio', () async {
      final plId = await repository.createPlaylist(userId: testUserId, name: 'Delete Ref Test');

      await db.into(db.audioItems).insert(
        AudioItemsCompanion.insert(id: 'song-keep', userId: testUserId, itemType: 'song', title: 'Song Keep'),
      );

      await repository.addItemsToPlaylist(plId, ['song-keep']);
      expect((await repository.getPlaylistItems(plId)).length, 1);

      // Remove from playlist
      await repository.removeItemFromPlaylist(plId, 'song-keep');
      expect((await repository.getPlaylistItems(plId)).length, 0);

      // Audio item still exists in database!
      final stillExists = await db.getAudioItemById('song-keep');
      expect(stillExists, isNotNull);
      expect(stillExists!.title, 'Song Keep');
    });

    test('duplicatePlaylist creates copy of metadata and item references', () async {
      final origId = await repository.createPlaylist(
        userId: testUserId,
        name: 'Road Trip',
        description: 'Driving tunes',
      );

      await db.into(db.audioItems).insert(
        AudioItemsCompanion.insert(id: 'song-x', userId: testUserId, itemType: 'song', title: 'Song X'),
      );
      await repository.addItemsToPlaylist(origId, ['song-x']);

      final copyId = await repository.duplicatePlaylist(origId, 'Copy of Road Trip');
      expect(copyId, isNotNull);
      expect(copyId, isNot(origId));

      final copyPl = await repository.getPlaylist(copyId!);
      expect(copyPl!.name, 'Copy of Road Trip');
      expect(copyPl.description, 'Driving tunes');

      final copyItems = await repository.getPlaylistItems(copyId);
      expect(copyItems.length, 1);
      expect(copyItems.first.audioItemId, 'song-x');
    });

    test('deletePlaylist removes playlist and references while preserving audio', () async {
      final plId = await repository.createPlaylist(userId: testUserId, name: 'To Be Deleted');
      await db.into(db.audioItems).insert(
        AudioItemsCompanion.insert(id: 'song-persist', userId: testUserId, itemType: 'song', title: 'Persist'),
      );
      await repository.addItemsToPlaylist(plId, ['song-persist']);

      // Delete playlist
      await repository.deletePlaylist(plId);

      // Playlist is gone
      final pl = await repository.getPlaylist(plId);
      expect(pl, isNull);

      // Items references are gone
      final items = await repository.getPlaylistItems(plId);
      expect(items, isEmpty);

      // Underlying audio item is still 100% intact!
      final audioItem = await db.getAudioItemById('song-persist');
      expect(audioItem, isNotNull);
    });

    test('toggleLike toggles playlist like independently from songs', () async {
      final plId = await repository.createPlaylist(userId: testUserId, name: 'Liked Test');
      await db.into(db.audioItems).insert(
        AudioItemsCompanion.insert(
          id: 'song-independent',
          userId: testUserId,
          itemType: 'song',
          title: 'Indie',
          isLiked: const drift.Value(false),
        ),
      );

      // Like the playlist
      await repository.toggleLike(plId, true);
      final pl = await repository.getPlaylist(plId);
      expect(pl!.isLiked, isTrue);

      // Song inside remains unliked
      final song = await db.getAudioItemById('song-independent');
      expect(song!.isLiked, isFalse);
    });

    test('smart playlists dynamically calculate items from metadata', () async {
      // Seed audio items
      await db.into(db.audioItems).insert(
        AudioItemsCompanion.insert(
          id: 'song-liked',
          userId: testUserId,
          itemType: 'song',
          title: 'Loved Song',
          isLiked: const drift.Value(true),
        ),
      );
      await db.into(db.audioItems).insert(
        AudioItemsCompanion.insert(
          id: 'song-played',
          userId: testUserId,
          itemType: 'song',
          title: 'Played Song',
          playCount: const drift.Value(15),
          lastPlayedAt: drift.Value(DateTime.now()),
        ),
      );
      await db.into(db.audioItems).insert(
        AudioItemsCompanion.insert(
          id: 'song-long',
          userId: testUserId,
          itemType: 'song',
          title: 'Podcast Episode',
          durationMs: const drift.Value(720000), // 12 min (> 10 min)
        ),
      );

      // Test Liked Songs smart playlist
      final likedList = await repository.getSmartPlaylist(testUserId, SmartPlaylistType.likedSongs);
      expect(likedList.any((e) => e.id == 'song-liked'), isTrue);

      // Test Recently Played smart playlist
      final playedList = await repository.getSmartPlaylist(testUserId, SmartPlaylistType.recentlyPlayed);
      expect(playedList.any((e) => e.id == 'song-played'), isTrue);

      // Test Most Played smart playlist
      final mostPlayedList = await repository.getSmartPlaylist(testUserId, SmartPlaylistType.mostPlayed);
      expect(mostPlayedList.any((e) => e.id == 'song-played'), isTrue);

      // Test Long Audio smart playlist
      final longList = await repository.getSmartPlaylist(testUserId, SmartPlaylistType.longAudio);
      expect(longList.any((e) => e.id == 'song-long'), isTrue);
    });
  });
}
