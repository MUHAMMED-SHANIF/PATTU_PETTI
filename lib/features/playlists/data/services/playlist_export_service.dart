import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../../../../domain/entities/audio_item_entity.dart';
import '../../domain/entities/playlist_entity.dart';

class PlaylistExportService {
  /// Exports playlist as human-readable Plain Text tracklist.
  static String exportAsPlainText(PlaylistEntity playlist, List<AudioItemEntity> items) {
    final buffer = StringBuffer();
    buffer.writeln('========================================');
    buffer.writeln('PLAYLIST: ${playlist.name}');
    if (playlist.description != null && playlist.description!.isNotEmpty) {
      buffer.writeln('DESCRIPTION: ${playlist.description}');
    }
    buffer.writeln('TOTAL TRACKS: ${items.length}');
    buffer.writeln('TOTAL DURATION: ${playlist.formattedDuration}');
    buffer.writeln('EXPORTED: ${DateTime.now().toLocal().toString().split('.')[0]}');
    buffer.writeln('========================================\n');

    for (int i = 0; i < items.length; i++) {
      final item = items[i];
      final num = (i + 1).toString().padLeft(2, '0');
      final dur = item.durationMs != null
          ? _formatDurationMs(item.durationMs!)
          : '--:--';
      final type = item.itemType.name.toUpperCase();
      buffer.writeln('$num. [$type] ${item.title} - ${item.displayArtist} (${item.displayAlbum}) [$dur]');
    }

    buffer.writeln('\nGenerated with Pattu Petti');
    return buffer.toString();
  }

  /// Exports playlist as CSV formatted text.
  static String exportAsCsv(PlaylistEntity playlist, List<AudioItemEntity> items) {
    final buffer = StringBuffer();
    buffer.writeln('Playlist Name,Description,Position,Item Title,Artist,Album,Item Type,Duration (ms),Duration Formatted');

    final plName = _escapeCsv(playlist.name);
    final plDesc = _escapeCsv(playlist.description ?? '');

    for (int i = 0; i < items.length; i++) {
      final it = items[i];
      final pos = (i + 1).toString();
      final title = _escapeCsv(it.title);
      final artist = _escapeCsv(it.displayArtist);
      final album = _escapeCsv(it.displayAlbum);
      final type = it.itemType.name;
      final durMs = (it.durationMs ?? 0).toString();
      final durFormatted = it.durationMs != null ? _formatDurationMs(it.durationMs!) : '';

      buffer.writeln('$plName,$plDesc,$pos,$title,$artist,$album,$type,$durMs,$durFormatted');
    }

    return buffer.toString();
  }

  /// Exports playlist as structured JSON matching Pattu Petti Playlist schema.
  static String exportAsJson(PlaylistEntity playlist, List<AudioItemEntity> items) {
    final map = {
      'pattu_petti_version': '1.0',
      'exported_at': DateTime.now().toIso8601String(),
      'playlist': {
        'id': playlist.id,
        'name': playlist.name,
        'description': playlist.description,
        'is_liked': playlist.isLiked,
        'is_smart': playlist.isSmart,
        'total_items': items.length,
        'total_duration_ms': playlist.totalDurationMs,
      },
      'items': items.asMap().entries.map((entry) {
        final i = entry.key;
        final item = entry.value;
        return {
          'position': i + 1,
          'id': item.id,
          'title': item.title,
          'artist': item.artist,
          'album': item.album,
          'album_artist': item.albumArtist,
          'genre': item.genre,
          'year': item.year,
          'item_type': item.itemType.name,
          'duration_ms': item.durationMs,
          'is_virtual_clip': item.isVirtualClip,
          'clip_start_ms': item.clipStartMs,
          'clip_end_ms': item.clipEndMs,
        };
      }).toList(),
    };

    return const JsonEncoder.withIndent('  ').convert(map);
  }

  /// Writes the exported content to a temporary file on the device for sharing or saving.
  static Future<File> writeExportFile({
    required String playlistName,
    required String content,
    required String extension, // 'txt', 'csv', 'json'
  }) async {
    final tempDir = await getTemporaryDirectory();
    final sanitized = playlistName.replaceAll(RegExp(r'[\\/:*?"<>|]'), '_');
    final filePath = '${tempDir.path}/${sanitized}_playlist.$extension';
    final file = File(filePath);
    await file.writeAsString(content);
    return file;
  }

  static String _escapeCsv(String value) {
    if (value.contains(',') || value.contains('"') || value.contains('\n')) {
      return '"${value.replaceAll('"', '""')}"';
    }
    return value;
  }

  static String _formatDurationMs(int ms) {
    final d = Duration(milliseconds: ms);
    final m = d.inMinutes;
    final s = d.inSeconds.remainder(60);
    return '$m:${s.toString().padLeft(2, '0')}';
  }
}
