import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:just_audio/just_audio.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/recording_state.dart';
import '../providers/recording_provider.dart';

class RecordingScreen extends ConsumerStatefulWidget {
  const RecordingScreen({super.key});

  @override
  ConsumerState<RecordingScreen> createState() => _RecordingScreenState();
}

class _RecordingScreenState extends ConsumerState<RecordingScreen> {
  // Preview Player
  AudioPlayer? _previewPlayer;
  bool _isPreviewPlaying = false;
  Duration _previewPosition = Duration.zero;
  Duration _previewDuration = Duration.zero;

  // Metadata Controllers
  final _titleController = TextEditingController();
  final _artistController = TextEditingController();
  final _albumController = TextEditingController(text: 'Recordings');
  final _genreController = TextEditingController(text: 'Recording');
  final _descController = TextEditingController();
  String? _selectedArtworkPath;

  // Trim Controllers (seconds)
  double _trimStartSec = 0.0;
  double _trimEndSec = 0.0;
  bool _isTrimming = false;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _titleController.text = 'Recording_${DateFormat('yyyy-MM-dd_HH-mm').format(now)}';
  }

  @override
  void dispose() {
    _previewPlayer?.dispose();
    _titleController.dispose();
    _artistController.dispose();
    _albumController.dispose();
    _genreController.dispose();
    _descController.dispose();
    super.dispose();
  }

  Future<void> _initPreviewPlayer(String filePath) async {
    _previewPlayer?.dispose();
    final player = AudioPlayer();
    _previewPlayer = player;

    try {
      await player.setFilePath(filePath);
      final dur = player.duration ?? Duration.zero;
      if (mounted) {
        setState(() {
          _previewDuration = dur;
          _trimStartSec = 0.0;
          _trimEndSec = dur.inMilliseconds / 1000.0;
        });
      }

      player.playerStateStream.listen((ps) {
        if (mounted) {
          setState(() {
            _isPreviewPlaying = ps.playing &&
                ps.processingState != ProcessingState.completed;
            if (ps.processingState == ProcessingState.completed) {
              _previewPosition = Duration.zero;
            }
          });
        }
      });

      player.positionStream.listen((pos) {
        if (mounted) {
          setState(() {
            _previewPosition = pos;
            // Loop / limit within trim window if trimming
            if (_isTrimming && _trimEndSec > _trimStartSec) {
              if (pos.inMilliseconds >= (_trimEndSec * 1000)) {
                player.seek(Duration(milliseconds: (_trimStartSec * 1000).round()));
                player.pause();
              }
            }
          });
        }
      });
    } catch (e) {
      debugPrint('Error initializing preview audio player: $e');
    }
  }

  Future<void> _pickArtwork() async {
    try {
      final picker = ImagePicker();
      final image = await picker.pickImage(source: ImageSource.gallery, imageQuality: 85);
      if (image != null && mounted) {
        setState(() => _selectedArtworkPath = image.path);
      }
    } catch (e) {
      debugPrint('Error picking artwork: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(recordingNotifierProvider);
    final notifier = ref.read(recordingNotifierProvider.notifier);

    // If state moved to preview and preview player isn't loaded yet
    if (state.status == RecordingStatus.preview &&
        state.tempFilePath != null &&
        _previewPlayer == null) {
      _initPreviewPlayer(state.tempFilePath!);
    }

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: Text(
          state.status == RecordingStatus.preview
              ? 'Preview Recording'
              : 'Studio Recorder',
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () async {
            if (state.isRecording || state.isPaused) {
              final confirm = await _showExitConfirmDialog();
              if (confirm == true) {
                await notifier.cancelRecording();
                if (context.mounted) context.pop();
              }
            } else {
              context.pop();
            }
          },
        ),
      ),
      body: state.status == RecordingStatus.preview
          ? _buildPreviewView(state, notifier)
          : _buildLiveRecordingView(state, notifier),
    );
  }

  // ───────────────────────────────────────────────────────────────────────────
  // VIEW 1: LIVE RECORDING STUDIO
  // ───────────────────────────────────────────────────────────────────────────
  Widget _buildLiveRecordingView(
    RecordingSessionState state,
    RecordingNotifier notifier,
  ) {
    if (state.permissionDenied) {
      return _buildPermissionDeniedView(state, notifier);
    }

    final isRecording = state.status == RecordingStatus.recording;
    final isPaused = state.status == RecordingStatus.paused;
    final isPreparing = state.status == RecordingStatus.preparing;

    return Column(
      children: [
        const Spacer(),

        // 1. Status Indicator & Pulse Dot
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: isRecording
                ? AppTheme.error.withValues(alpha: 0.15)
                : isPaused
                    ? const Color(0xFFF59E0B).withValues(alpha: 0.15)
                    : AppTheme.surfaceHighlight,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isRecording
                  ? AppTheme.error.withValues(alpha: 0.4)
                  : isPaused
                      ? const Color(0xFFF59E0B).withValues(alpha: 0.4)
                      : Colors.transparent,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isRecording)
                Container(
                  width: 10,
                  height: 10,
                  margin: const EdgeInsets.only(right: 8),
                  decoration: const BoxDecoration(
                    color: AppTheme.error,
                    shape: BoxShape.circle,
                  ),
                ),
              Text(
                isRecording
                    ? 'RECORDING LIVE'
                    : isPaused
                        ? 'RECORDING PAUSED'
                        : isPreparing
                            ? 'INITIALIZING MIC...'
                            : 'STUDIO READY',
                style: TextStyle(
                  color: isRecording
                      ? AppTheme.error
                      : isPaused
                          ? const Color(0xFFF59E0B)
                          : AppTheme.textSecondary,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.1,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // 2. Large Digital Elapsed Time
        Text(
          _formatDuration(state.duration),
          style: const TextStyle(
            color: AppTheme.textPrimary,
            fontSize: 54,
            fontWeight: FontWeight.w800,
            letterSpacing: 2,
            fontFeatures: [FontFeature.tabularFigures()],
          ),
        ),
        const SizedBox(height: 36),

        // 3. Dynamic Waveform Visualizer
        Container(
          height: 110,
          margin: const EdgeInsets.symmetric(horizontal: 24),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: AppTheme.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
          ),
          child: CustomPaint(
            size: const Size(double.infinity, 94),
            painter: _WaveformPainter(
              amplitudes: state.recentAmplitudes,
              isActive: isRecording,
              isPaused: isPaused,
            ),
          ),
        ),

        const Spacer(),

        // 4. Control Cluster
        if (state.isIdle)
          _buildIdleStartButton(notifier)
        else
          _buildActiveControls(state, notifier),

        const SizedBox(height: 48),
      ],
    );
  }

  Widget _buildIdleStartButton(RecordingNotifier notifier) {
    return Column(
      children: [
        GestureDetector(
          onTap: () => notifier.startRecording(),
          child: Container(
            width: 84,
            height: 84,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppTheme.error,
              boxShadow: [
                BoxShadow(
                  color: AppTheme.error.withValues(alpha: 0.4),
                  blurRadius: 28,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: const Icon(Icons.mic_rounded, color: Colors.white, size: 40),
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Tap to Start Recording',
          style: TextStyle(color: AppTheme.textSecondary, fontSize: 14, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  Widget _buildActiveControls(
    RecordingSessionState state,
    RecordingNotifier notifier,
  ) {
    final isPaused = state.status == RecordingStatus.paused;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Cancel Button
          IconButton(
            tooltip: 'Cancel & Discard',
            iconSize: 32,
            icon: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.surfaceHighlight,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.close_rounded, color: AppTheme.textSecondary, size: 24),
            ),
            onPressed: () async {
              final confirm = await _showExitConfirmDialog();
              if (confirm == true) {
                await notifier.cancelRecording();
              }
            },
          ),

          // Pause / Resume Button
          IconButton(
            tooltip: isPaused ? 'Resume Recording' : 'Pause Recording',
            iconSize: 42,
            icon: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: isPaused
                    ? const Color(0xFFF59E0B)
                    : AppTheme.surfaceHighlight,
                shape: BoxShape.circle,
              ),
              child: Icon(
                isPaused ? Icons.play_arrow_rounded : Icons.pause_rounded,
                color: isPaused ? Colors.black : AppTheme.textPrimary,
                size: 28,
              ),
            ),
            onPressed: () {
              if (isPaused) {
                notifier.resumeRecording();
              } else {
                notifier.pauseRecording();
              }
            },
          ),

          // Stop Button (Finalizes and enters Preview)
          GestureDetector(
            onTap: () => notifier.stopRecording(),
            child: Container(
              width: 68,
              height: 68,
              decoration: BoxDecoration(
                color: AppTheme.accent,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.accent.withValues(alpha: 0.35),
                    blurRadius: 18,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(Icons.stop_rounded, color: Colors.black, size: 36),
            ),
          ),
        ],
      ),
    );
  }

  // ───────────────────────────────────────────────────────────────────────────
  // VIEW 2: RECORDING PREVIEW & TRIM STUDIO
  // ───────────────────────────────────────────────────────────────────────────
  Widget _buildPreviewView(
    RecordingSessionState state,
    RecordingNotifier notifier,
  ) {
    final totalSec = _previewDuration.inMilliseconds > 0
        ? _previewDuration.inMilliseconds / 1000.0
        : 1.0;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Audio Preview Playback Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppTheme.surface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    // Play/Pause button
                    GestureDetector(
                      onTap: () {
                        if (_previewPlayer == null) return;
                        if (_isPreviewPlaying) {
                          _previewPlayer!.pause();
                        } else {
                          _previewPlayer!.play();
                        }
                      },
                      child: Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          color: AppTheme.accent,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          _isPreviewPlaying
                              ? Icons.pause_rounded
                              : Icons.play_arrow_rounded,
                          color: Colors.black,
                          size: 30,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _titleController.text.isNotEmpty
                                ? _titleController.text
                                : 'Recorded Audio',
                            style: const TextStyle(
                              color: AppTheme.textPrimary,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${_formatDuration(_previewPosition)} / ${_formatDuration(_previewDuration)}',
                            style: const TextStyle(
                              color: AppTheme.textTertiary,
                              fontSize: 12,
                              fontFeatures: [FontFeature.tabularFigures()],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Scrubber slider
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    trackHeight: 4,
                    thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                    activeTrackColor: AppTheme.accent,
                    inactiveTrackColor: AppTheme.surfaceHighlight,
                    thumbColor: AppTheme.accent,
                  ),
                  child: Slider(
                    min: 0.0,
                    max: totalSec,
                    value: _previewPosition.inMilliseconds / 1000.0 <= totalSec
                        ? _previewPosition.inMilliseconds / 1000.0
                        : 0.0,
                    onChanged: (val) {
                      _previewPlayer?.seek(Duration(milliseconds: (val * 1000).round()));
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // 2. Precision Trim Tool (0.1s accuracy)
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: AppTheme.surface,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: _isTrimming
                    ? AppTheme.accent.withValues(alpha: 0.5)
                    : Colors.white.withValues(alpha: 0.08),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.content_cut_rounded, color: AppTheme.accent, size: 20),
                        SizedBox(width: 8),
                        Text(
                          'Precision Trim (0.1s)',
                          style: TextStyle(
                            color: AppTheme.textPrimary,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    Switch.adaptive(
                      value: _isTrimming,
                      activeTrackColor: AppTheme.accent,
                      onChanged: (v) {
                        setState(() {
                          _isTrimming = v;
                          if (!v) {
                            _trimStartSec = 0.0;
                            _trimEndSec = totalSec;
                            notifier.updateTrimRange(
                              startMs: 0,
                              endMs: (totalSec * 1000).round(),
                            );
                          }
                        });
                      },
                    ),
                  ],
                ),
                if (_isTrimming) ...[
                  const SizedBox(height: 12),
                  const Text(
                    'Drag markers to trim beginning and ending without re-encoding.',
                    style: TextStyle(color: AppTheme.textTertiary, fontSize: 12),
                  ),
                  const SizedBox(height: 16),
                  RangeSlider(
                    min: 0.0,
                    max: totalSec,
                    divisions: (totalSec * 10).round().clamp(1, 1000),
                    values: RangeValues(
                      _trimStartSec.clamp(0.0, totalSec),
                      _trimEndSec.clamp(_trimStartSec, totalSec),
                    ),
                    activeColor: AppTheme.accent,
                    inactiveColor: AppTheme.surfaceHighlight,
                    onChanged: (RangeValues values) {
                      setState(() {
                        _trimStartSec = double.parse(values.start.toStringAsFixed(1));
                        _trimEndSec = double.parse(values.end.toStringAsFixed(1));
                        notifier.updateTrimRange(
                          startMs: (_trimStartSec * 1000).round(),
                          endMs: (_trimEndSec * 1000).round(),
                        );
                      });
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Start: ${_trimStartSec.toStringAsFixed(1)}s',
                        style: const TextStyle(color: AppTheme.accent, fontSize: 12, fontWeight: FontWeight.w600),
                      ),
                      Text(
                        'Trimmed: ${(_trimEndSec - _trimStartSec).toStringAsFixed(1)}s',
                        style: const TextStyle(color: AppTheme.textPrimary, fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'End: ${_trimEndSec.toStringAsFixed(1)}s',
                        style: const TextStyle(color: AppTheme.accent, fontSize: 12, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.play_arrow_rounded, size: 18),
                      label: const Text('Preview Trimmed Region'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppTheme.accent,
                        side: const BorderSide(color: AppTheme.accent),
                      ),
                      onPressed: () {
                        _previewPlayer?.seek(Duration(milliseconds: (_trimStartSec * 1000).round()));
                        _previewPlayer?.play();
                      },
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 20),

          // 3. Metadata & Artwork Editor
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: AppTheme.surface,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'RECORDING METADATA',
                  style: TextStyle(
                    color: AppTheme.textTertiary,
                    fontSize: 11,
                    letterSpacing: 1,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),

                // Artwork Picker Row
                Row(
                  children: [
                    GestureDetector(
                      onTap: _pickArtwork,
                      child: Container(
                        width: 72,
                        height: 72,
                        decoration: BoxDecoration(
                          color: AppTheme.surfaceHighlight,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: AppTheme.accent.withValues(alpha: 0.3)),
                        ),
                        child: _selectedArtworkPath != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(14),
                                child: Image.file(
                                  File(_selectedArtworkPath!),
                                  fit: BoxFit.cover,
                                ),
                              )
                            : const Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.add_photo_alternate_rounded, color: AppTheme.accent, size: 24),
                                  SizedBox(height: 4),
                                  Text('Artwork', style: TextStyle(color: AppTheme.textTertiary, fontSize: 10)),
                                ],
                              ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Cover Artwork',
                            style: TextStyle(color: AppTheme.textPrimary, fontWeight: FontWeight.w600, fontSize: 14),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _selectedArtworkPath != null
                                ? 'Custom image selected'
                                : 'Tap to select cover image from gallery',
                            style: const TextStyle(color: AppTheme.textTertiary, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),

                // Title
                const Text('Title *', style: TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
                const SizedBox(height: 6),
                TextField(
                  controller: _titleController,
                  style: const TextStyle(color: AppTheme.textPrimary),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AppTheme.surfaceHighlight,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                  ),
                ),
                const SizedBox(height: 14),

                // Artist & Album
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Artist', style: TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
                          const SizedBox(height: 6),
                          TextField(
                            controller: _artistController,
                            style: const TextStyle(color: AppTheme.textPrimary),
                            decoration: InputDecoration(
                              hintText: 'Unknown Artist',
                              hintStyle: const TextStyle(color: AppTheme.textTertiary),
                              filled: true,
                              fillColor: AppTheme.surfaceHighlight,
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Album', style: TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
                          const SizedBox(height: 6),
                          TextField(
                            controller: _albumController,
                            style: const TextStyle(color: AppTheme.textPrimary),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: AppTheme.surfaceHighlight,
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // Description
                const Text('Notes / Description', style: TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
                const SizedBox(height: 6),
                TextField(
                  controller: _descController,
                  maxLines: 2,
                  style: const TextStyle(color: AppTheme.textPrimary),
                  decoration: InputDecoration(
                    hintText: 'Optional notes for this recording...',
                    hintStyle: const TextStyle(color: AppTheme.textTertiary),
                    filled: true,
                    fillColor: AppTheme.surfaceHighlight,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // 4. Save & Actions Bar
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton.icon(
              icon: state.isSaving
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black),
                    )
                  : const Icon(Icons.check_circle_rounded),
              label: Text(
                state.isSaving ? 'Processing & Saving...' : 'Save to Library',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.accent,
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              onPressed: state.isSaving
                  ? null
                  : () async {
                      final success = await notifier.saveRecording(
                        title: _titleController.text.trim(),
                        artist: _artistController.text.trim(),
                        album: _albumController.text.trim(),
                        genre: _genreController.text.trim(),
                        description: _descController.text.trim(),
                        artworkPath: _selectedArtworkPath,
                      );

                      if (success && mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            backgroundColor: AppTheme.accent,
                            content: Text(
                              'Recording saved successfully to Library!',
                              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                            ),
                          ),
                        );
                        context.pop();
                      }
                    },
            ),
          ),
          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.share_rounded, size: 18),
                  label: const Text('Share'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppTheme.textPrimary,
                    side: const BorderSide(color: Colors.white24),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  onPressed: () => notifier.shareCurrentRecording(
                    title: _titleController.text.trim(),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.refresh_rounded, size: 18),
                  label: const Text('Retake'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFFF59E0B),
                    side: const BorderSide(color: Color(0xFFF59E0B)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  onPressed: () async {
                    final confirm = await _showRetakeConfirmDialog();
                    if (confirm == true) {
                      await notifier.retakeRecording();
                    }
                  },
                ),
              ),
              const SizedBox(width: 12),
              IconButton(
                tooltip: 'Discard',
                icon: const Icon(Icons.delete_forever_rounded, color: AppTheme.error),
                onPressed: () async {
                  final confirm = await _showDiscardConfirmDialog();
                  if (confirm == true) {
                    await notifier.cancelRecording();
                    if (mounted) context.pop();
                  }
                },
              ),
            ],
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  // ───────────────────────────────────────────────────────────────────────────
  // VIEW 3: PERMISSION DENIED VIEW
  // ───────────────────────────────────────────────────────────────────────────
  Widget _buildPermissionDeniedView(
    RecordingSessionState state,
    RecordingNotifier notifier,
  ) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppTheme.error.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.mic_off_rounded, color: AppTheme.error, size: 48),
            ),
            const SizedBox(height: 24),
            const Text(
              'Microphone Permission Required',
              style: TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              state.errorMessage ??
                  'Pattu Petti needs microphone access to record audio and voice tracks.',
              style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13, height: 1.45),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 28),
            if (state.permissionPermanentlyDenied)
              ElevatedButton.icon(
                icon: const Icon(Icons.settings_rounded),
                label: const Text('Open App Settings'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.accent,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                onPressed: () => openAppSettings(),
              )
            else
              ElevatedButton.icon(
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('Try Again'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.accent,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                onPressed: () => notifier.startRecording(),
              ),
          ],
        ),
      ),
    );
  }

  // ───────────────────────────────────────────────────────────────────────────
  // CONFIRMATION DIALOGS
  // ───────────────────────────────────────────────────────────────────────────
  Future<bool?> _showExitConfirmDialog() {
    return showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.surface,
        title: const Text('Cancel Recording?'),
        content: const Text('Exiting now will discard the current recording.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Keep Recording'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.error),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Discard & Exit'),
          ),
        ],
      ),
    );
  }

  Future<bool?> _showRetakeConfirmDialog() {
    return showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.surface,
        title: const Text('Retake Recording?'),
        content: const Text('This will delete the current recording and start a fresh one.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFF59E0B)),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Retake'),
          ),
        ],
      ),
    );
  }

  Future<bool?> _showDiscardConfirmDialog() {
    return showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.surface,
        title: const Text('Discard Recording?'),
        content: const Text('Are you sure you want to permanently discard this recording?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Keep'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.error),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Discard'),
          ),
        ],
      ),
    );
  }

  String _formatDuration(Duration d) {
    final h = d.inHours;
    final m = d.inMinutes % 60;
    final s = d.inSeconds % 60;
    if (h > 0) {
      return '$h:${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
    }
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// WAVEFORM PAINTER
// ─────────────────────────────────────────────────────────────────────────────
class _WaveformPainter extends CustomPainter {
  _WaveformPainter({
    required this.amplitudes,
    required this.isActive,
    required this.isPaused,
  });

  final List<double> amplitudes;
  final bool isActive;
  final bool isPaused;

  @override
  void paint(Canvas canvas, Size size) {
    final count = 40;
    final barWidth = (size.width - (count - 1) * 3) / count;
    final centerY = size.height / 2;

    final paint = Paint()
      ..style = PaintingStyle.fill
      ..strokeCap = StrokeCap.round;

    final displayAmps = List<double>.filled(count, 0.08);

    if (amplitudes.isNotEmpty) {
      final startIndex = amplitudes.length > count ? amplitudes.length - count : 0;
      final recent = amplitudes.sublist(startIndex);
      for (int i = 0; i < recent.length; i++) {
        final targetIdx = count - recent.length + i;
        displayAmps[targetIdx] = recent[i];
      }
    }

    for (int i = 0; i < count; i++) {
      final amp = displayAmps[i];
      final barHeight = (amp * size.height * 0.9).clamp(4.0, size.height);
      final left = i * (barWidth + 3);
      final top = centerY - barHeight / 2;

      if (isActive) {
        paint.color = AppTheme.accent;
      } else if (isPaused) {
        paint.color = const Color(0xFFF59E0B);
      } else {
        paint.color = AppTheme.textTertiary.withValues(alpha: 0.3);
      }

      final rrect = RRect.fromRectAndRadius(
        Rect.fromLTWH(left, top, barWidth, barHeight),
        const Radius.circular(2),
      );
      canvas.drawRRect(rrect, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _WaveformPainter oldDelegate) {
    return oldDelegate.amplitudes != amplitudes ||
        oldDelegate.isActive != isActive ||
        oldDelegate.isPaused != isPaused;
  }
}
