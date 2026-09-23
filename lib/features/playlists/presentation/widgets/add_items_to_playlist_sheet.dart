import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/providers/global_providers.dart';
import '../../../../data/local/database/app_database.dart';
import '../../../../data/local/database/app_database_dao.dart';
import '../providers/playlist_providers.dart';

class AddItemsToPlaylistSheet extends ConsumerStatefulWidget {
  const AddItemsToPlaylistSheet({
    super.key,
    required this.playlistId,
    required this.existingItemIds,
  });

  final String playlistId;
  final Set<String> existingItemIds;

  static Future<int?> show(
    BuildContext context, {
    required String playlistId,
    required Set<String> existingItemIds,
  }) {
    return showModalBottomSheet<int>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => AddItemsToPlaylistSheet(
        playlistId: playlistId,
        existingItemIds: existingItemIds,
      ),
    );
  }

  @override
  ConsumerState<AddItemsToPlaylistSheet> createState() => _AddItemsToPlaylistSheetState();
}

class _AddItemsToPlaylistSheetState extends ConsumerState<AddItemsToPlaylistSheet> {
  String _searchQuery = '';
  String _selectedFilter = 'All'; // 'All' | 'Songs' | 'Clips' | 'Merged' | 'Recordings'
  final Set<String> _selectedItemIds = {};
  bool _isLoading = true;
  List<AudioItem> _allItems = [];
  Map<String, String?> _artworkMap = {};

  @override
  void initState() {
    super.initState();
    _loadLibraryItems();
  }

  Future<void> _loadLibraryItems() async {
    final db = ref.read(appDatabaseProvider);
    final userId = ref.read(playlistUserIdProvider);

    final songs = await db.getAllSongs(userId);
    final clips = await db.getAllClips(userId);
    final merged = await db.getAllMerged(userId);
    final recordings = await db.getAllRecordings(userId);

    final combined = <AudioItem>[
      ...songs,
      ...clips,
      ...merged,
      ...recordings,
    ];

    // Deduplicate in case an item appears in multiple queries
    final seen = <String>{};
    final unique = <AudioItem>[];
    for (final it in combined) {
      if (seen.add(it.id)) {
        unique.add(it);
      }
    }

    unique.sort((a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()));

    // Cache artwork paths
    final artMap = <String, String?>{};
    for (final it in unique) {
      artMap[it.id] = it.artworkPath;
    }

    if (mounted) {
      setState(() {
        _allItems = unique;
        _artworkMap = artMap;
        _isLoading = false;
      });
    }
  }

  List<AudioItem> get _filteredItems {
    return _allItems.where((item) {
      // 1. Filter by category
      if (_selectedFilter == 'Songs' && item.itemType != 'song') return false;
      if (_selectedFilter == 'Clips' && item.itemType != 'clip') return false;
      if (_selectedFilter == 'Merged' && item.itemType != 'merged') return false;
      if (_selectedFilter == 'Recordings' &&
          item.itemType != 'recording' &&
          item.genre != 'Recording') {
        return false;
      }

      // 2. Filter by search query
      if (_searchQuery.isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        final matchTitle = item.title.toLowerCase().contains(q);
        final matchArtist = item.artist?.toLowerCase().contains(q) ?? false;
        final matchAlbum = item.album?.toLowerCase().contains(q) ?? false;
        if (!matchTitle && !matchArtist && !matchAlbum) return false;
      }

      return true;
    }).toList();
  }

  void _toggleSelectAll(List<AudioItem> candidates) {
    final availableCandidates = candidates
        .where((it) => !widget.existingItemIds.contains(it.id))
        .map((it) => it.id)
        .toList();

    setState(() {
      final allSelected = availableCandidates.every((id) => _selectedItemIds.contains(id));
      if (allSelected) {
        for (final id in availableCandidates) {
          _selectedItemIds.remove(id);
        }
      } else {
        _selectedItemIds.addAll(availableCandidates);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredItems;
    final availableFiltered =
        filtered.where((it) => !widget.existingItemIds.contains(it.id)).toList();

    return Container(
      height: MediaQuery.of(context).size.height * 0.88,
      decoration: const BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
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

          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 16, 12),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Add Audio to Playlist',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${_selectedItemIds.length} item(s) selected',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppTheme.accent,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                if (availableFiltered.isNotEmpty)
                  TextButton.icon(
                    onPressed: () => _toggleSelectAll(filtered),
                    icon: Icon(
                      availableFiltered.every((it) => _selectedItemIds.contains(it.id))
                          ? Icons.deselect_rounded
                          : Icons.select_all_rounded,
                      size: 18,
                      color: AppTheme.accent,
                    ),
                    label: Text(
                      availableFiltered.every((it) => _selectedItemIds.contains(it.id))
                          ? 'Deselect'
                          : 'Select All',
                      style: const TextStyle(color: AppTheme.accent, fontSize: 13),
                    ),
                  ),
                IconButton(
                  icon: const Icon(Icons.close_rounded, color: AppTheme.textSecondary),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),

          // Search bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              onChanged: (val) => setState(() => _searchQuery = val.trim()),
              style: const TextStyle(color: AppTheme.textPrimary, fontSize: 14),
              decoration: InputDecoration(
                hintText: 'Search songs, clips, recordings...',
                hintStyle: const TextStyle(color: AppTheme.textTertiary, fontSize: 14),
                prefixIcon: const Icon(Icons.search_rounded, color: AppTheme.textTertiary, size: 20),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear_rounded, size: 18, color: AppTheme.textTertiary),
                        onPressed: () => setState(() => _searchQuery = ''),
                      )
                    : null,
                filled: true,
                fillColor: AppTheme.surfaceHighlight,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          // Filter chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              children: [
                'All',
                'Songs',
                'Clips',
                'Merged',
                'Recordings',
              ].map((filter) {
                final isSelected = _selectedFilter == filter;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(filter),
                    selected: isSelected,
                    onSelected: (_) => setState(() => _selectedFilter = filter),
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
                        width: 1,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          const Divider(height: 1, color: Colors.white12),

          // Audio items list
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator(color: AppTheme.accent))
                : filtered.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.music_off_rounded, size: 48, color: AppTheme.textTertiary),
                            const SizedBox(height: 12),
                            Text(
                              _searchQuery.isNotEmpty
                                  ? 'No items matching "$_searchQuery"'
                                  : 'No items in this category',
                              style: const TextStyle(color: AppTheme.textSecondary),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: filtered.length,
                        itemBuilder: (ctx, i) {
                          final item = filtered[i];
                          final isAlreadyIn = widget.existingItemIds.contains(item.id);
                          final isSelected = _selectedItemIds.contains(item.id);
                          final artwork = _artworkMap[item.id];

                          return ListTile(
                            enabled: !isAlreadyIn,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                            leading: Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: artwork != null && File(artwork).existsSync()
                                      ? Image.file(
                                          File(artwork),
                                          width: 44,
                                          height: 44,
                                          fit: BoxFit.cover,
                                        )
                                      : Container(
                                          width: 44,
                                          height: 44,
                                          color: AppTheme.surfaceHighlight,
                                          child: Icon(
                                            _getItemIcon(item.itemType),
                                            color: AppTheme.textTertiary,
                                            size: 22,
                                          ),
                                        ),
                                ),
                                if (isAlreadyIn)
                                  Container(
                                    width: 44,
                                    height: 44,
                                    decoration: BoxDecoration(
                                      color: Colors.black54,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Icon(
                                      Icons.check_rounded,
                                      color: Colors.white70,
                                      size: 20,
                                    ),
                                  ),
                              ],
                            ),
                            title: Text(
                              item.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: isAlreadyIn ? AppTheme.textTertiary : AppTheme.textPrimary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            subtitle: Row(
                              children: [
                                _buildTypeBadge(item.itemType),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    item.artist ?? 'Unknown Artist',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: AppTheme.textTertiary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            trailing: isAlreadyIn
                                ? Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: Colors.white12,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Text(
                                      'In Playlist',
                                      style: TextStyle(fontSize: 11, color: AppTheme.textTertiary),
                                    ),
                                  )
                                : Checkbox(
                                    value: isSelected,
                                    activeColor: AppTheme.accent,
                                    checkColor: Colors.black,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    onChanged: (val) {
                                      setState(() {
                                        if (val == true) {
                                          _selectedItemIds.add(item.id);
                                        } else {
                                          _selectedItemIds.remove(item.id);
                                        }
                                      });
                                    },
                                  ),
                            onTap: isAlreadyIn
                                ? null
                                : () {
                                    setState(() {
                                      if (isSelected) {
                                        _selectedItemIds.remove(item.id);
                                      } else {
                                        _selectedItemIds.add(item.id);
                                      }
                                    });
                                  },
                          );
                        },
                      ),
          ),

          // Bottom Action Bar
          SafeArea(
            child: Container(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              decoration: const BoxDecoration(
                color: AppTheme.surfaceHighlight,
                border: Border(top: BorderSide(color: Colors.white10)),
              ),
              child: SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton.icon(
                  onPressed: _selectedItemIds.isEmpty
                      ? null
                      : () async {
                          final controller = ref.read(playlistControllerProvider);
                          final addedCount = await controller.addItems(
                            widget.playlistId,
                            _selectedItemIds.toList(),
                          );
                          if (context.mounted) {
                            Navigator.of(context).pop(addedCount);
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.accent,
                    disabledBackgroundColor: Colors.white12,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  icon: const Icon(Icons.playlist_add_rounded, color: Colors.black),
                  label: Text(
                    _selectedItemIds.isEmpty
                        ? 'Select items to add'
                        : 'Add ${_selectedItemIds.length} Audio Items',
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypeBadge(String itemType) {
    final (label, color) = switch (itemType) {
      'clip' => ('Clip', Colors.amber),
      'merged' => ('Merged', Colors.purpleAccent),
      'recording' => ('Recording', Colors.tealAccent),
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
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }

  IconData _getItemIcon(String itemType) {
    return switch (itemType) {
      'clip' => Icons.content_cut_rounded,
      'merged' => Icons.merge_type_rounded,
      'recording' => Icons.mic_rounded,
      _ => Icons.music_note_rounded,
    };
  }
}
