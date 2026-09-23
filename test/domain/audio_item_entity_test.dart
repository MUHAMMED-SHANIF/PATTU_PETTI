import 'package:flutter_test/flutter_test.dart';
import 'package:patt_petti/domain/entities/audio_item_entity.dart';

void main() {
  group('AudioItemEntity', () {
    final baseSong = AudioItemEntity(
      id: 'song-1',
      userId: 'user-1',
      itemType: AudioItemType.song,
      title: 'Aalaporan Thamizhan',
      artist: 'A.R. Rahman',
      album: 'Mersal',
      durationMs: 348000,
      filePath: '/storage/emulated/0/Music/song1.mp3',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    test('should correctly instantiate and preserve fields', () {
      expect(baseSong.id, 'song-1');
      expect(baseSong.itemType, AudioItemType.song);
      expect(baseSong.title, 'Aalaporan Thamizhan');
      expect(baseSong.durationMs, 348000);
      expect(baseSong.isLiked, isFalse);
      expect(baseSong.starNumber, isNull);
    });

    test('copyWith should properly update specified fields', () {
      final updated = baseSong.copyWith(
        isLiked: true,
        starNumber: 1,
        playCount: 5,
      );

      expect(updated.isLiked, isTrue);
      expect(updated.starNumber, 1);
      expect(updated.playCount, 5);
      expect(updated.title, baseSong.title);
    });

    test('AudioItemType.fromString should parse enum types properly', () {
      expect(AudioItemType.fromString('song'), AudioItemType.song);
      expect(AudioItemType.fromString('clip'), AudioItemType.clip);
      expect(AudioItemType.fromString('merged'), AudioItemType.merged);
      expect(AudioItemType.fromString('recording'), AudioItemType.recording);
      expect(() => AudioItemType.fromString('unknown'), throwsArgumentError);
    });
  });

  group('ResolvedClipEntity (Virtual Clips)', () {
    final sourceSong = AudioItemEntity(
      id: 'song-100',
      userId: 'user-1',
      itemType: AudioItemType.song,
      title: 'Original Track',
      durationMs: 300000, // 5 minutes
      filePath: '/music/track.mp3',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    test('Root clip should have direct absolute timestamps', () {
      final rootClip = AudioItemEntity(
        id: 'clip-root',
        userId: 'user-1',
        itemType: AudioItemType.clip,
        title: 'Hook Clip',
        clipStartMs: 30000, // 30s
        clipEndMs: 60000,   // 60s
        sourceAudioItemId: 'song-100',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final resolved = ResolvedClipEntity(clip: rootClip, source: sourceSong);

      expect(resolved.absoluteStartMs, 30000);
      expect(resolved.absoluteEndMs, 60000);
      expect(resolved.sourceFilePath, '/music/track.mp3');
    });

    test('Nested clip should properly normalize relative to parent bounds', () {
      final parentClip = AudioItemEntity(
        id: 'clip-parent',
        userId: 'user-1',
        itemType: AudioItemType.clip,
        title: 'Verse Clip',
        clipStartMs: 20000, // Starts at 20s of source
        clipEndMs: 80000,
        sourceAudioItemId: 'song-100',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      // Child clip is 5s to 15s relative to the parent clip
      final childClip = AudioItemEntity(
        id: 'clip-child',
        userId: 'user-1',
        itemType: AudioItemType.clip,
        title: 'Vocal Snippet',
        parentClipId: 'clip-parent',
        clipStartMs: 5000,
        clipEndMs: 15000,
        sourceAudioItemId: 'song-100',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final resolved = ResolvedClipEntity(clip: childClip, source: parentClip);

      // Absolute start: parent start (20000) + child start (5000) = 25000ms
      expect(resolved.absoluteStartMs, 25000);
      // Absolute end: parent start (20000) + child end (15000) = 35000ms
      expect(resolved.absoluteEndMs, 35000);
    });
  });
}
