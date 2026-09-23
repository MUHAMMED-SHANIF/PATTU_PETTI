// ignore_for_file: deprecated_member_use

import 'package:share_plus/share_plus.dart';
import '../../../../domain/entities/audio_item_entity.dart';
import '../../domain/entities/playlist_entity.dart';
import 'playlist_export_service.dart';

class PlaylistShareService {
  /// Shares playlist summary and tracklist via the system share sheet.
  static Future<void> sharePlaylistText({
    required PlaylistEntity playlist,
    required List<AudioItemEntity> items,
  }) async {
    final text = PlaylistExportService.exportAsPlainText(playlist, items);
    await Share.share(
      text,
      subject: 'Pattu Petti Playlist: ${playlist.name}',
    );
  }

  /// Exports the playlist to a file (Text, CSV, or JSON) and triggers the system share sheet.
  static Future<void> sharePlaylistFile({
    required PlaylistEntity playlist,
    required List<AudioItemEntity> items,
    required String format, // 'txt' | 'csv' | 'json'
  }) async {
    final String content;
    final String mimeType;

    switch (format.toLowerCase()) {
      case 'csv':
        content = PlaylistExportService.exportAsCsv(playlist, items);
        mimeType = 'text/csv';
        break;
      case 'json':
        content = PlaylistExportService.exportAsJson(playlist, items);
        mimeType = 'application/json';
        break;
      case 'txt':
      default:
        content = PlaylistExportService.exportAsPlainText(playlist, items);
        mimeType = 'text/plain';
        break;
    }

    final file = await PlaylistExportService.writeExportFile(
      playlistName: playlist.name,
      content: content,
      extension: format.toLowerCase(),
    );

    await Share.shareXFiles(
      [XFile(file.path, mimeType: mimeType)],
      text: 'Pattu Petti Playlist: ${playlist.name}',
      subject: playlist.name,
    );
  }

  /// Generates a deep link string for future cloud sync sharing.
  static String generateDeepLink(String playlistId) {
    return 'https://pattupetti.app/playlist/$playlistId';
  }
}
