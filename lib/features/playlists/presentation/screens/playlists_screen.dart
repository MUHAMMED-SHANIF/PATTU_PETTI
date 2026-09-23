import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/theme/app_theme.dart';
import '../../data/services/playlist_share_service.dart';
import '../../domain/entities/playlist_entity.dart';
import '../providers/playlist_providers.dart';
import '../widgets/playlist_artwork_generator.dart';

class PlaylistsScreen extends ConsumerStatefulWidget {
  const PlaylistsScreen({super.key});

  @override
  ConsumerState<PlaylistsScreen> createState() => _PlaylistsScreenState();
}

class _PlaylistsScreenState extends ConsumerState<PlaylistsScreen> {
  String _searchQuery = '';
  bool _isSearching = false;
  String _selectedTab = 'All'; // 'All' | 'Liked' | 'Smart'

  @override
  Widget build(BuildContext context) {
    final playlistsAsync = ref.watch(playlistsStreamProvider);
    final likedPlaylistsAsync = ref.watch(likedPlaylistsProvider);

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: AppTheme.surface,
        elevation: 0,
        title: _isSearching
            ? TextField(
                autofocus: true,
                style: const TextStyle(color: AppTheme.textPrimary, fontSize: 16),
                decoration: const InputDecoration(
                  hintText: 'Search playlists...',
                  hintStyle: TextStyle(color: AppTheme.textTertiary),
                  border: InputBorder.none,
                ),
                onChanged: (val) => setState(() => _searchQuery = val.trim()),
              )
            : const Text(
                'Playlists',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
              ),
        actions: [
          IconButton(
            icon: Icon(
              _isSearching ? Icons.close_rounded : Icons.search_rounded,
              color: AppTheme.textSecondary,
            ),
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
                if (!_isSearching) _searchQuery = '';
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.add_rounded, color: AppTheme.accent, size: 28),
            onPressed: () => _showCreatePlaylistDialog(context),
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          // Filter Chips
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: Row(
                children: ['All', 'Liked', 'Smart'].map((tab) {
                  final isSelected = _selectedTab == tab;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(tab == 'Smart' ? 'Smart Playlists' : tab),
                      selected: isSelected,
                      onSelected: (_) => setState(() => _selectedTab = tab),
                      backgroundColor: AppTheme.surfaceHighlight,
                      selectedColor: AppTheme.accent.withValues(alpha: 0.2),
                      checkmarkColor: AppTheme.accent,
                      labelStyle: TextStyle(
                        fontSize: 12,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        color: isSelected ? AppTheme.accent : AppTheme.textSecondary,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(
                          color: isSelected ? AppTheme.accent : Colors.transparent,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

          // Smart Playlists Section
          if (_selectedTab == 'All' || _selectedTab == 'Smart') ...[
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Row(
                  children: [
                    const Icon(Icons.auto_awesome_rounded, size: 18, color: AppTheme.accent),
                    const SizedBox(width: 8),
                    const Text(
                      'SMART PLAYLISTS',
                      style: TextStyle(
                        fontSize: 11,
                        letterSpacing: 1.2,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 140,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  itemCount: SmartPlaylistType.values.length,
                  itemBuilder: (ctx, i) {
                    final type = SmartPlaylistType.values[i];
                    return _buildSmartPlaylistCard(type);
                  },
                ),
              ),
            ),
          ],

          // User Playlists Section Header
          if (_selectedTab != 'Smart') ...[
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _selectedTab == 'Liked' ? 'LIKED PLAYLISTS' : 'YOUR PLAYLISTS',
                      style: const TextStyle(
                        fontSize: 11,
                        letterSpacing: 1.2,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () => _showCreatePlaylistDialog(context),
                      icon: const Icon(Icons.add_rounded, size: 16, color: AppTheme.accent),
                      label: const Text(
                        'New Playlist',
                        style: TextStyle(color: AppTheme.accent, fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // User Playlists List/Grid
            (_selectedTab == 'Liked' ? likedPlaylistsAsync : playlistsAsync).when(
              data: (playlists) {
                var filtered = playlists;
                if (_searchQuery.isNotEmpty) {
                  final q = _searchQuery.toLowerCase();
                  filtered = filtered.where((p) {
                    return p.name.toLowerCase().contains(q) ||
                        (p.description?.toLowerCase().contains(q) ?? false);
                  }).toList();
                }

                if (filtered.isEmpty) {
                  return SliverFillRemaining(
                    hasScrollBody: false,
                    child: _buildEmptyState(context, isLikedTab: _selectedTab == 'Liked'),
                  );
                }

                return SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (ctx, index) {
                        final pl = filtered[index];
                        return _buildPlaylistItemTile(pl);
                      },
                      childCount: filtered.length,
                    ),
                  ),
                );
              },
              loading: () => const SliverFillRemaining(
                child: Center(child: CircularProgressIndicator(color: AppTheme.accent)),
              ),
              error: (err, _) => SliverFillRemaining(
                child: Center(
                  child: Text('Error: $err', style: const TextStyle(color: Colors.redAccent)),
                ),
              ),
            ),
          ],

          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppTheme.accent,
        foregroundColor: Colors.black,
        elevation: 4,
        onPressed: () => _showCreatePlaylistDialog(context),
        child: const Icon(Icons.add_rounded, size: 28),
      ),
    );
  }

  // ─── Smart Playlist Card ──────────────────────────────────────────────────
  Widget _buildSmartPlaylistCard(SmartPlaylistType type) {
    final countAsync = ref.watch(smartPlaylistCountProvider(type));

    return GestureDetector(
      onTap: () {
        context.push('/smart-playlist/${type.name}');
      },
      child: Container(
        width: 140,
        margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: type.gradientColors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: type.gradientColors[0].withValues(alpha: 0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(type.icon, color: Colors.white, size: 28),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  type.displayName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 2),
                countAsync.when(
                  data: (count) => Text(
                    '$count tracks',
                    style: const TextStyle(color: Colors.white70, fontSize: 11),
                  ),
                  loading: () => const Text('...', style: TextStyle(color: Colors.white70, fontSize: 11)),
                  error: (_, __) => const Text('0 tracks', style: TextStyle(color: Colors.white70, fontSize: 11)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ─── User Playlist Tile ───────────────────────────────────────────────────
  Widget _buildPlaylistItemTile(PlaylistEntity playlist) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(14),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
        leading: Hero(
          tag: 'playlist_art_${playlist.id}',
          child: PlaylistArtworkWidget(
            artworkPath: playlist.artworkPath,
            size: 52,
            borderRadius: 10,
          ),
        ),
        title: Text(
          playlist.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: AppTheme.textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
        subtitle: Row(
          children: [
            Text(
              '${playlist.formattedItemCount} • ${playlist.formattedDuration}',
              style: const TextStyle(fontSize: 12, color: AppTheme.textTertiary),
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(
                playlist.isLiked ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                color: playlist.isLiked ? Colors.redAccent : AppTheme.textTertiary,
                size: 20,
              ),
              onPressed: () {
                ref.read(playlistControllerProvider).toggleLike(playlist.id, !playlist.isLiked);
              },
            ),
            PopupMenuButton<String>(
              color: AppTheme.surface,
              icon: const Icon(Icons.more_vert_rounded, color: AppTheme.textTertiary, size: 20),
              onSelected: (action) => _handleMenuAction(action, playlist),
              itemBuilder: (_) => [
                const PopupMenuItem(value: 'duplicate', child: Text('Duplicate')),
                const PopupMenuItem(value: 'share', child: Text('Share')),
                const PopupMenuDivider(),
                const PopupMenuItem(
                  value: 'delete',
                  child: Text('Delete', style: TextStyle(color: Colors.redAccent)),
                ),
              ],
            ),
          ],
        ),
        onTap: () {
          context.push('/playlist/${playlist.id}');
        },
      ),
    );
  }

  // ─── Empty State ──────────────────────────────────────────────────────────
  Widget _buildEmptyState(BuildContext context, {required bool isLikedTab}) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isLikedTab ? Icons.favorite_border_rounded : Icons.queue_music_rounded,
              size: 56,
              color: AppTheme.textTertiary,
            ),
            const SizedBox(height: 16),
            Text(
              isLikedTab ? 'No Liked Playlists' : 'No Playlists Yet',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              isLikedTab
                  ? 'Tap the heart icon on any playlist to save it here.'
                  : 'Create custom playlists to organize your songs, clips, recordings and merged tracks.',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 13, color: AppTheme.textTertiary),
            ),
            if (!isLikedTab) ...[
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () => _showCreatePlaylistDialog(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.accent,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                icon: const Icon(Icons.add_rounded),
                label: const Text('Create Playlist', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // ─── Actions & Dialogs ────────────────────────────────────────────────────
  void _handleMenuAction(String action, PlaylistEntity playlist) {
    switch (action) {
      case 'duplicate':
        ref.read(playlistControllerProvider).duplicate(playlist.id);
        break;
      case 'share':
        PlaylistShareService.sharePlaylistText(playlist: playlist, items: []);
        break;
      case 'delete':
        _confirmDelete(playlist);
        break;
    }
  }

  Future<void> _confirmDelete(PlaylistEntity playlist) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dlgCtx) => AlertDialog(
        backgroundColor: AppTheme.surface,
        title: const Text('Delete Playlist?', style: TextStyle(color: AppTheme.textPrimary)),
        content: const Text(
          'Deleting this playlist will remove the playlist and its item references. Your original audio files will not be deleted.',
          style: TextStyle(color: AppTheme.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dlgCtx).pop(false),
            child: const Text('Cancel', style: TextStyle(color: AppTheme.textSecondary)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent, foregroundColor: Colors.white),
            onPressed: () => Navigator.of(dlgCtx).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      await ref.read(playlistControllerProvider).delete(playlist.id);
    }
  }

  Future<void> _showCreatePlaylistDialog(BuildContext context) async {
    final nameController = TextEditingController();
    final descController = TextEditingController();
    String? pickedArtworkPath;

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetCtx) => StatefulBuilder(
        builder: (ctx, setSheetState) => Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: const BoxDecoration(
              color: AppTheme.surface,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'New Playlist',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close_rounded, color: AppTheme.textSecondary),
                      onPressed: () => Navigator.of(sheetCtx).pop(),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Artwork picker preview
                Center(
                  child: GestureDetector(
                    onTap: () async {
                      final picker = ImagePicker();
                      final picked = await picker.pickImage(source: ImageSource.gallery);
                      if (picked != null) {
                        setSheetState(() => pickedArtworkPath = picked.path);
                      }
                    },
                    child: Stack(
                      children: [
                        PlaylistArtworkWidget(
                          artworkPath: pickedArtworkPath,
                          size: 90,
                          borderRadius: 16,
                        ),
                        Positioned(
                          bottom: 4,
                          right: 4,
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: const BoxDecoration(
                              color: Colors.black54,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.camera_alt_rounded, size: 16, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                TextField(
                  controller: nameController,
                  autofocus: true,
                  style: const TextStyle(color: AppTheme.textPrimary),
                  decoration: InputDecoration(
                    labelText: 'Playlist Name *',
                    labelStyle: const TextStyle(color: AppTheme.textSecondary),
                    filled: true,
                    fillColor: AppTheme.surfaceHighlight,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
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
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.accent,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    onPressed: () async {
                      final name = nameController.text.trim();
                      if (name.isEmpty) {
                        ScaffoldMessenger.of(ctx).showSnackBar(
                          const SnackBar(content: Text('Please enter a playlist name')),
                        );
                        return;
                      }

                      Navigator.of(sheetCtx).pop();

                      final controller = ref.read(playlistControllerProvider);
                      final newId = await controller.createPlaylist(
                        name: name,
                        description: descController.text.trim().isNotEmpty
                            ? descController.text.trim()
                            : null,
                        artworkPath: pickedArtworkPath,
                      );

                      if (context.mounted) {
                        context.push('/playlist/$newId');
                      }
                    },
                    child: const Text(
                      'Create Playlist',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
