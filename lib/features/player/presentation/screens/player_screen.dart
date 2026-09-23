import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../providers/player_provider.dart';

/// Full screen player with interactive scrubber line, timestamps,
/// album artwork, queue controls, and rich dark aesthetics.
class PlayerScreen extends ConsumerStatefulWidget {
  const PlayerScreen({super.key, required this.itemId});

  final String itemId;

  @override
  ConsumerState<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends ConsumerState<PlayerScreen> {
  double? _dragValue;

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(playerNotifierProvider);
    final notifier = ref.read(playerNotifierProvider.notifier);
    final item = state.currentItem;

    final duration = state.duration ?? Duration.zero;
    final position = state.position;

    final totalDurationMs = duration.inMilliseconds.toDouble();
    final currentPosMs = position.inMilliseconds.toDouble().clamp(0.0, totalDurationMs > 0 ? totalDurationMs : 1.0);

    // If currently dragging, use drag value for display; otherwise use real position
    final sliderValue = _dragValue != null
        ? _dragValue!.clamp(0.0, totalDurationMs > 0 ? totalDurationMs : 1.0)
        : currentPosMs;

    final displayPositionMs = _dragValue != null ? _dragValue!.round() : position.inMilliseconds;
    final displayPosition = Duration(milliseconds: displayPositionMs);

    return Scaffold(
      backgroundColor: AppTheme.playerBackground,
      body: SafeArea(
        child: Column(
          children: [
            // ─── Header ──────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.keyboard_arrow_down_rounded,
                        color: AppTheme.textPrimary, size: 34),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  Column(
                    children: [
                      Text(
                        'PLAYING FROM YOUR LIBRARY',
                        style: TextStyle(
                          color: AppTheme.textTertiary,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        item?.album ?? 'Pattu Petti Audio',
                        style: const TextStyle(
                          color: AppTheme.textPrimary,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.more_vert_rounded,
                        color: AppTheme.textSecondary),
                    onPressed: () {},
                  ),
                ],
              ),
            ),

            const Spacer(),

            // ─── Album Artwork ───────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Container(
                width: 320,
                height: 320,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppTheme.radiusLG),
                  color: AppTheme.surfaceHighlight,
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.accent.withValues(alpha: 0.2),
                      blurRadius: 36,
                      spreadRadius: -4,
                      offset: const Offset(0, 16),
                    ),
                  ],
                ),
                child: item?.artworkPath != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(AppTheme.radiusLG),
                        child: Image.file(
                          File(item!.artworkPath!),
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => const _DefaultArtworkBig(),
                        ),
                      )
                    : const _DefaultArtworkBig(),
              ),
            ),

            const Spacer(),

            // ─── Title, Artist & Like Button ──────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item?.title ?? 'Not Playing',
                          style: const TextStyle(
                            color: AppTheme.textPrimary,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.3,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item?.displayArtist ?? 'Select a song to play',
                          style: const TextStyle(
                            color: AppTheme.textTertiary,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      (item?.isLiked ?? false)
                          ? Icons.favorite_rounded
                          : Icons.favorite_border_rounded,
                      color: (item?.isLiked ?? false)
                          ? AppTheme.accent
                          : AppTheme.textTertiary,
                      size: 28,
                    ),
                    onPressed: () => notifier.toggleLike(),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ─── Interactive Scrubber Line & Timestamps ───────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      trackHeight: 4.0,
                      activeTrackColor: AppTheme.accent,
                      inactiveTrackColor: Colors.white.withValues(alpha: 0.18),
                      thumbColor: Colors.white,
                      thumbShape: const RoundSliderThumbShape(
                        enabledThumbRadius: 7.0,
                        pressedElevation: 6.0,
                        elevation: 3.0,
                      ),
                      overlayColor: AppTheme.accent.withValues(alpha: 0.25),
                      overlayShape: const RoundSliderOverlayShape(overlayRadius: 16.0),
                      trackShape: const RoundedRectSliderTrackShape(),
                    ),
                    child: Slider(
                      value: sliderValue,
                      min: 0.0,
                      max: totalDurationMs > 0 ? totalDurationMs : 1.0,
                      onChanged: totalDurationMs > 0
                          ? (value) {
                              setState(() {
                                _dragValue = value;
                              });
                            }
                          : null,
                      onChangeEnd: totalDurationMs > 0
                          ? (value) {
                              notifier.seekTo(Duration(milliseconds: value.round()));
                              setState(() {
                                _dragValue = null;
                              });
                            }
                          : null,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _formatDuration(displayPosition),
                          style: const TextStyle(
                            color: AppTheme.textSecondary,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            fontFeatures: [],
                          ),
                        ),
                        Text(
                          totalDurationMs > 0
                              ? _formatDuration(duration)
                              : '--:--',
                          style: const TextStyle(
                            color: AppTheme.textSecondary,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // ─── Playback Controls ────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Shuffle
                  IconButton(
                    icon: Icon(
                      Icons.shuffle_rounded,
                      color: state.shuffleEnabled
                          ? AppTheme.accent
                          : AppTheme.textTertiary,
                    ),
                    iconSize: 26,
                    tooltip: 'Shuffle',
                    onPressed: () => notifier.toggleShuffle(),
                  ),

                  // Recent / Previous button
                  IconButton(
                    icon: const Icon(Icons.skip_previous_rounded),
                    iconSize: 42,
                    color: AppTheme.textPrimary,
                    tooltip: 'Previous track',
                    onPressed: () => notifier.skipPrevious(),
                  ),

                  // Big Play / Pause button
                  GestureDetector(
                    onTap: () => notifier.togglePlayPause(),
                    child: Container(
                      width: 68,
                      height: 68,
                      decoration: BoxDecoration(
                        color: AppTheme.accent,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.accent.withValues(alpha: 0.4),
                            blurRadius: 18,
                            spreadRadius: 1,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Icon(
                        state.isPlaying
                            ? Icons.pause_rounded
                            : Icons.play_arrow_rounded,
                        color: Colors.black,
                        size: 38,
                      ),
                    ),
                  ),

                  // Next button
                  IconButton(
                    icon: const Icon(Icons.skip_next_rounded),
                    iconSize: 42,
                    color: AppTheme.textPrimary,
                    tooltip: 'Next track',
                    onPressed: () => notifier.skipNext(),
                  ),

                  // Repeat
                  IconButton(
                    icon: Icon(
                      state.repeatMode == AppRepeatMode.repeatOne
                          ? Icons.repeat_one_rounded
                          : Icons.repeat_rounded,
                      color: state.repeatMode != AppRepeatMode.off
                          ? AppTheme.accent
                          : AppTheme.textTertiary,
                    ),
                    iconSize: 26,
                    tooltip: 'Repeat',
                    onPressed: () {
                      final next = switch (state.repeatMode) {
                        AppRepeatMode.off => AppRepeatMode.repeatAll,
                        AppRepeatMode.repeatAll => AppRepeatMode.repeatOne,
                        AppRepeatMode.repeatOne => AppRepeatMode.off,
                        AppRepeatMode.repeatClip => AppRepeatMode.off,
                      };
                      notifier.setRepeatMode(next);
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),
          ],
        ),
      ),
    );
  }

  String _formatDuration(Duration d) {
    final minutes = d.inMinutes;
    final seconds = d.inSeconds % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }
}

class _DefaultArtworkBig extends StatelessWidget {
  const _DefaultArtworkBig();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.surfaceHighlight,
      child: Center(
        child: Container(
          width: 90,
          height: 90,
          decoration: BoxDecoration(
            color: AppTheme.accent.withValues(alpha: 0.15),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.music_note_rounded,
            color: AppTheme.accent,
            size: 52,
          ),
        ),
      ),
    );
  }
}
