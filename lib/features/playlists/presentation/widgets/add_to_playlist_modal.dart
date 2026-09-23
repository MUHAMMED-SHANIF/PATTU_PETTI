import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../providers/playlist_providers.dart';
import 'playlist_artwork_generator.dart';

class AddToPlaylistModal extends ConsumerWidget {
  const AddToPlaylistModal({
    super.key,
    required this.audioItemIds,
    this.itemTitle,
  });

  final List<String> audioItemIds;
  final String? itemTitle;

  static Future<void> show(
    BuildContext context, {
    required List<String> audioItemIds,
    String? itemTitle,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => AddToPlaylistModal(
        audioItemIds: audioItemIds,
        itemTitle: itemTitle,
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playlistsAsync = ref.watch(playlistsStreamProvider);

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.75,
      ),
      decoration: const BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 12, bottom: 8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 16, 12),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Add to Playlist',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        itemTitle != null
                            ? 'Adding "$itemTitle"'
                            : 'Adding ${audioItemIds.length} item(s)',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppTheme.textTertiary,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded, color: AppTheme.textSecondary),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),

          const Divider(height: 1, color: Colors.white12),

          // "New Playlist" row
          ListTile(
            leading: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppTheme.accent.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.add_rounded, color: AppTheme.accent, size: 28),
            ),
            title: const Text(
              'New Playlist',
              style: TextStyle(
                color: AppTheme.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: const Text(
              'Create a new playlist and add audio',
              style: TextStyle(fontSize: 12, color: AppTheme.textTertiary),
            ),
            onTap: () async {
              Navigator.of(context).pop();
              await _showCreatePlaylistDialog(context, ref);
            },
          ),

          const Divider(height: 1, color: Colors.white12),

          // List of existing playlists
          Flexible(
            child: playlistsAsync.when(
              data: (playlists) {
                if (playlists.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.all(32),
                    child: Center(
                      child: Text(
                        'No playlists yet. Tap "New Playlist" above to create one.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: AppTheme.textSecondary),
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: playlists.length,
                  itemBuilder: (ctx, i) {
                    final pl = playlists[i];
                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                      leading: PlaylistArtworkWidget(
                        artworkPath: pl.artworkPath,
                        size: 48,
                        borderRadius: 8,
                      ),
                      title: Text(
                        pl.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: AppTheme.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      subtitle: Text(
                        '${pl.formattedItemCount} • ${pl.formattedDuration}',
                        style: const TextStyle(fontSize: 12, color: AppTheme.textTertiary),
                      ),
                      onTap: () async {
                        final controller = ref.read(playlistControllerProvider);
                        final added = await controller.addItems(pl.id, audioItemIds);
                        if (context.mounted) {
                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                added > 0
                                    ? 'Added $added item(s) to "${pl.name}"'
                                    : 'Items already present in "${pl.name}"',
                              ),
                              backgroundColor: AppTheme.surfaceHighlight,
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        }
                      },
                    );
                  },
                );
              },
              loading: () => const Center(
                child: Padding(
                  padding: EdgeInsets.all(32),
                  child: CircularProgressIndicator(color: AppTheme.accent),
                ),
              ),
              error: (err, _) => Padding(
                padding: const EdgeInsets.all(24),
                child: Center(
                  child: Text('Error: $err', style: const TextStyle(color: Colors.redAccent)),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Future<void> _showCreatePlaylistDialog(BuildContext context, WidgetRef ref) async {
    final textController = TextEditingController(text: 'New Playlist');
    final descController = TextEditingController();

    await showDialog(
      context: context,
      builder: (dlgCtx) => AlertDialog(
        backgroundColor: AppTheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Create Playlist', style: TextStyle(color: AppTheme.textPrimary)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: textController,
              autofocus: true,
              style: const TextStyle(color: AppTheme.textPrimary),
              decoration: InputDecoration(
                labelText: 'Playlist Name *',
                labelStyle: const TextStyle(color: AppTheme.textSecondary),
                filled: true,
                fillColor: AppTheme.surfaceHighlight,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: descController,
              maxLines: 2,
              style: const TextStyle(color: AppTheme.textPrimary),
              decoration: InputDecoration(
                labelText: 'Description (optional)',
                labelStyle: const TextStyle(color: AppTheme.textSecondary),
                filled: true,
                fillColor: AppTheme.surfaceHighlight,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dlgCtx).pop(),
            child: const Text('Cancel', style: TextStyle(color: AppTheme.textSecondary)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.accent,
              foregroundColor: Colors.black,
            ),
            onPressed: () async {
              final name = textController.text.trim();
              if (name.isEmpty) return;
              Navigator.of(dlgCtx).pop();

              final controller = ref.read(playlistControllerProvider);
              await controller.createPlaylist(
                name: name,
                description: descController.text.trim().isNotEmpty
                    ? descController.text.trim()
                    : null,
                initialItemIds: audioItemIds,
              );

              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Created playlist "$name" with ${audioItemIds.length} item(s)'),
                    backgroundColor: AppTheme.surfaceHighlight,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
            },
            child: const Text('Create & Add', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
