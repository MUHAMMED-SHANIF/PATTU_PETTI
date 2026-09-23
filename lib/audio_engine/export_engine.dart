import 'dart:io';
import 'package:ffmpeg_kit_flutter_new/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter_new/return_code.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:uuid/uuid.dart';
import '../core/errors/app_error.dart';
import '../core/constants/app_constants.dart';

/// Physical audio export engine using FFmpeg.
/// Only invoked when explicitly required:
/// - User exports a clip as a file
/// - User shares a clip as audio
/// - User makes a clip independent
/// - User deletes source and chooses "Preserve Clips"
/// - User exports a merged track
///
/// Normal clip creation does NOT use this class.
class ExportEngine {
  ExportEngine._();

  static const _uuid = Uuid();

  /// Render a virtual clip to a physical audio file.
  /// [sourcePath] — path to the source audio file.
  /// [startMs] — absolute start timestamp in milliseconds.
  /// [endMs] — absolute end timestamp in milliseconds.
  /// [outputFormat] — output format: 'mp3', 'm4a', 'flac', 'wav', 'ogg'
  /// [outputName] — desired base name (without extension)
  ///
  /// Returns path to the newly created file.
  static Future<Result<String>> renderClip({
    required String sourcePath,
    required int startMs,
    required int endMs,
    String outputFormat = 'm4a',
    String? outputName,
  }) async {
    try {
      final outputDir = await _getClipsDir();
      final name = outputName ?? _uuid.v4();
      final outputPath = p.join(outputDir, '$name.$outputFormat');

      // Ensure output directory exists
      await Directory(outputDir).create(recursive: true);

      final startSeconds = startMs / 1000.0;
      final durationSeconds = (endMs - startMs) / 1000.0;

      // FFmpeg command: copy codec where possible to preserve quality
      // Use -c copy for formats that support it without re-encoding
      final canCopy = _canUseCopyCodec(p.extension(sourcePath).toLowerCase(), outputFormat);
      final codecArg = canCopy ? '-c copy' : _getEncodeArgs(outputFormat);

      final command = '-i "$sourcePath" '
          '-ss $startSeconds '
          '-t $durationSeconds '
          '$codecArg '
          '-y "$outputPath"';

      final session = await FFmpegKit.execute(command);
      final returnCode = await session.getReturnCode();

      if (!ReturnCode.isSuccess(returnCode)) {
        final logs = await session.getAllLogsAsString();
        return Failure(ClipError(message: 'Export failed: $logs'));
      }

      return Success(outputPath);
    } catch (e) {
      return Failure(ClipError(message: 'Export failed: ${e.toString()}'));
    }
  }

  /// Render a merged track to a single audio file.
  /// [segments] — list of {filePath, startMs, endMs} maps representing each segment.
  /// Each segment may be a full file (startMs=0, endMs=duration) or a clip range.
  static Future<Result<String>> renderMerge({
    required List<MergeSegment> segments,
    String outputFormat = 'm4a',
    String? outputName,
    int fadeMs = 500,
  }) async {
    if (segments.isEmpty) {
      return const Failure(MergeError(message: 'No segments to merge.'));
    }

    try {
      final outputDir = await _getMergedDir();
      final name = outputName ?? _uuid.v4();
      final outputPath = p.join(outputDir, '$name.$outputFormat');

      await Directory(outputDir).create(recursive: true);

      // Build FFmpeg concat filter
      // Each segment: trim to range, apply fade in/out
      final inputs = segments.map((s) => '-i "${s.filePath}"').join(' ');
      final filterParts = <String>[];
      final concatParts = <String>[];

      for (int i = 0; i < segments.length; i++) {
        final seg = segments[i];
        final start = seg.startMs / 1000.0;
        final duration = (seg.endMs - seg.startMs) / 1000.0;
        final fadeInDur = fadeMs / 1000.0;
        final fadeOutDur = fadeMs / 1000.0;
        final fadeOutStart = (duration - fadeOutDur).clamp(0.0, duration);

        filterParts.add(
          '[$i:a]atrim=start=$start:duration=$duration,'
          'asetpts=PTS-STARTPTS,'
          'afade=t=in:st=0:d=$fadeInDur,'
          'afade=t=out:st=$fadeOutStart:d=$fadeOutDur[s$i]',
        );
        concatParts.add('[s$i]');
      }

      final concatFilter = '${concatParts.join('')}concat=n=${segments.length}:v=0:a=1[out]';
      final filter = '${filterParts.join(';')};$concatFilter';

      final command = '$inputs '
          '-filter_complex "$filter" '
          '-map "[out]" '
          '${_getEncodeArgs(outputFormat)} '
          '-y "$outputPath"';

      final session = await FFmpegKit.execute(command);
      final returnCode = await session.getReturnCode();

      if (!ReturnCode.isSuccess(returnCode)) {
        final logs = await session.getAllLogsAsString();
        return Failure(MergeError(message: 'Merge export failed: $logs'));
      }

      return Success(outputPath);
    } catch (e) {
      return Failure(MergeError(message: 'Merge export failed: ${e.toString()}'));
    }
  }

  // ─── Helpers ──────────────────────────────────────────────────────────────

  static Future<String> _getClipsDir() async {
    final base = await getExternalStorageDirectory() ??
        await getApplicationDocumentsDirectory();
    return p.join(base.path, AppConstants.folderClips);
  }

  static Future<String> _getMergedDir() async {
    final base = await getExternalStorageDirectory() ??
        await getApplicationDocumentsDirectory();
    return p.join(base.path, AppConstants.folderMerged);
  }

  static bool _canUseCopyCodec(String sourceExt, String outputFormat) {
    // Copy codec only when source and output are same container/codec
    return (sourceExt == '.mp3' && outputFormat == 'mp3') ||
        (sourceExt == '.m4a' && outputFormat == 'm4a') ||
        (sourceExt == '.flac' && outputFormat == 'flac');
  }

  static String _getEncodeArgs(String format) {
    return switch (format) {
      'mp3' => '-c:a libmp3lame -q:a 2',
      'm4a' => '-c:a aac -b:a 192k',
      'flac' => '-c:a flac',
      'wav' => '-c:a pcm_s16le',
      'ogg' => '-c:a libvorbis -q:a 6',
      _ => '-c:a aac -b:a 192k',
    };
  }
}

/// Represents one segment in a merge operation.
class MergeSegment {
  const MergeSegment({
    required this.filePath,
    required this.startMs,
    required this.endMs,
  });

  final String filePath;
  final int startMs;
  final int endMs;

  int get durationMs => endMs - startMs;
}
