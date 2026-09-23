import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as p;
import 'package:uuid/uuid.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../features/library/presentation/providers/library_provider.dart';
import '../../../../infrastructure/audio_scanner/audio_scanner.dart';
import '../../../../features/auth/presentation/providers/auth_provider.dart';
import '../../../../features/player/presentation/providers/player_provider.dart';
import '../../../../data/local/database/app_database.dart';
import '../../../../data/local/database/app_database_dao.dart';
import '../../../../shared/providers/global_providers.dart';
import '../../../recording/data/recording_file_manager.dart';
import '../../../recording/presentation/providers/recording_provider.dart';


/// Library screen with tab navigation: Songs, Artists, Albums, Genres,
/// Folders, Playlists, Clips, Merged, Recordings.
class LibraryScreen extends ConsumerStatefulWidget {
  const LibraryScreen({super.key});

  @override
  ConsumerState<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends ConsumerState<LibraryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isProcessing = false;
  String _processingMessage = '';

  final _tabs = const [
    Tab(text: 'Songs'),
    Tab(text: 'Artists'),
    Tab(text: 'Albums'),
    Tab(text: 'Genres'),
    Tab(text: 'Folders'),
    Tab(text: 'Clips'),
    Tab(text: 'Merged'),
    Tab(text: 'Recordings'),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  /// Pick individual or multiple songs using FilePicker
  Future<void> _pickAndAddSongs() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: [
          'mp3',
          'wav',
          'flac',
          'm4a',
          'aac',
          'ogg',
          'opus',
          'wma',
          'mp4',
        ],
        allowMultiple: true,
      );

      if (result == null || result.files.isEmpty) return;

      final files = result.paths
          .where((path) => path != null)
          .map((path) => File(path!))
          .where((file) => file.existsSync())
          .toList();

      if (files.isEmpty) return;

      final authState = ref.read(authStateProvider);
      final userId = authState.valueOrNull?.user?.id;
      if (userId == null) return;

      setState(() {
        _isProcessing = true;
        _processingMessage = 'Adding ${files.length} song(s)...';
      });

      final scanner = ref.read(audioScannerProvider);
      final scanResult = await scanner.addFiles(
        files: files,
        userId: userId,
        onProgress: (cur, tot, name) {
          if (mounted) {
            setState(() {
              _processingMessage = 'Adding $cur/$tot: $name';
            });
          }
        },
      );

      if (!mounted) return;
      setState(() => _isProcessing = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            scanResult.newItems > 0
                ? 'Added ${scanResult.newItems} song(s) to your library!'
                : 'Selected song(s) were already in your library.',
          ),
          backgroundColor:
              scanResult.newItems > 0 ? AppTheme.success : AppTheme.accent,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _isProcessing = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not add songs: $e'),
          backgroundColor: AppTheme.error,
        ),
      );
    }
  }

  /// Pick an entire music folder using FilePicker directory selector
  Future<void> _pickAndAddFolder() async {
    try {
      final selectedDirectory = await FilePicker.platform.getDirectoryPath();
      if (selectedDirectory == null || selectedDirectory.isEmpty) return;

      final authState = ref.read(authStateProvider);
      final userId = authState.valueOrNull?.user?.id;
      if (userId == null) return;

      final folderName = p.basename(selectedDirectory);

      setState(() {
        _isProcessing = true;
        _processingMessage = 'Scanning folder "$folderName"...';
      });

      final scanner = ref.read(audioScannerProvider);
      final scanResult = await scanner.addFolderSourceAndScan(
        folderPath: selectedDirectory,
        userId: userId,
        onProgress: (cur, tot, name) {
          if (mounted) {
            setState(() {
              _processingMessage = 'Scanning $cur: $name';
            });
          }
        },
      );

      if (!mounted) return;
      setState(() => _isProcessing = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            scanResult.newItems > 0
                ? 'Folder added! Found ${scanResult.newItems} new track(s).'
                : 'Folder added! No new audio tracks found inside.',
          ),
          backgroundColor:
              scanResult.newItems > 0 ? AppTheme.success : AppTheme.accent,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _isProcessing = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not add folder: $e'),
          backgroundColor: AppTheme.error,
        ),
      );
    }
  }

  /// Scan device media store automatically
  Future<void> _scanLibrary() async {
    final authState = ref.read(authStateProvider);
    final userId = authState.valueOrNull?.user?.id;
    if (userId == null) return;

    setState(() {
      _isProcessing = true;
      _processingMessage = 'Scanning device music...';
    });

    try {
      final scanner = ref.read(audioScannerProvider);
      final result = await scanner.scanAllFolders(
        userId: userId,
        onProgress: (cur, tot, name) {
          if (mounted) {
            setState(() {
              _processingMessage = 'Scanning $cur/$tot: $name';
            });
          }
        },
      );

      if (!mounted) return;
      setState(() => _isProcessing = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            result.newItems > 0
                ? 'Found ${result.newItems} new tracks!'
                : 'Library is up to date.',
          ),
          backgroundColor:
              result.newItems > 0 ? AppTheme.success : AppTheme.accent,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _isProcessing = false);
      debugPrint('Scan library notice: $e');
    }
  }

  /// Display Add Music modal sheet
  void _showAddMusicSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Add Music',
                    style: TextStyle(
                      color: AppTheme.textPrimary,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded,
                        color: AppTheme.textTertiary),
                    onPressed: () => Navigator.of(ctx).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppTheme.accent.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.audio_file_rounded,
                      color: AppTheme.accent, size: 24),
                ),
                title: const Text(
                  'Add Song(s)',
                  style: TextStyle(
                    color: AppTheme.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: const Text(
                  'Browse folders & select individual audio files',
                  style:
                      TextStyle(color: AppTheme.textTertiary, fontSize: 12),
                ),
                onTap: () {
                  Navigator.of(ctx).pop();
                  _pickAndAddSongs();
                },
              ),
              const SizedBox(height: 8),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.amber.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.create_new_folder_rounded,
                      color: Colors.amber, size: 24),
                ),
                title: const Text(
                  'Add Folder',
                  style: TextStyle(
                    color: AppTheme.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: const Text(
                  'Select a music directory to import all songs inside it',
                  style:
                      TextStyle(color: AppTheme.textTertiary, fontSize: 12),
                ),
                onTap: () {
                  Navigator.of(ctx).pop();
                  _pickAndAddFolder();
                },
              ),
              const SizedBox(height: 8),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.blue.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.sync_rounded,
                      color: Colors.blue, size: 24),
                ),
                title: const Text(
                  'Auto-Scan Device',
                  style: TextStyle(
                    color: AppTheme.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: const Text(
                  'Scan Android MediaStore for music automatically',
                  style:
                      TextStyle(color: AppTheme.textTertiary, fontSize: 12),
                ),
                onTap: () {
                  Navigator.of(ctx).pop();
                  _scanLibrary();
                },
              ),
              const SizedBox(height: 8),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.redAccent.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.mic_rounded,
                      color: Colors.redAccent, size: 24),
                ),
                title: const Text(
                  'Record Audio',
                  style: TextStyle(
                    color: AppTheme.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: const Text(
                  'Capture microphone voice or audio recording',
                  style:
                      TextStyle(color: AppTheme.textTertiary, fontSize: 12),
                ),
                onTap: () {
                  Navigator.of(ctx).pop();
                  context.push('/recording');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Library'),
        actions: [
          if (_isProcessing)
            const Padding(
              padding: EdgeInsets.all(14),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                    strokeWidth: 2, color: AppTheme.accent),
              ),
            )
          else ...[
            TextButton.icon(
              icon: const Icon(Icons.add_rounded, color: AppTheme.accent, size: 20),
              label: const Text(
                'Add',
                style: TextStyle(
                    color: AppTheme.accent, fontWeight: FontWeight.w600),
              ),
              onPressed: _showAddMusicSheet,
            ),
            IconButton(
              icon: const Icon(Icons.sync_rounded),
              tooltip: 'Scan device for music',
              onPressed: _scanLibrary,
            ),
          ],
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabAlignment: TabAlignment.start,
          indicatorColor: AppTheme.accent,
          labelColor: AppTheme.accent,
          unselectedLabelColor: AppTheme.textTertiary,
          dividerColor: AppTheme.divider,
          tabs: _tabs,
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppTheme.accent,
        foregroundColor: Colors.black,
        icon: const Icon(Icons.add_rounded),
        label: const Text(
          'Add Music',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        onPressed: _showAddMusicSheet,
      ),
      body: Column(
        children: [
          if (_isProcessing)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: AppTheme.surfaceHighlight,
              child: Row(
                children: [
                  const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                        strokeWidth: 2, color: AppTheme.accent),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      _processingMessage,
                      style: const TextStyle(
                          color: AppTheme.textSecondary, fontSize: 13),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _SongsTab(
                  onAddSongs: _pickAndAddSongs,
                  onAddFolder: _pickAndAddFolder,
                  onAutoScan: _scanLibrary,
                ),
                const _ArtistsTab(),
                const _AlbumsTab(),
                const _GenresTab(),
                _FoldersTab(onAddFolder: _pickAndAddFolder),
                const _ClipsTab(),
                const _MergedTab(),
                const _RecordingsTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SongsTab extends ConsumerStatefulWidget {
  const _SongsTab({
    required this.onAddSongs,
    required this.onAddFolder,
    required this.onAutoScan,
  });

  final VoidCallback onAddSongs;
  final VoidCallback onAddFolder;
  final VoidCallback onAutoScan;

  @override
  ConsumerState<_SongsTab> createState() => _SongsTabState();
}

class _SongsTabState extends ConsumerState<_SongsTab> {
  bool _isSelectionMode = false;
  final Set<String> _selectedIds = {};

  void _toggleSelection(String id) {
    setState(() {
      if (_selectedIds.contains(id)) {
        _selectedIds.remove(id);
        if (_selectedIds.isEmpty) {
          _isSelectionMode = false;
        }
      } else {
        _selectedIds.add(id);
        _isSelectionMode = true;
      }
    });
  }

  void _enterSelectionMode(String id) {
    setState(() {
      _isSelectionMode = true;
      _selectedIds.add(id);
    });
  }

  void _exitSelectionMode() {
    setState(() {
      _isSelectionMode = false;
      _selectedIds.clear();
    });
  }

  Future<void> _handleAction(String action, List<AudioItem> items) async {
    if (items.isEmpty) return;
    switch (action) {
      case 'delete':
        await _deletePermanently(items);
        break;
      case 'remove':
        await _removeFromApp(items);
        break;
      case 'like':
        await _addToLiked(items);
        break;
      case 'playlist':
        await _showAddToPlaylistSheet(items);
        break;
      case 'clip':
        _openClip(items.first);
        break;
      case 'merge':
        _openMerge(items);
        break;
      case 'share':
        await _shareAudio(items.first);
        break;
    }
  }

  Future<void> _shareAudio(AudioItem item) async {
    final db = ref.read(appDatabaseProvider);
    final fileRef = await db.getFileForItem(item.id);
    if (fileRef != null && fileRef.filePath.isNotEmpty) {
      await RecordingFileManager.shareRecording(fileRef.filePath, title: item.title);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Audio file location not found.')),
        );
      }
    }
  }

  Future<void> _deletePermanently(List<AudioItem> items) async {
    final count = items.length;
    if (!mounted) return;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            const Icon(Icons.delete_forever_rounded, color: AppTheme.error, size: 24),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                count == 1 ? 'Permanently Delete?' : 'Delete $count Files?',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        content: Text(
          count == 1
              ? 'Permanently delete "${items.first.title}" from your phone storage?\n\nThis file will be completely erased from your device.'
              : 'Permanently delete $count audio files from your phone storage?\n\nThese files will be completely erased from your device.',
          style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13, height: 1.4),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel', style: TextStyle(color: AppTheme.textTertiary)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.error,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Delete Permanently', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    final db = ref.read(appDatabaseProvider);
    final currentPlaying = ref.read(playerNotifierProvider).currentItem;

    for (final item in items) {
      if (currentPlaying?.id == item.id) {
        await ref.read(playerNotifierProvider.notifier).stop();
      }

      // Delete physical file from device
      final fileRef = await db.getFileForItem(item.id);
      if (fileRef != null && fileRef.filePath.isNotEmpty) {
        try {
          final f = File(fileRef.filePath);
          if (await f.exists()) {
            await f.delete();
          }
        } catch (e) {
          debugPrint('Error deleting file ${fileRef.filePath}: $e');
        }
      }

      // Delete DB record
      await db.deleteAudioItem(item.id);
    }

    if (mounted) {
      _exitSelectionMode();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AppTheme.error,
          content: Text(
            count == 1
                ? 'File permanently deleted from phone.'
                : '$count files permanently deleted from phone.',
          ),
        ),
      );
    }
  }

  Future<void> _removeFromApp(List<AudioItem> items) async {
    final count = items.length;
    if (!mounted) return;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            const Icon(Icons.visibility_off_rounded, color: AppTheme.accent, size: 24),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                count == 1 ? 'Remove from App?' : 'Remove $count Songs?',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        content: Text(
          count == 1
              ? 'Remove "${items.first.title}" from your Patt Petti library visibility?\n\nThe audio file will safely remain on your phone storage.'
              : 'Remove $count songs from your Patt Petti library visibility?\n\nThe audio files will safely remain on your phone storage.',
          style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13, height: 1.4),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel', style: TextStyle(color: AppTheme.textTertiary)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.accent,
              foregroundColor: Colors.black,
            ),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Remove from App', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    final db = ref.read(appDatabaseProvider);
    final currentPlaying = ref.read(playerNotifierProvider).currentItem;

    for (final item in items) {
      if (currentPlaying?.id == item.id) {
        await ref.read(playerNotifierProvider.notifier).stop();
      }
      // Delete database record only - keep physical file untouched
      await db.deleteAudioItem(item.id);
    }

    if (mounted) {
      _exitSelectionMode();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AppTheme.surfaceHighlight,
          content: Text(
            count == 1
                ? 'Removed 1 song from app (file intact on phone).'
                : 'Removed $count songs from app (files intact on phone).',
          ),
        ),
      );
    }
  }

  Future<void> _addToLiked(List<AudioItem> items) async {
    final db = ref.read(appDatabaseProvider);
    final allLiked = items.every((i) => i.isLiked);
    final targetState = !allLiked;

    for (final item in items) {
      await db.toggleLike(item.id, targetState);
    }

    if (mounted) {
      _exitSelectionMode();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AppTheme.accent,
          content: Text(
            targetState
                ? (items.length == 1 ? 'Added to Liked Songs' : 'Added ${items.length} songs to Liked')
                : (items.length == 1 ? 'Removed from Liked Songs' : 'Removed ${items.length} songs from Liked'),
            style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
          ),
        ),
      );
    }
  }

  Future<void> _showAddToPlaylistSheet(List<AudioItem> items) async {
    final user = ref.read(authStateProvider).valueOrNull?.user;
    if (user == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please log in to manage playlists.')),
        );
      }
      return;
    }
    final db = ref.read(appDatabaseProvider);
    if (!mounted) return;

    await showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) {
        return StreamBuilder<List<Playlist>>(
          stream: db.watchPlaylists(user.id),
          builder: (ctx, snapshot) {
            final playlists = snapshot.data ?? [];
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Add ${items.length} song(s) to Playlist',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close_rounded, size: 20),
                            onPressed: () => Navigator.of(sheetContext).pop(),
                          ),
                        ],
                      ),
                    ),
                    const Divider(color: Colors.white12),
                    ListTile(
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppTheme.accent.withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.add_rounded, color: AppTheme.accent),
                      ),
                      title: const Text('New Playlist', style: TextStyle(fontWeight: FontWeight.w600)),
                      subtitle: const Text('Create a new playlist and add songs', style: TextStyle(fontSize: 12, color: AppTheme.textTertiary)),
                      onTap: () async {
                        Navigator.of(sheetContext).pop();
                        if (mounted) {
                          await _createNewPlaylistAndAdd(items);
                        }
                      },
                    ),
                    if (playlists.isNotEmpty) ...[
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        child: Text(
                          'YOUR PLAYLISTS',
                          style: TextStyle(
                            fontSize: 11,
                            letterSpacing: 1,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.textTertiary,
                          ),
                        ),
                      ),
                      Flexible(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: playlists.length,
                          itemBuilder: (plCtx, i) {
                            final pl = playlists[i];
                            return ListTile(
                              leading: const Icon(Icons.queue_music_rounded, color: AppTheme.textSecondary),
                              title: Text(pl.name, style: const TextStyle(color: AppTheme.textPrimary)),
                              onTap: () async {
                                Navigator.of(sheetContext).pop();
                                if (mounted) {
                                  await _addItemsToPlaylist(pl, items);
                                }
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _createNewPlaylistAndAdd(List<AudioItem> items) async {
    final user = ref.read(authStateProvider).valueOrNull?.user;
    if (user == null || !mounted) return;
    final db = ref.read(appDatabaseProvider);
    final nameController = TextEditingController();

    final playlistName = await showDialog<String>(
      context: context,
      builder: (dlgContext) => AlertDialog(
        backgroundColor: AppTheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('New Playlist', style: TextStyle(fontWeight: FontWeight.bold)),
        content: TextField(
          controller: nameController,
          autofocus: true,
          style: const TextStyle(color: AppTheme.textPrimary),
          decoration: InputDecoration(
            hintText: 'Enter playlist title',
            hintStyle: const TextStyle(color: AppTheme.textTertiary),
            filled: true,
            fillColor: AppTheme.surfaceHighlight,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dlgContext).pop(null),
            child: const Text('Cancel', style: TextStyle(color: AppTheme.textTertiary)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.accent,
              foregroundColor: Colors.black,
            ),
            onPressed: () {
              final text = nameController.text.trim();
              if (text.isNotEmpty) {
                Navigator.of(dlgContext).pop(text);
              }
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );

    if (playlistName == null || playlistName.isEmpty) return;

    final playlistId = const Uuid().v4();
    await db.insertPlaylist(PlaylistsCompanion.insert(
      id: playlistId,
      userId: user.id,
      name: playlistName,
    ));

    final created = await db.getPlaylistById(playlistId);
    if (created != null && mounted) {
      await _addItemsToPlaylist(created, items);
    }
  }

  Future<void> _addItemsToPlaylist(Playlist playlist, List<AudioItem> items) async {
    final db = ref.read(appDatabaseProvider);
    final existingItems = await db.getPlaylistItems(playlist.id);
    final existingAudioIds = existingItems.map((e) => e.audioItemId).toSet();

    int position = existingItems.length;
    int addedCount = 0;

    for (final item in items) {
      if (!existingAudioIds.contains(item.id)) {
        await db.addToPlaylist(PlaylistItemsCompanion.insert(
          id: const Uuid().v4(),
          playlistId: playlist.id,
          audioItemId: item.id,
          position: position++,
        ));
        addedCount++;
      }
    }

    if (mounted) {
      _exitSelectionMode();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AppTheme.accent,
          content: Text(
            addedCount > 0
                ? 'Added $addedCount song(s) to "${playlist.name}"'
                : 'Songs are already in "${playlist.name}"',
            style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
          ),
        ),
      );
    }
  }

  void _openClip(AudioItem item) {
    _exitSelectionMode();
    if (mounted) {
      context.push('/clip-editor/${item.id}');
    }
  }

  void _openMerge(List<AudioItem> items) {
    _exitSelectionMode();
    if (mounted) {
      context.push('/merge-editor');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Selected ${items.length} track(s) for merge editor.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final asyncSongs = ref.watch(allSongsProvider);

    return asyncSongs.when(
      data: (songs) {
        if (songs.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 76,
                    height: 76,
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceHighlight,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppTheme.accent.withValues(alpha: 0.25),
                        width: 1.5,
                      ),
                    ),
                    child: const Icon(
                      Icons.music_note_rounded,
                      color: AppTheme.accent,
                      size: 40,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Your Library is Empty',
                    style: TextStyle(
                      color: AppTheme.textPrimary,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Pick individual songs or select music folders from your device to start listening.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppTheme.textTertiary,
                      fontSize: 13,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton.icon(
                        icon: const Icon(Icons.audio_file_rounded, size: 18),
                        label: const Text('Add Songs'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.accent,
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(AppTheme.radiusMD),
                          ),
                        ),
                        onPressed: widget.onAddSongs,
                      ),
                      const SizedBox(width: 12),
                      OutlinedButton.icon(
                        icon: const Icon(Icons.folder_open_rounded, size: 18),
                        label: const Text('Add Folder'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.amber,
                          side: const BorderSide(color: Colors.amber),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(AppTheme.radiusMD),
                          ),
                        ),
                        onPressed: widget.onAddFolder,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  TextButton.icon(
                    icon: const Icon(Icons.sync_rounded,
                        color: AppTheme.textSecondary, size: 16),
                    label: const Text(
                      'Auto-scan device music',
                      style: TextStyle(
                          color: AppTheme.textSecondary, fontSize: 13),
                    ),
                    onPressed: widget.onAutoScan,
                  ),
                ],
              ),
            ),
          );
        }

        final selectedSongs = songs.where((s) => _selectedIds.contains(s.id)).toList();
        final allSelected = songs.isNotEmpty && _selectedIds.length == songs.length;

        return Stack(
          children: [
            Column(
              children: [
                // Selection Action Bar
                if (_isSelectionMode)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    color: AppTheme.surfaceHighlight,
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.close_rounded, color: AppTheme.textPrimary),
                          onPressed: _exitSelectionMode,
                          tooltip: 'Cancel Selection',
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${_selectedIds.length} of ${songs.length} selected',
                          style: const TextStyle(
                            color: AppTheme.textPrimary,
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                          ),
                        ),
                        const Spacer(),
                        // Select All button
                        TextButton.icon(
                          icon: Icon(
                            allSelected ? Icons.deselect_rounded : Icons.select_all_rounded,
                            size: 18,
                            color: AppTheme.accent,
                          ),
                          label: Text(
                            allSelected ? 'Deselect' : 'Select All',
                            style: const TextStyle(
                              color: AppTheme.accent,
                              fontWeight: FontWeight.w700,
                              fontSize: 13,
                            ),
                          ),
                          onPressed: () {
                            setState(() {
                              if (allSelected) {
                                _selectedIds.clear();
                                _isSelectionMode = false;
                              } else {
                                _selectedIds.addAll(songs.map((s) => s.id));
                              }
                            });
                          },
                        ),
                        // 3-Dots popup menu for multiple selected
                        PopupMenuButton<String>(
                          icon: const Icon(Icons.more_vert_rounded, color: AppTheme.textPrimary),
                          color: AppTheme.surface,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          onSelected: (val) => _handleAction(val, selectedSongs),
                          itemBuilder: (ctx) => [
                            PopupMenuItem(
                              value: 'like',
                              enabled: selectedSongs.isNotEmpty,
                              child: const Row(
                                children: [
                                  Icon(Icons.favorite_rounded, color: AppTheme.accent, size: 20),
                                  SizedBox(width: 12),
                                  Text('Add to Liked'),
                                ],
                              ),
                            ),
                            PopupMenuItem(
                              value: 'playlist',
                              enabled: selectedSongs.isNotEmpty,
                              child: const Row(
                                children: [
                                  Icon(Icons.playlist_add_rounded, color: Colors.blueAccent, size: 20),
                                  SizedBox(width: 12),
                                  Text('Add to Playlist'),
                                ],
                              ),
                            ),
                            PopupMenuItem(
                              value: 'clip',
                              enabled: selectedSongs.isNotEmpty,
                              child: const Row(
                                children: [
                                  Icon(Icons.content_cut_rounded, color: Colors.purpleAccent, size: 20),
                                  SizedBox(width: 12),
                                  Text('Create Clip'),
                                ],
                              ),
                            ),
                            PopupMenuItem(
                              value: 'merge',
                              enabled: selectedSongs.length >= 2,
                              child: const Row(
                                children: [
                                  Icon(Icons.merge_type_rounded, color: Colors.amberAccent, size: 20),
                                  SizedBox(width: 12),
                                  Text('Merge Tracks'),
                                ],
                              ),
                            ),
                            const PopupMenuDivider(),
                            PopupMenuItem(
                              value: 'remove',
                              enabled: selectedSongs.isNotEmpty,
                              child: const Row(
                                children: [
                                  Icon(Icons.visibility_off_rounded, color: Colors.orangeAccent, size: 20),
                                  SizedBox(width: 12),
                                  Text('Remove from App'),
                                ],
                              ),
                            ),
                            PopupMenuItem(
                              value: 'delete',
                              enabled: selectedSongs.isNotEmpty,
                              child: const Row(
                                children: [
                                  Icon(Icons.delete_forever_rounded, color: AppTheme.error, size: 20),
                                  SizedBox(width: 12),
                                  Text('Delete Permanently', style: TextStyle(color: AppTheme.error)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                // Songs List
                Expanded(
                  child: ListView.builder(
                    itemCount: songs.length,
                    padding: EdgeInsets.only(
                      top: 8,
                      bottom: _isSelectionMode ? 140 : 80,
                    ),
                    itemBuilder: (ctx, i) {
                      final item = songs[i];
                      final isSelected = _selectedIds.contains(item.id);
                      return _SongListTile(
                        item: item,
                        playlist: songs,
                        isSelectionMode: _isSelectionMode,
                        isSelected: isSelected,
                        onToggleSelect: () => _toggleSelection(item.id),
                        onLongPress: () => _enterSelectionMode(item.id),
                        onActionSelected: (action) => _handleAction(action, [item]),
                      );
                    },
                  ),
                ),
              ],
            ),

            // Bottom Quick Action Bar when items are selected
            if (_isSelectionMode && selectedSongs.isNotEmpty)
              Positioned(
                bottom: 16,
                left: 20,
                right: 20,
                child: Container(
                  height: 56,
                  decoration: BoxDecoration(
                    color: AppTheme.surface,
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(color: AppTheme.accent.withValues(alpha: 0.3)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.4),
                        blurRadius: 16,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        tooltip: 'Like',
                        icon: const Icon(Icons.favorite_rounded, color: AppTheme.accent),
                        onPressed: () => _handleAction('like', selectedSongs),
                      ),
                      IconButton(
                        tooltip: 'Add to Playlist',
                        icon: const Icon(Icons.playlist_add_rounded, color: Colors.blueAccent),
                        onPressed: () => _handleAction('playlist', selectedSongs),
                      ),
                      if (selectedSongs.length >= 2)
                        IconButton(
                          tooltip: 'Merge',
                          icon: const Icon(Icons.merge_type_rounded, color: Colors.amberAccent),
                          onPressed: () => _handleAction('merge', selectedSongs),
                        )
                      else
                        IconButton(
                          tooltip: 'Clip',
                          icon: const Icon(Icons.content_cut_rounded, color: Colors.purpleAccent),
                          onPressed: () => _handleAction('clip', selectedSongs),
                        ),
                      IconButton(
                        tooltip: 'Remove from App',
                        icon: const Icon(Icons.visibility_off_rounded, color: Colors.orangeAccent),
                        onPressed: () => _handleAction('remove', selectedSongs),
                      ),
                      IconButton(
                        tooltip: 'Delete Permanently',
                        icon: const Icon(Icons.delete_forever_rounded, color: AppTheme.error),
                        onPressed: () => _handleAction('delete', selectedSongs),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        );
      },
      loading: () => const Center(
        child: CircularProgressIndicator(color: AppTheme.accent),
      ),
      error: (e, _) => Center(child: Text('Error: $e')),
    );
  }
}

class _FoldersTab extends ConsumerWidget {
  const _FoldersTab({required this.onAddFolder});

  final VoidCallback onAddFolder;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncFolders = ref.watch(folderSourcesProvider);

    return asyncFolders.when(
      data: (folders) {
        if (folders.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 76,
                    height: 76,
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceHighlight,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.amber.withValues(alpha: 0.3),
                        width: 1.5,
                      ),
                    ),
                    child: const Icon(
                      Icons.folder_open_rounded,
                      color: Colors.amber,
                      size: 38,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'No Music Folders Added',
                    style: TextStyle(
                      color: AppTheme.textPrimary,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Add folders from your phone storage (e.g. Music, Downloads) to scan and manage music easily.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppTheme.textTertiary,
                      fontSize: 13,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.create_new_folder_rounded, size: 18),
                    label: const Text('Add Music Folder'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(AppTheme.radiusMD),
                      ),
                    ),
                    onPressed: onAddFolder,
                  ),
                ],
              ),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.only(top: 8, bottom: 80),
          itemCount: folders.length,
          itemBuilder: (ctx, i) {
            final folder = folders[i];
            return Card(
              color: AppTheme.cardColor,
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppTheme.radiusMD),
              ),
              child: ListTile(
                leading: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: Colors.amber.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(AppTheme.radiusSM),
                  ),
                  child: const Icon(Icons.folder_rounded,
                      color: Colors.amber, size: 26),
                ),
                title: Text(
                  folder.displayName ?? p.basename(folder.folderPath),
                  style: const TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Text(
                  folder.folderPath,
                  style: const TextStyle(
                    color: AppTheme.textTertiary,
                    fontSize: 11,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.refresh_rounded,
                          color: AppTheme.textSecondary, size: 20),
                      tooltip: 'Rescan folder',
                      onPressed: () async {
                        final authState = ref.read(authStateProvider);
                        final userId = authState.valueOrNull?.user?.id;
                        if (userId == null) return;
                        final scanner = ref.read(audioScannerProvider);
                        final res = await scanner.scanFolder(
                          folderPath: folder.folderPath,
                          userId: userId,
                        );
                        if (ctx.mounted) {
                          ScaffoldMessenger.of(ctx).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Rescanned! ${res.newItems} new track(s) found.',
                              ),
                              backgroundColor: AppTheme.success,
                            ),
                          );
                        }
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline_rounded,
                          color: AppTheme.error, size: 20),
                      tooltip: 'Remove folder',
                      onPressed: () async {
                        final scanner = ref.read(audioScannerProvider);
                        await scanner.removeFolderSource(folder.id);
                        if (ctx.mounted) {
                          ScaffoldMessenger.of(ctx).showSnackBar(
                            const SnackBar(
                              content: Text('Folder source removed.'),
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
      loading: () => const Center(
        child: CircularProgressIndicator(color: AppTheme.accent),
      ),
      error: (e, _) => Center(child: Text('Error: $e')),
    );
  }
}

class _ArtistsTab extends StatelessWidget {
  const _ArtistsTab();
  @override
  Widget build(BuildContext context) => const _EmptyLibrary(
        icon: Icons.people_outlined,
        message: 'Artists will appear here once audio is added.',
      );
}

class _AlbumsTab extends StatelessWidget {
  const _AlbumsTab();
  @override
  Widget build(BuildContext context) => const _EmptyLibrary(
        icon: Icons.album_outlined,
        message: 'Albums will appear here once audio is added.',
      );
}

class _GenresTab extends StatelessWidget {
  const _GenresTab();
  @override
  Widget build(BuildContext context) => const _EmptyLibrary(
        icon: Icons.category_outlined,
        message: 'Genres will appear here once audio is added.',
      );
}

class _ClipsTab extends ConsumerWidget {
  const _ClipsTab();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncClips = ref.watch(allClipsProvider);
    return asyncClips.when(
      data: (clips) => clips.isEmpty
          ? const _EmptyLibrary(
              icon: Icons.content_cut_outlined,
              message: 'No clips yet.\nOpen a song and tap Create Clip.',
            )
          : ListView.builder(
              padding: const EdgeInsets.only(top: 8, bottom: 80),
              itemCount: clips.length,
              itemBuilder: (ctx, i) => _SongListTile(item: clips[i]),
            ),
      loading: () => const Center(
        child: CircularProgressIndicator(color: AppTheme.accent),
      ),
      error: (e, _) => Center(child: Text('Error: $e')),
    );
  }
}

class _MergedTab extends StatelessWidget {
  const _MergedTab();
  @override
  Widget build(BuildContext context) => const _EmptyLibrary(
        icon: Icons.merge_type_outlined,
        message: 'Merged tracks will appear here.',
      );
}

class _RecordingsTab extends ConsumerStatefulWidget {
  const _RecordingsTab();

  @override
  ConsumerState<_RecordingsTab> createState() => _RecordingsTabState();
}

class _RecordingsTabState extends ConsumerState<_RecordingsTab> {
  Future<void> _handleAction(String action, AudioItem item) async {
    switch (action) {
      case 'share':
        final db = ref.read(appDatabaseProvider);
        final fileRef = await db.getFileForItem(item.id);
        if (fileRef != null && fileRef.filePath.isNotEmpty) {
          await RecordingFileManager.shareRecording(fileRef.filePath, title: item.title);
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Audio file location not found.')),
            );
          }
        }
        break;
      case 'like':
        final db = ref.read(appDatabaseProvider);
        await db.toggleLike(item.id, !item.isLiked);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: AppTheme.accent,
              content: Text(
                !item.isLiked ? 'Added to Liked Songs' : 'Removed from Liked Songs',
                style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
              ),
            ),
          );
        }
        break;
      case 'playlist':
        await _showAddToPlaylistSheet(item);
        break;
      case 'clip':
        context.push('/clip-editor/${item.id}');
        break;
      case 'merge':
        context.push('/merge-editor');
        break;
      case 'remove':
        await _removeFromApp(item);
        break;
      case 'delete':
        await _deletePermanently(item);
        break;
    }
  }

  Future<void> _deletePermanently(AudioItem item) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.delete_forever_rounded, color: AppTheme.error, size: 24),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                'Delete Recording?',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        content: Text(
          'Permanently delete "${item.title}"?\n\nThe audio file will be erased from your device storage.',
          style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13, height: 1.4),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel', style: TextStyle(color: AppTheme.textTertiary)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.error,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Delete', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    final currentPlaying = ref.read(playerNotifierProvider).currentItem;
    if (currentPlaying?.id == item.id) {
      await ref.read(playerNotifierProvider.notifier).stop();
    }

    await ref.read(recordingRepositoryProvider).deleteRecording(item.id);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: AppTheme.error,
          content: Text('Recording permanently deleted.'),
        ),
      );
    }
  }

  Future<void> _removeFromApp(AudioItem item) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.visibility_off_rounded, color: AppTheme.accent, size: 24),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                'Remove from App?',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        content: Text(
          'Remove "${item.title}" from library visibility?\n\nThe audio file remains safely stored in PattuPetti/Recordings.',
          style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13, height: 1.4),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel', style: TextStyle(color: AppTheme.textTertiary)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.accent,
              foregroundColor: Colors.black,
            ),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Remove', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    final currentPlaying = ref.read(playerNotifierProvider).currentItem;
    if (currentPlaying?.id == item.id) {
      await ref.read(playerNotifierProvider.notifier).stop();
    }

    final db = ref.read(appDatabaseProvider);
    await db.deleteAudioItem(item.id);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: AppTheme.surfaceHighlight,
          content: Text('Recording removed from app.'),
        ),
      );
    }
  }

  Future<void> _showAddToPlaylistSheet(AudioItem item) async {
    final user = ref.read(authStateProvider).valueOrNull?.user;
    if (user == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please log in to manage playlists.')),
        );
      }
      return;
    }
    final db = ref.read(appDatabaseProvider);
    if (!mounted) return;

    await showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) {
        return StreamBuilder<List<Playlist>>(
          stream: db.watchPlaylists(user.id),
          builder: (ctx, snapshot) {
            final playlists = snapshot.data ?? [];
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Add Recording to Playlist',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close_rounded),
                            onPressed: () => Navigator.of(ctx).pop(),
                          ),
                        ],
                      ),
                    ),
                    const Divider(color: AppTheme.divider),
                    if (playlists.isEmpty)
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                        child: Center(
                          child: Text(
                            'No playlists yet. Create one from the Playlists tab.',
                            style: TextStyle(color: AppTheme.textTertiary),
                          ),
                        ),
                      )
                    else
                      Flexible(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: playlists.length,
                          itemBuilder: (ctx, i) {
                            final pl = playlists[i];
                            return ListTile(
                              leading: const Icon(Icons.queue_music_rounded, color: AppTheme.accent),
                              title: Text(pl.name, style: const TextStyle(color: AppTheme.textPrimary)),
                              onTap: () async {
                                Navigator.of(ctx).pop();
                                final existing = await db.getPlaylistItems(pl.id);
                                if (!existing.any((e) => e.audioItemId == item.id)) {
                                  await db.addToPlaylist(PlaylistItemsCompanion.insert(
                                    id: const Uuid().v4(),
                                    playlistId: pl.id,
                                    audioItemId: item.id,
                                    position: existing.length,
                                  ));
                                }
                                if (mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      backgroundColor: AppTheme.accent,
                                      content: Text(
                                        'Added to "${pl.name}"',
                                        style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                  );
                                }
                              },
                            );
                          },
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final asyncRecs = ref.watch(allRecordingsProvider);
    return asyncRecs.when(
      data: (recs) {
        if (recs.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 88,
                    height: 88,
                    decoration: BoxDecoration(
                      color: Colors.redAccent.withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.redAccent.withValues(alpha: 0.35),
                        width: 2,
                      ),
                    ),
                    child: const Icon(
                      Icons.mic_rounded,
                      color: Colors.redAccent,
                      size: 44,
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Audio Recording Studio',
                    style: TextStyle(
                      color: AppTheme.textPrimary,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Record your voice memos, interviews, musical ideas, or ambient audio directly with high-fidelity AAC.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppTheme.textTertiary,
                      fontSize: 13,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 28),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                      elevation: 4,
                    ),
                    icon: const Icon(Icons.fiber_manual_record_rounded, size: 18),
                    label: const Text(
                      'Start Recording',
                      style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
                    ),
                    onPressed: () => context.push('/recording'),
                  ),
                ],
              ),
            ),
          );
        }

        return Column(
          children: [
            // Top studio banner
            Container(
              margin: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.redAccent.withValues(alpha: 0.15),
                    AppTheme.surfaceHighlight,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Colors.redAccent.withValues(alpha: 0.25),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.redAccent.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.mic_rounded,
                      color: Colors.redAccent,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Voice & Audio Studio',
                          style: TextStyle(
                            color: AppTheme.textPrimary,
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          '${recs.length} recording${recs.length == 1 ? '' : 's'} saved',
                          style: const TextStyle(
                            color: AppTheme.textTertiary,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      elevation: 0,
                    ),
                    icon: const Icon(Icons.fiber_manual_record_rounded, size: 14),
                    label: const Text(
                      'Record',
                      style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                    ),
                    onPressed: () => context.push('/recording'),
                  ),
                ],
              ),
            ),
            // Recordings List
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.only(top: 4, bottom: 80),
                itemCount: recs.length,
                itemBuilder: (ctx, i) {
                  final rec = recs[i];
                  return _SongListTile(
                    item: rec,
                    playlist: recs,
                    onActionSelected: (action) => _handleAction(action, rec),
                  );
                },
              ),
            ),
          ],
        );
      },
      loading: () => const Center(
        child: CircularProgressIndicator(color: AppTheme.accent),
      ),
      error: (e, _) => Center(child: Text('Error: $e')),
    );
  }
}

class _EmptyLibrary extends StatelessWidget {
  const _EmptyLibrary({required this.icon, required this.message});
  final IconData icon;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: AppTheme.textTertiary, size: 56),
          const SizedBox(height: 16),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
                color: AppTheme.textTertiary, fontSize: 14, height: 1.6),
          ),
        ],
      ),
    );
  }
}

class _SongListTile extends ConsumerWidget {
  const _SongListTile({
    required this.item,
    this.playlist,
    this.isSelectionMode = false,
    this.isSelected = false,
    this.onToggleSelect,
    this.onLongPress,
    this.onActionSelected,
  });

  final AudioItem item;
  final List<AudioItem>? playlist;
  final bool isSelectionMode;
  final bool isSelected;
  final VoidCallback? onToggleSelect;
  final VoidCallback? onLongPress;
  final ValueChanged<String>? onActionSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playerState = ref.watch(playerNotifierProvider);
    final isCurrentTrack = playerState.currentItem?.id == item.id;
    final isPlaying = isCurrentTrack && playerState.isPlaying;

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      onTap: () {
        if (isSelectionMode) {
          onToggleSelect?.call();
        } else {
          ref.read(playerNotifierProvider.notifier).playDbItem(item, playlist: playlist);
        }
      },
      onLongPress: () {
        if (isSelectionMode) {
          onToggleSelect?.call();
        } else {
          onLongPress?.call();
        }
      },
      leading: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isSelectionMode)
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected ? AppTheme.accent : Colors.transparent,
                  border: Border.all(
                    color: isSelected ? AppTheme.accent : AppTheme.textTertiary,
                    width: 2,
                  ),
                ),
                child: isSelected
                    ? const Icon(Icons.check_rounded, size: 15, color: Colors.black)
                    : null,
              ),
            ),
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppTheme.surfaceHighlight,
              borderRadius: BorderRadius.circular(AppTheme.radiusSM),
            ),
            child: item.artworkPath != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(AppTheme.radiusSM),
                    child: Image.file(
                      File(item.artworkPath!),
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Icon(
                        isPlaying
                            ? Icons.graphic_eq_rounded
                            : Icons.music_note_rounded,
                        color: isCurrentTrack
                            ? AppTheme.accent
                            : AppTheme.textTertiary,
                        size: 22,
                      ),
                    ),
                  )
                : Icon(
                    isPlaying
                        ? Icons.graphic_eq_rounded
                        : Icons.music_note_rounded,
                    color:
                        isCurrentTrack ? AppTheme.accent : AppTheme.textTertiary,
                    size: 22,
                  ),
          ),
        ],
      ),
      title: Text(
        item.title,
        style: TextStyle(
          color: isCurrentTrack ? AppTheme.accent : AppTheme.textPrimary,
          fontSize: 14,
          fontWeight: isCurrentTrack ? FontWeight.w700 : FontWeight.w500,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        item.artist ?? 'Unknown Artist',
        style: const TextStyle(color: AppTheme.textTertiary, fontSize: 12),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: isSelectionMode
          ? (item.durationMs != null && item.durationMs! > 0
              ? Text(
                  _formatDuration(Duration(milliseconds: item.durationMs!)),
                  style: const TextStyle(color: AppTheme.textTertiary, fontSize: 12),
                )
              : null)
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (item.isLiked)
                  const Padding(
                    padding: EdgeInsets.only(right: 6),
                    child: Icon(Icons.favorite_rounded, color: AppTheme.accent, size: 16),
                  ),
                if (item.durationMs != null && item.durationMs! > 0)
                  Text(
                    _formatDuration(Duration(milliseconds: item.durationMs!)),
                    style: const TextStyle(
                        color: AppTheme.textTertiary, fontSize: 12),
                  ),
                const SizedBox(width: 8),
                Icon(
                  isPlaying ? Icons.pause_circle_filled_rounded : Icons.play_circle_fill_rounded,
                  color: isCurrentTrack ? AppTheme.accent : AppTheme.textTertiary,
                  size: 28,
                ),
                const SizedBox(width: 4),
                PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert_rounded, color: AppTheme.textSecondary, size: 20),
                  color: AppTheme.surface,
                  elevation: 8,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  onSelected: onActionSelected,
                  itemBuilder: (ctx) => [
                    PopupMenuItem(
                      value: 'like',
                      child: Row(
                        children: [
                          Icon(
                            item.isLiked ? Icons.favorite_border_rounded : Icons.favorite_rounded,
                            color: AppTheme.accent,
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Text(item.isLiked ? 'Remove from Liked' : 'Add to Liked'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'playlist',
                      child: Row(
                        children: [
                          Icon(Icons.playlist_add_rounded, color: Colors.blueAccent, size: 20),
                          SizedBox(width: 12),
                          Text('Add to Playlist'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'clip',
                      child: Row(
                        children: [
                          Icon(Icons.content_cut_rounded, color: Colors.purpleAccent, size: 20),
                          SizedBox(width: 12),
                          Text('Create Clip'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'merge',
                      child: Row(
                        children: [
                          Icon(Icons.merge_type_rounded, color: Colors.amberAccent, size: 20),
                          SizedBox(width: 12),
                          Text('Merge Track'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'share',
                      child: Row(
                        children: [
                          Icon(Icons.share_rounded, color: Colors.tealAccent, size: 20),
                          SizedBox(width: 12),
                          Text('Share Audio'),
                        ],
                      ),
                    ),
                    const PopupMenuDivider(),
                    const PopupMenuItem(
                      value: 'remove',
                      child: Row(
                        children: [
                          Icon(Icons.visibility_off_rounded, color: Colors.orangeAccent, size: 20),
                          SizedBox(width: 12),
                          Text('Remove from App'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete_forever_rounded, color: AppTheme.error, size: 20),
                          SizedBox(width: 12),
                          Text('Delete Permanently', style: TextStyle(color: AppTheme.error)),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
    );
  }

  String _formatDuration(Duration d) {
    final m = d.inMinutes;
    final s = d.inSeconds % 60;
    return '$m:${s.toString().padLeft(2, '0')}';
  }
}
