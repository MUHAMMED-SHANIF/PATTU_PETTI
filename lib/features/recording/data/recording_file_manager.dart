import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:ffmpeg_kit_flutter_new/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter_new/return_code.dart';
import 'package:share_plus/share_plus.dart';

class RecordingFileManager {
  const RecordingFileManager();

  /// Gets or creates the persistent recordings directory: PattuPetti/Recordings
  Future<Directory> getRecordingsDirectory() async {
    final baseDir = await getApplicationDocumentsDirectory();
    final recordingsDir = Directory(p.join(baseDir.path, 'PattuPetti', 'Recordings'));
    if (!await recordingsDir.exists()) {
      await recordingsDir.create(recursive: true);
    }
    return recordingsDir;
  }

  /// Creates a temporary file path for in-progress recording
  Future<String> createTempRecordingPath() async {
    final tempDir = await getTemporaryDirectory();
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final tempFile = File(p.join(tempDir.path, 'temp_rec_$timestamp.m4a'));
    return tempFile.path;
  }

  /// Generates a unique, non-colliding file path in PattuPetti/Recordings
  Future<String> generateUniqueRecordingPath({String? customTitle}) async {
    final dir = await getRecordingsDirectory();
    String baseName;

    if (customTitle != null && customTitle.trim().isNotEmpty) {
      // Sanitize custom title
      baseName = customTitle.trim().replaceAll(RegExp(r'[\\/:*?"<>|]'), '_');
    } else {
      final now = DateTime.now();
      final formatter = DateFormat('yyyy-MM-dd_HH-mm-ss');
      baseName = 'Recording_${formatter.format(now)}';
    }

    var filePath = p.join(dir.path, '$baseName.m4a');
    var counter = 1;
    while (await File(filePath).exists()) {
      filePath = p.join(dir.path, '${baseName}_$counter.m4a');
      counter++;
    }
    return filePath;
  }

  /// Non-destructively trims audio from [inputPath] to [outputPath] using lossless stream copy.
  Future<String> trimAudio({
    required String inputPath,
    required String outputPath,
    required double startSeconds,
    required double durationSeconds,
  }) async {
    try {
      final command =
          '-ss $startSeconds -i "$inputPath" -t $durationSeconds -c copy -y "$outputPath"';
      final session = await FFmpegKit.execute(command);
      final returnCode = await session.getReturnCode();

      if (ReturnCode.isSuccess(returnCode)) {
        return outputPath;
      }

      // Fallback: copy entire file if trim failed
      debugPrint('FFmpeg stream copy trim failed, copying original file.');
      await File(inputPath).copy(outputPath);
      return outputPath;
    } catch (e) {
      debugPrint('Error trimming recording: $e');
      await File(inputPath).copy(outputPath);
      return outputPath;
    }
  }

  /// Safely deletes a file if it exists.
  Future<void> deleteFile(String? filePath) async {
    if (filePath == null || filePath.isEmpty) return;
    try {
      final file = File(filePath);
      if (await file.exists()) {
        await file.delete();
      }
    } catch (e) {
      debugPrint('Error deleting file $filePath: $e');
    }
  }

  /// Shares the recording file via the platform native share sheet.
  static Future<void> shareRecording(String filePath, {String? title}) async {
    final file = File(filePath);
    if (!await file.exists()) {
      throw Exception('Recording file does not exist.');
    }
    // ignore: deprecated_member_use
    await Share.shareXFiles(
      [XFile(filePath, mimeType: 'audio/mp4')],
      text: title ?? 'Audio recording from Pattu Petti',
    );
  }

  /// Exports the recording to a destination directory.
  Future<String> exportRecording({
    required String sourcePath,
    required String destinationDirectory,
    String? exportFileName,
  }) async {
    final source = File(sourcePath);
    if (!await source.exists()) {
      throw Exception('Source recording file not found.');
    }

    final name = exportFileName ?? p.basename(sourcePath);
    final targetPath = p.join(destinationDirectory, name);
    final target = await source.copy(targetPath);
    return target.path;
  }
}
