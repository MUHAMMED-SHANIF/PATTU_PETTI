import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../providers/player_provider.dart';


/// Persistent mini player shown above the bottom navigation bar.
/// Tapping it opens the full player screen.
class MiniPlayerWidget extends ConsumerWidget {
  const MiniPlayerWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playerState = ref.watch(playerNotifierProvider);

    if (!playerState.hasItem) return const SizedBox.shrink();

    final item = playerState.currentItem!;

    return GestureDetector(
      onTap: () => context.push('/player/${item.id}'),
      child: Container(
        height: 68,
        decoration: const BoxDecoration(
          color: AppTheme.surfaceElevated,
          border: Border(
            top: BorderSide(color: AppTheme.divider, width: 0.5),
          ),
        ),
        child: Column(
          children: [
            // Progress bar
            LinearProgressIndicator(
              value: playerState.progress,
              backgroundColor: AppTheme.progressBackground,
              valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.accent),
              minHeight: 2,
            ),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  children: [
                    // Artwork
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: AppTheme.surfaceHighlight,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: item.artworkPath != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: Image.file(
                                File(item.artworkPath!),
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => const _DefaultArtwork(),
                              ),
                            )
                          : const _DefaultArtwork(),
                    ),

                    const SizedBox(width: 12),

                    // Title and artist
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.title,
                            style: const TextStyle(
                              color: AppTheme.textPrimary,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            item.displayArtist,
                            style: const TextStyle(
                              color: AppTheme.textTertiary,
                              fontSize: 11,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),

                    // Controls
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.skip_previous_rounded),
                          color: AppTheme.textSecondary,
                          iconSize: 28,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
                          onPressed: () => ref.read(playerNotifierProvider.notifier).skipPrevious(),
                        ),
                        GestureDetector(
                          onTap: () => ref.read(playerNotifierProvider.notifier).togglePlayPause(),
                          child: Container(
                            width: 38,
                            height: 38,
                            decoration: const BoxDecoration(
                              color: AppTheme.accent,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              playerState.isPlaying
                                  ? Icons.pause_rounded
                                  : Icons.play_arrow_rounded,
                              color: Colors.black,
                              size: 22,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.skip_next_rounded),
                          color: AppTheme.textSecondary,
                          iconSize: 28,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
                          onPressed: () => ref.read(playerNotifierProvider.notifier).skipNext(),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DefaultArtwork extends StatelessWidget {
  const _DefaultArtwork();

  @override
  Widget build(BuildContext context) {
    return const Icon(
      Icons.music_note_rounded,
      color: AppTheme.textTertiary,
      size: 22,
    );
  }
}

