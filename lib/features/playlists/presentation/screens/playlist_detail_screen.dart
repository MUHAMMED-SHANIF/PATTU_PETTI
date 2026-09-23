import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../domain/entities/audio_item_entity.dart';
import '../../../player/presentation/providers/player_provider.dart';
import '../../data/services/playlist_share_service.dart';
import '../../domain/entities/playlist_entity.dart';
import '../providers/playlist_providers.dart';
import '../widgets/add_items_to_playlist_sheet.dart';
import '../widgets/add_to_playlist_modal.dart';
import '../widgets/playlist_artwork_generator.dart';

enum PlaylistSortOption {
  custom,
  nameAsc,
  nameDesc,
  artist,
  album,
  duration,
  recentlyAdded;

  String get label => switch (this) {
        PlaylistSortOption.custom => 'Custom Order',
        PlaylistSortOption.nameAsc => 'Name (A-Z)',
        PlaylistSortOption.nameDesc => 'Name (Z-A)',
        PlaylistSortOption.artist => 'Artist',
        PlaylistSortOption.album => 'Album',
        PlaylistSortOption.duration => 'Duration',
        PlaylistSortOption.recentlyAdded => 'Recently Added',
      };
}

class PlaylistDetailScreen extends ConsumerStatefulWidget {
  const PlaylistDetailScreen({
    super.key,
    this.playlistId,
    this.smartType,
  }) : assert(playlistId != null || smartType != null);

  final String? playlistId;
  final SmartPlaylistType? smartType;

  bool get isSmart => smartType != null;

  @override
  ConsumerState<PlaylistDetailScreen> createState() => _PlaylistDetailScreenState();
}

class _PlaylistDetailScreenState extends ConsumerState<PlaylistDetailScreen> {
  String _searchQuery = '';
  bool _isSearchOpen = false;
  PlaylistSortOption _sortOption = PlaylistSortOption.custom;

  @override
  Widget build(BuildContext context) {
    if (widget.isSmart) {
      return _buildSmartPlaylistScreen();
    }
    return _buildCustomPlaylistScreen();
  }

  // ─── Custom Playlist Screen ───────────────────────────────────────────────
  Widget _buildCustomPlaylistScreen() {
    final playlistId = widget.playlistId!;
    final playlistAsync = ref.watch(singlePlaylistProvider(playlistId));
    final itemsAsync = ref.watch(playlistItemsStreamProvider(playlistId));

    return playlistAsync.when(
      data: (playlist) {
        if (playlist == null) {
          return Scaffold(
            backgroundColor: AppTheme.background,
            appBar: AppBar(title: const Text('Playlist')),
            body: const Center(
              child: Text('Playlist not found', style: TextStyle(color: AppTheme.textSecondary)),
            ),
          );
        }

        return itemsAsync.when(
          data: (items) {
            final rawAudioItems = items.map((e) => e.audioItem).toList();
            final itemArtworks = rawAudioItems
                .map((e) => e.artworkPath)
                .whereType<String>()
                .toList();

            final processedItems = _filterAndSortItems(items);

            return Scaffold(
              backgroundColor: AppTheme.background,
              body: CustomScrollView(
                slivers: [
                  _buildSliverAppBar(
                    playlist: playlist,
                    itemArtworks: itemArtworks,
                    rawAudioList: rawAudioItems,
                    totalDurationMs: rawAudioItems.fold<int>(
                      0,
                      (acc, it) => acc + (it.durationMs ?? 0),
                    ),
                    itemCount: items.length,
                  ),
                  if (_isSearchOpen)
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                        child: TextField(
                          autofocus: true,
                          style: const TextStyle(color: AppTheme.textPrimary, fontSize: 14),
                          onChanged: (val) => setState(() => _searchQuery = val.trim()),
                          decoration: InputDecoration(
                            hintText: 'Search tracks in playlist...',
                            hintStyle: const TextStyle(color: AppTheme.textTertiary),
                            prefixIcon: const Icon(Icons.search_rounded, color: AppTheme.textTertiary, size: 20),
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.close_rounded, size: 18, color: AppTheme.textTertiary),
                              onPressed: () => setState(() {
                                _isSearchOpen = false;
                                _searchQuery = '';
                              }),
                            ),
                            filled: true,
                            fillColor: AppTheme.surfaceHighlight,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                    ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Row(
                        children: [
                          Text(
                            '${processedItems.length} track(s)',
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.textSecondary,
                            ),
                          ),
                          const Spacer(),
                          PopupMenuButton<PlaylistSortOption>(
                            initialValue: _sortOption,
                            color: AppTheme.surface,
                            icon: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.sort_rounded, size: 18, color: AppTheme.accent),
                                const SizedBox(width: 4),
                                Text(
                                  _sortOption.label,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: AppTheme.accent,
                                  ),
                                ),
                              ],
                            ),
                            onSelected: (opt) => setState(() => _sortOption = opt),
                            itemBuilder: (_) => PlaylistSortOption.values.map((opt) {
                              return PopupMenuItem(
                                value: opt,
                                child: Text(
                                  opt.label,
                                  style: TextStyle(
                                    color: opt == _sortOption ? AppTheme.accent : AppTheme.textPrimary,
                                    fontWeight: opt == _sortOption ? FontWeight.bold : FontWeight.normal,
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                          IconButton(
                            icon: Icon(
                              _isSearchOpen ? Icons.search_off_rounded : Icons.search_rounded,
                              color: _isSearchOpen ? AppTheme.accent : AppTheme.textSecondary,
                              size: 20,
                            ),
                            onPressed: () => setState(() => _isSearchOpen = !_isSearchOpen),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (items.isEmpty)
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: _buildEmptyState(playlistId),
                    )
                  else if (processedItems.isEmpty)
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(
                        child: Text(
                          'No tracks match "$_searchQuery"',
                          style: const TextStyle(color: AppTheme.textSecondary),
                        ),
                      ),
                    )
                  else if (_sortOption == PlaylistSortOption.custom && _searchQuery.isEmpty)
                    SliverReorderableList(
                      itemCount: processedItems.length,
                      onReorderItem: (oldIndex, newIndex) {
                        final list = List<PlaylistItemEntity>.from(processedItems);
                        final item = list.removeAt(oldIndex);
                        list.insert(newIndex, item);
                        final orderedIds = list.map((e) => e.audioItemId).toList();
                        ref.read(playlistControllerProvider).reorder(playlistId, orderedIds);
                      },
                      itemBuilder: (ctx, index) {
                        final plItem = processedItems[index];
                        return ReorderableDelayedDragStartListener(
                          key: ValueKey(plItem.id),
                          index: index,
                          child: _buildTrackTile(
                            playlistItem: plItem,
                            audioItem: plItem.audioItem,
                            index: index,
                            playlistId: playlistId,
                            allPlaylistItems: processedItems.map((e) => e.audioItem).toList(),
                            showDragHandle: true,
                          ),
                        );
                      },
                    )
                  else
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (ctx, index) {
                          final plItem = processedItems[index];
                          return _buildTrackTile(
                            key: ValueKey(plItem.id),
                            playlistItem: plItem,
                            audioItem: plItem.audioItem,
                            index: index,
                            playlistId: playlistId,
                            allPlaylistItems: processedItems.map((e) => e.audioItem).toList(),
                            showDragHandle: false,
                          );
                        },
                        childCount: processedItems.length,
                      ),
                    ),
                  const SliverToBoxAdapter(child: SizedBox(height: 100)),
                ],
              ),
              floatingActionButton: items.isNotEmpty
                  ? FloatingActionButton.extended(
                      backgroundColor: AppTheme.accent,
                      foregroundColor: Colors.black,
                      icon: const Icon(Icons.add_rounded),
                      label: const Text('Add Audio', style: TextStyle(fontWeight: FontWeight.bold)),
                      onPressed: () => _openAddItemsSheet(playlistId, items.map((e) => e.audioItemId).toSet()),
                    )
                  : null,
            );
          },
          loading: () => const Scaffold(
            backgroundColor: AppTheme.background,
            body: Center(child: CircularProgressIndicator(color: AppTheme.accent)),
          ),
          error: (err, _) => Scaffold(
            backgroundColor: AppTheme.background,
            body: Center(child: Text('Error loading tracks: $err', style: const TextStyle(color: Colors.redAccent))),
          ),
        );
      },
      loading: () => const Scaffold(
        backgroundColor: AppTheme.background,
        body: Center(child: CircularProgressIndicator(color: AppTheme.accent)),
      ),
      error: (err, _) => Scaffold(
        backgroundColor: AppTheme.background,
        body: Center(child: Text('Error loading playlist: $err', style: const TextStyle(color: Colors.redAccent))),
      ),
    );
  }

  // ─── Smart Playlist Screen ────────────────────────────────────────────────
  Widget _buildSmartPlaylistScreen() {
    final type = widget.smartType!;
    final itemsAsync = ref.watch(smartPlaylistItemsStreamProvider(type));

    return itemsAsync.when(
      data: (items) {
        var processed = items.where((it) {
          if (_searchQuery.isEmpty) return true;
          final q = _searchQuery.toLowerCase();
          return it.title.toLowerCase().contains(q) ||
              (it.artist?.toLowerCase().contains(q) ?? false) ||
              (it.album?.toLowerCase().contains(q) ?? false);
        }).toList();

        final totalDurationMs = items.fold<int>(0, (acc, it) => acc + (it.durationMs ?? 0));

        return Scaffold(
          backgroundColor: AppTheme.background,
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 260,
                pinned: true,
                backgroundColor: AppTheme.surface,
                flexibleSpace: FlexibleSpaceBar(
                  titlePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  title: Text(
                    type.displayName,
                    style: const TextStyle(
                      color: AppTheme.textPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  background: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          type.gradientColors[0].withValues(alpha: 0.8),
                          type.gradientColors[1].withValues(alpha: 0.9),
                          AppTheme.background,
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 30),
                          Icon(type.icon, size: 64, color: Colors.white),
                          const SizedBox(height: 8),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 32),
                            child: Text(
                              type.description,
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: Colors.white70, fontSize: 13),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            '${items.length} items • ${_formatDurationMs(totalDurationMs)}',
                            style: const TextStyle(
                              color: Colors.white60,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // Action buttons: Play & Shuffle
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: items.isEmpty
                              ? null
                              : () {
                                  ref.read(playerProvider.notifier).playPlaylist(items, initialIndex: 0);
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.accent,
                            foregroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          ),
                          icon: const Icon(Icons.play_arrow_rounded, size: 24),
                          label: const Text('Play', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: items.isEmpty
                              ? null
                              : () {
                                  ref.read(playerProvider.notifier).playPlaylist(items, shuffle: true);
                                },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppTheme.textPrimary,
                            side: const BorderSide(color: Colors.white24),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          ),
                          icon: const Icon(Icons.shuffle_rounded, size: 22),
                          label: const Text('Shuffle', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Search bar inside smart playlist
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: TextField(
                    style: const TextStyle(color: AppTheme.textPrimary, fontSize: 14),
                    onChanged: (val) => setState(() => _searchQuery = val.trim()),
                    decoration: InputDecoration(
                      hintText: 'Search in ${type.displayName}...',
                      hintStyle: const TextStyle(color: AppTheme.textTertiary),
                      prefixIcon: const Icon(Icons.search_rounded, color: AppTheme.textTertiary, size: 20),
                      filled: true,
                      fillColor: AppTheme.surfaceHighlight,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
              ),

              if (items.isEmpty)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: Text(
                      'No tracks available in ${type.displayName}.',
                      style: const TextStyle(color: AppTheme.textSecondary),
                    ),
                  ),
                )
              else
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (ctx, index) {
                      final item = processed[index];
                      return _buildTrackTile(
                        key: ValueKey(item.id),
                        audioItem: item,
                        index: index,
                        playlistId: null,
                        allPlaylistItems: processed,
                        showDragHandle: false,
                      );
                    },
                    childCount: processed.length,
                  ),
                ),
              const SliverToBoxAdapter(child: SizedBox(height: 100)),
            ],
          ),
        );
      },
      loading: () => const Scaffold(
        backgroundColor: AppTheme.background,
        body: Center(child: CircularProgressIndicator(color: AppTheme.accent)),
      ),
      error: (err, _) => Scaffold(
        backgroundColor: AppTheme.background,
        body: Center(child: Text('Error loading smart playlist: $err', style: const TextStyle(color: Colors.redAccent))),
      ),
    );
  }

  // ─── Sliver App Bar for Custom Playlist ──────────────────────────────────
  SliverAppBar _buildSliverAppBar({
    required PlaylistEntity playlist,
    required List<String> itemArtworks,
    required List<AudioItemEntity> rawAudioList,
    required int totalDurationMs,
    required int itemCount,
  }) {
    return SliverAppBar(
      expandedHeight: 330,
      pinned: true,
      backgroundColor: AppTheme.surface,
      actions: [
        IconButton(
          icon: Icon(
            playlist.isLiked ? Icons.favorite_rounded : Icons.favorite_border_rounded,
            color: playlist.isLiked ? Colors.redAccent : AppTheme.textSecondary,
          ),
          onPressed: () {
            ref.read(playlistControllerProvider).toggleLike(playlist.id, !playlist.isLiked);
          },
        ),
        PopupMenuButton<String>(
          color: AppTheme.surface,
          icon: const Icon(Icons.more_vert_rounded, color: AppTheme.textSecondary),
          onSelected: (val) => _handlePlaylistMenuAction(val, playlist, rawAudioList),
          itemBuilder: (_) => [
            const PopupMenuItem(value: 'rename', child: Text('Rename Playlist')),
            const PopupMenuItem(value: 'edit_desc', child: Text('Edit Description')),
            const PopupMenuItem(value: 'artwork', child: Text('Change Artwork')),
            const PopupMenuItem(value: 'duplicate', child: Text('Duplicate Playlist')),
            const PopupMenuItem(value: 'share', child: Text('Share Playlist')),
            const PopupMenuItem(value: 'export', child: Text('Export Tracklist')),
            const PopupMenuDivider(),
            const PopupMenuItem(
              value: 'delete',
              child: Text('Delete Playlist', style: TextStyle(color: Colors.redAccent)),
            ),
          ],
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            // Background subtle gradient
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppTheme.accent.withValues(alpha: 0.15),
                    AppTheme.surface,
                    AppTheme.background,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 10),
                    // Artwork
                    Hero(
                      tag: 'playlist_art_${playlist.id}',
                      child: GestureDetector(
                        onTap: () => _pickCustomArtwork(playlist.id),
                        child: Stack(
                          children: [
                            PlaylistArtworkWidget(
                              artworkPath: playlist.artworkPath,
                              itemArtworkPaths: itemArtworks,
                              size: 110,
                              borderRadius: 16,
                            ),
                            Positioned(
                              bottom: 4,
                              right: 4,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(
                                  color: Colors.black54,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.camera_alt_rounded, size: 14, color: Colors.white70),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Name
                    GestureDetector(
                      onTap: () => _showRenameDialog(playlist),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(
                            child: Text(
                              playlist.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.textPrimary,
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          const Icon(Icons.edit_rounded, size: 14, color: AppTheme.textTertiary),
                        ],
                      ),
                    ),
                    if (playlist.description != null && playlist.description!.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        playlist.description!,
                        maxLines: 2,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 12, color: AppTheme.textTertiary),
                      ),
                    ],
                    const SizedBox(height: 6),
                    Text(
                      '$itemCount items • ${_formatDurationMs(totalDurationMs)}',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 14),
                    // Action Buttons: Play & Shuffle
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton.icon(
                          onPressed: rawAudioList.isEmpty
                              ? null
                              : () {
                                  ref.read(playerProvider.notifier).playPlaylist(rawAudioList, initialIndex: 0);
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.accent,
                            foregroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          ),
                          icon: const Icon(Icons.play_arrow_rounded, size: 22),
                          label: const Text('Play', style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        const SizedBox(width: 12),
                        OutlinedButton.icon(
                          onPressed: rawAudioList.isEmpty
                              ? null
                              : () {
                                  ref.read(playerProvider.notifier).playPlaylist(rawAudioList, shuffle: true);
                                },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppTheme.textPrimary,
                            side: const BorderSide(color: Colors.white24),
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          ),
                          icon: const Icon(Icons.shuffle_rounded, size: 20),
                          label: const Text('Shuffle', style: TextStyle(fontWeight: FontWeight.bold)),
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

  // ─── Filter & Sort Items ──────────────────────────────────────────────────
  List<PlaylistItemEntity> _filterAndSortItems(List<PlaylistItemEntity> list) {
    var items = List<PlaylistItemEntity>.from(list);

    // 1. Search filter
    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      items = items.where((it) {
        final audio = it.audioItem;
        return audio.title.toLowerCase().contains(q) ||
            (audio.artist?.toLowerCase().contains(q) ?? false) ||
            (audio.album?.toLowerCase().contains(q) ?? false);
      }).toList();
    }

    // 2. Sort
    switch (_sortOption) {
      case PlaylistSortOption.nameAsc:
        items.sort((a, b) => a.audioItem.title.toLowerCase().compareTo(b.audioItem.title.toLowerCase()));
        break;
      case PlaylistSortOption.nameDesc:
        items.sort((a, b) => b.audioItem.title.toLowerCase().compareTo(a.audioItem.title.toLowerCase()));
        break;
      case PlaylistSortOption.artist:
        items.sort((a, b) => (a.audioItem.artist ?? '').toLowerCase().compareTo((b.audioItem.artist ?? '').toLowerCase()));
        break;
      case PlaylistSortOption.album:
        items.sort((a, b) => (a.audioItem.album ?? '').toLowerCase().compareTo((b.audioItem.album ?? '').toLowerCase()));
        break;
      case PlaylistSortOption.duration:
        items.sort((a, b) => (b.audioItem.durationMs ?? 0).compareTo(a.audioItem.durationMs ?? 0));
        break;
      case PlaylistSortOption.recentlyAdded:
        items.sort((a, b) => b.addedAt.compareTo(a.addedAt));
        break;
      case PlaylistSortOption.custom:
        items.sort((a, b) => a.position.compareTo(b.position));
        break;
    }

    return items;
  }

  // ─── Track Tile ───────────────────────────────────────────────────────────
  Widget _buildTrackTile({
    Key? key,
    PlaylistItemEntity? playlistItem,
    required AudioItemEntity audioItem,
    required int index,
    required String? playlistId,
    required List<AudioItemEntity> allPlaylistItems,
    required bool showDragHandle,
  }) {
    final isUnavailable = !audioItem.isAvailable;

    return Dismissible(
      key: ValueKey('dismiss_${playlistItem?.id ?? audioItem.id}'),
      direction: playlistId != null ? DismissDirection.endToStart : DismissDirection.none,
      background: Container(
        color: Colors.redAccent.withValues(alpha: 0.2),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent),
      ),
      onDismissed: (_) {
        if (playlistId != null) {
          ref.read(playlistControllerProvider).removeItem(playlistId, audioItem.id);
        }
      },
      child: ListTile(
        key: key,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
        leading: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 24,
              child: Text(
                '${index + 1}',
                style: const TextStyle(fontSize: 12, color: AppTheme.textTertiary),
              ),
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: audioItem.artworkPath != null && File(audioItem.artworkPath!).existsSync()
                  ? Image.file(
                      File(audioItem.artworkPath!),
                      width: 44,
                      height: 44,
                      fit: BoxFit.cover,
                    )
                  : Container(
                      width: 44,
                      height: 44,
                      color: AppTheme.surfaceHighlight,
                      child: Icon(
                        _getItemTypeIcon(audioItem.itemType),
                        color: AppTheme.textTertiary,
                        size: 20,
                      ),
                    ),
            ),
          ],
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                audioItem.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: isUnavailable ? AppTheme.textTertiary : AppTheme.textPrimary,
                  fontWeight: FontWeight.w500,
                  decoration: isUnavailable ? TextDecoration.lineThrough : null,
                ),
              ),
            ),
            if (isUnavailable)
              Container(
                margin: const EdgeInsets.only(left: 6),
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.redAccent.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  'Unavailable',
                  style: TextStyle(fontSize: 10, color: Colors.redAccent, fontWeight: FontWeight.bold),
                ),
              ),
          ],
        ),
        subtitle: Row(
          children: [
            _buildTypeBadge(audioItem.itemType),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                audioItem.displayArtist,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 12, color: AppTheme.textTertiary),
              ),
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              audioItem.durationMs != null ? _formatDurationMs(audioItem.durationMs!) : '--:--',
              style: const TextStyle(fontSize: 12, color: AppTheme.textTertiary),
            ),
            IconButton(
              icon: const Icon(Icons.more_vert_rounded, size: 20, color: AppTheme.textSecondary),
              onPressed: () => _showTrackOptions(audioItem, playlistId),
            ),
            if (showDragHandle)
              const Icon(Icons.drag_handle_rounded, color: AppTheme.textTertiary, size: 20),
          ],
        ),
        onTap: () {
          if (isUnavailable) {
            _showUnavailableDialog(audioItem, playlistId);
          } else {
            ref.read(playerProvider.notifier).playPlaylist(
                  allPlaylistItems,
                  initialIndex: index,
                );
          }
        },
      ),
    );
  }

  // ─── Empty State ──────────────────────────────────────────────────────────
  Widget _buildEmptyState(String playlistId) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppTheme.surfaceHighlight,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.queue_music_rounded, size: 48, color: AppTheme.textTertiary),
          ),
          const SizedBox(height: 16),
          const Text(
            'This playlist is empty.',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Add songs, clips, recordings or merged tracks.',
            style: TextStyle(fontSize: 13, color: AppTheme.textTertiary),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => _openAddItemsSheet(playlistId, {}),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.accent,
              foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
            icon: const Icon(Icons.add_rounded),
            label: const Text('Add Audio', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }


  // ─── Add Items Sheet ──────────────────────────────────────────────────────
  Future<void> _openAddItemsSheet(String playlistId, Set<String> existingIds) async {
    final addedCount = await AddItemsToPlaylistSheet.show(
      context,
      playlistId: playlistId,
      existingItemIds: existingIds,
    );

    if (addedCount != null && addedCount > 0 && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Added $addedCount item(s) to playlist'),
          backgroundColor: AppTheme.surfaceHighlight,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  // ─── Dialogs & Actions ────────────────────────────────────────────────────
  Future<void> _pickCustomArtwork(String playlistId) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      await ref.read(playlistControllerProvider).changeArtwork(playlistId, picked.path);
    }
  }

  void _handlePlaylistMenuAction(
    String action,
    PlaylistEntity playlist,
    List<AudioItemEntity> items,
  ) {
    switch (action) {
      case 'rename':
        _showRenameDialog(playlist);
        break;
      case 'edit_desc':
        _showEditDescriptionDialog(playlist);
        break;
      case 'artwork':
        _pickCustomArtwork(playlist.id);
        break;
      case 'duplicate':
        _duplicatePlaylist(playlist);
        break;
      case 'share':
        PlaylistShareService.sharePlaylistText(playlist: playlist, items: items);
        break;
      case 'export':
        _showExportDialog(playlist, items);
        break;
      case 'delete':
        _confirmDeletePlaylist(playlist);
        break;
    }
  }

  Future<void> _showRenameDialog(PlaylistEntity playlist) async {
    final controller = TextEditingController(text: playlist.name);
    await showDialog(
      context: context,
      builder: (dlgCtx) => AlertDialog(
        backgroundColor: AppTheme.surface,
        title: const Text('Rename Playlist', style: TextStyle(color: AppTheme.textPrimary)),
        content: TextField(
          controller: controller,
          autofocus: true,
          style: const TextStyle(color: AppTheme.textPrimary),
          decoration: InputDecoration(
            labelText: 'Playlist Name',
            filled: true,
            fillColor: AppTheme.surfaceHighlight,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dlgCtx).pop(),
            child: const Text('Cancel', style: TextStyle(color: AppTheme.textSecondary)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.accent, foregroundColor: Colors.black),
            onPressed: () {
              final newName = controller.text.trim();
              if (newName.isNotEmpty) {
                ref.read(playlistControllerProvider).renamePlaylist(playlist.id, newName);
              }
              Navigator.of(dlgCtx).pop();
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  Future<void> _showEditDescriptionDialog(PlaylistEntity playlist) async {
    final controller = TextEditingController(text: playlist.description ?? '');
    await showDialog(
      context: context,
      builder: (dlgCtx) => AlertDialog(
        backgroundColor: AppTheme.surface,
        title: const Text('Edit Description', style: TextStyle(color: AppTheme.textPrimary)),
        content: TextField(
          controller: controller,
          maxLines: 3,
          autofocus: true,
          style: const TextStyle(color: AppTheme.textPrimary),
          decoration: InputDecoration(
            labelText: 'Description',
            filled: true,
            fillColor: AppTheme.surfaceHighlight,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dlgCtx).pop(),
            child: const Text('Cancel', style: TextStyle(color: AppTheme.textSecondary)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.accent, foregroundColor: Colors.black),
            onPressed: () {
              ref.read(playlistControllerProvider).editDescription(playlist.id, controller.text.trim());
              Navigator.of(dlgCtx).pop();
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  Future<void> _duplicatePlaylist(PlaylistEntity playlist) async {
    final controller = ref.read(playlistControllerProvider);
    final newId = await controller.duplicate(playlist.id);
    if (newId != null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Duplicated "${playlist.name}"'),
          backgroundColor: AppTheme.surfaceHighlight,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> _showExportDialog(PlaylistEntity playlist, List<AudioItemEntity> items) async {
    await showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.surface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (sheetCtx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Export Playlist',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
              ),
              const SizedBox(height: 12),
              ListTile(
                leading: const Icon(Icons.description_rounded, color: AppTheme.accent),
                title: const Text('Plain Text (.txt)'),
                subtitle: const Text('Readable tracklist with artist & durations'),
                onTap: () {
                  Navigator.of(sheetCtx).pop();
                  PlaylistShareService.sharePlaylistFile(playlist: playlist, items: items, format: 'txt');
                },
              ),
              ListTile(
                leading: const Icon(Icons.table_chart_rounded, color: Colors.greenAccent),
                title: const Text('CSV (.csv)'),
                subtitle: const Text('Comma-separated spreadsheet values'),
                onTap: () {
                  Navigator.of(sheetCtx).pop();
                  PlaylistShareService.sharePlaylistFile(playlist: playlist, items: items, format: 'csv');
                },
              ),
              ListTile(
                leading: const Icon(Icons.code_rounded, color: Colors.amberAccent),
                title: const Text('JSON (.json)'),
                subtitle: const Text('Structured JSON for Pattu Petti backup/import'),
                onTap: () {
                  Navigator.of(sheetCtx).pop();
                  PlaylistShareService.sharePlaylistFile(playlist: playlist, items: items, format: 'json');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _confirmDeletePlaylist(PlaylistEntity playlist) async {
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
      if (mounted) {
        context.pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Deleted playlist "${playlist.name}"'),
            backgroundColor: AppTheme.surfaceHighlight,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  void _showTrackOptions(AudioItemEntity item, String? playlistId) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.surface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (sheetCtx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: item.artworkPath != null && File(item.artworkPath!).existsSync()
                        ? Image.file(File(item.artworkPath!), width: 44, height: 44, fit: BoxFit.cover)
                        : Container(
                            width: 44,
                            height: 44,
                            color: AppTheme.surfaceHighlight,
                            child: Icon(_getItemTypeIcon(item.itemType), color: AppTheme.textTertiary),
                          ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
                        ),
                        Text(
                          item.displayArtist,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 12, color: AppTheme.textTertiary),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Divider(color: Colors.white12),
            ListTile(
              leading: const Icon(Icons.playlist_play_rounded, color: AppTheme.accent),
              title: const Text('Play Next'),
              onTap: () {
                Navigator.of(sheetCtx).pop();
                ref.read(playerProvider.notifier).playNextPlaylist([item]);
              },
            ),
            ListTile(
              leading: const Icon(Icons.queue_music_rounded, color: AppTheme.accent),
              title: const Text('Add to Queue'),
              onTap: () {
                Navigator.of(sheetCtx).pop();
                ref.read(playerProvider.notifier).addPlaylistToQueue([item]);
              },
            ),
            ListTile(
              leading: const Icon(Icons.playlist_add_rounded, color: AppTheme.textSecondary),
              title: const Text('Add to Another Playlist'),
              onTap: () {
                Navigator.of(sheetCtx).pop();
                AddToPlaylistModal.show(context, audioItemIds: [item.id], itemTitle: item.title);
              },
            ),
            if (playlistId != null)
              ListTile(
                leading: const Icon(Icons.remove_circle_outline_rounded, color: Colors.redAccent),
                title: const Text('Remove from this Playlist', style: TextStyle(color: Colors.redAccent)),
                onTap: () {
                  Navigator.of(sheetCtx).pop();
                  ref.read(playlistControllerProvider).removeItem(playlistId, item.id);
                },
              ),
          ],
        ),
      ),
    );
  }

  void _showUnavailableDialog(AudioItemEntity item, String? playlistId) {
    showDialog(
      context: context,
      builder: (dlgCtx) => AlertDialog(
        backgroundColor: AppTheme.surface,
        title: const Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.orangeAccent),
            SizedBox(width: 8),
            Text('File Unavailable', style: TextStyle(color: AppTheme.textPrimary)),
          ],
        ),
        content: Text(
          '"${item.title}" source audio is missing or moved. You can remove it from this playlist.',
          style: const TextStyle(color: AppTheme.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dlgCtx).pop(),
            child: const Text('Cancel', style: TextStyle(color: AppTheme.textSecondary)),
          ),
          if (playlistId != null)
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent, foregroundColor: Colors.white),
              onPressed: () {
                Navigator.of(dlgCtx).pop();
                ref.read(playlistControllerProvider).removeItem(playlistId, item.id);
              },
              child: const Text('Remove from Playlist'),
            ),
        ],
      ),
    );
  }

  Widget _buildTypeBadge(AudioItemType itemType) {
    final (label, color) = switch (itemType) {
      AudioItemType.clip => ('Clip', Colors.amber),
      AudioItemType.merged => ('Merged', Colors.purpleAccent),
      AudioItemType.recording => ('Recording', Colors.tealAccent),
      _ => ('Song', Colors.blueAccent),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: color),
      ),
    );
  }

  IconData _getItemTypeIcon(AudioItemType itemType) {
    return switch (itemType) {
      AudioItemType.clip => Icons.content_cut_rounded,
      AudioItemType.merged => Icons.merge_type_rounded,
      AudioItemType.recording => Icons.mic_rounded,
      _ => Icons.music_note_rounded,
    };
  }

  String _formatDurationMs(int ms) {
    final d = Duration(milliseconds: ms);
    final h = d.inHours;
    final m = d.inMinutes.remainder(60);
    final s = d.inSeconds.remainder(60);
    if (h > 0) {
      return '$h hr ${m > 0 ? '$m min' : ''}'.trim();
    }
    return '$m:${s.toString().padLeft(2, '0')}';
  }
}
