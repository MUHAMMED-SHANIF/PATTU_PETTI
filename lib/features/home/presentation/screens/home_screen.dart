import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../features/library/presentation/providers/library_provider.dart';
import '../../../../features/auth/presentation/providers/auth_provider.dart';
import '../../../../features/player/presentation/providers/player_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    final user = authState.valueOrNull?.user;

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: CustomScrollView(
        slivers: [
          // ─── Header ───────────────────────────────────────
          SliverAppBar(
            expandedHeight: 120,
            pinned: true,
            backgroundColor: AppTheme.background,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                'Good ${_greeting()},',
                style: const TextStyle(
                  color: AppTheme.textSecondary,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
              titlePadding: const EdgeInsets.only(left: 20, bottom: 44),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.add_rounded, color: AppTheme.accent),
                tooltip: 'Add Music',
                onPressed: () => context.go('/library'),
              ),
              IconButton(
                icon: const Icon(Icons.notifications_outlined),
                onPressed: () => context.push('/notifications'),
              ),
              IconButton(
                icon: const Icon(Icons.settings_outlined),
                onPressed: () => context.push('/settings'),
              ),
            ],
          ),

          // ─── Greeting with username ───────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
              child: Text(
                user?.displayNameOrUsername ?? 'there! 👋',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
            ),
          ),

          // ─── Quick Access ─────────────────────────────────
          SliverToBoxAdapter(
            child: _QuickAccessGrid(
              items: const [
                _QuickItem(icon: Icons.favorite_rounded, label: 'Liked Songs', path: '/library?tab=liked', color: Color(0xFFE91E63)),
                _QuickItem(icon: Icons.access_time_rounded, label: 'Recently Played', path: '/library?tab=recent', color: Color(0xFF1DB954)),
                _QuickItem(icon: Icons.content_cut_rounded, label: 'Clips', path: '/library?tab=clips', color: Color(0xFF8B6914)),
                _QuickItem(icon: Icons.mic_rounded, label: 'Recordings', path: '/library?tab=recordings', color: Color(0xFF2196F3)),
                _QuickItem(icon: Icons.merge_type_rounded, label: 'Merged', path: '/library?tab=merged', color: Color(0xFF9C27B0)),
                _QuickItem(icon: Icons.star_rounded, label: 'Starred', path: '/library?tab=starred', color: Color(0xFFF9A825)),
              ],
            ),
          ),

          // ─── Recently Played ──────────────────────────────
          _SectionHeader(
            title: 'Recently Played',
            onSeeAll: () => context.push('/library?tab=recent'),
          ),
          const _RecentlyPlayedList(),

          // ─── Recently Added ───────────────────────────────
          _SectionHeader(
            title: 'Recently Added',
            onSeeAll: () => context.push('/library'),
          ),
          const _RecentlyAddedList(),

          // Bottom padding for mini player
          const SliverToBoxAdapter(child: SizedBox(height: 16)),
        ],
      ),
    );
  }

  String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'morning';
    if (hour < 17) return 'afternoon';
    return 'evening';
  }
}

class _QuickAccessGrid extends StatelessWidget {
  const _QuickAccessGrid({required this.items});
  final List<_QuickItem> items;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          childAspectRatio: 3.5,
        ),
        itemCount: items.length,
        itemBuilder: (ctx, i) {
          final item = items[i];
          return GestureDetector(
            onTap: () => context.push(item.path),
            child: Container(
              decoration: BoxDecoration(
                color: AppTheme.cardColor,
                borderRadius: BorderRadius.circular(AppTheme.radiusSM),
              ),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: double.infinity,
                    decoration: BoxDecoration(
                      color: item.color,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(AppTheme.radiusSM),
                        bottomLeft: Radius.circular(AppTheme.radiusSM),
                      ),
                    ),
                    child: Icon(item.icon, color: Colors.white, size: 22),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      item.label,
                      style: const TextStyle(
                        color: AppTheme.textPrimary,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _QuickItem {
  const _QuickItem({
    required this.icon,
    required this.label,
    required this.path,
    required this.color,
  });
  final IconData icon;
  final String label;
  final String path;
  final Color color;
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, this.onSeeAll});
  final String title;
  final VoidCallback? onSeeAll;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 24, 12, 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleLarge),
            if (onSeeAll != null)
              TextButton(
                onPressed: onSeeAll,
                child: const Text('See all', style: TextStyle(fontSize: 13)),
              ),
          ],
        ),
      ),
    );
  }
}

class _RecentlyPlayedList extends ConsumerWidget {
  const _RecentlyPlayedList();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncItems = ref.watch(recentlyPlayedProvider);

    return SliverToBoxAdapter(
      child: SizedBox(
        height: 160,
        child: asyncItems.when(
          data: (items) {
            if (items.isEmpty) {
              return const Center(
                child: Text(
                  'Start listening to see your history',
                  style: TextStyle(color: AppTheme.textTertiary, fontSize: 13),
                ),
              );
            }
            return ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: items.length,
              itemBuilder: (ctx, i) => _AudioItemCard(item: items[i]),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(
            child: Text('Error: $e', style: const TextStyle(color: AppTheme.error)),
          ),
        ),
      ),
    );
  }
}

class _RecentlyAddedList extends ConsumerWidget {
  const _RecentlyAddedList();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncItems = ref.watch(recentlyAddedProvider);

    return SliverToBoxAdapter(
      child: SizedBox(
        height: 160,
        child: asyncItems.when(
          data: (items) {
            if (items.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.library_music_outlined,
                        color: AppTheme.textTertiary, size: 36),
                    const SizedBox(height: 8),
                    const Text(
                      'No music added yet',
                      style: TextStyle(color: AppTheme.textTertiary, fontSize: 13),
                    ),
                    const SizedBox(height: 6),
                    TextButton.icon(
                      icon: const Icon(Icons.add_rounded, size: 16),
                      label: const Text('Add Songs or Folders'),
                      style: TextButton.styleFrom(foregroundColor: AppTheme.accent),
                      onPressed: () => context.go('/library'),
                    ),
                  ],
                ),
              );
            }
            return ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: items.length,
              itemBuilder: (ctx, i) => _AudioItemCard(item: items[i]),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => const SizedBox.shrink(),
        ),
      ),
    );
  }
}

class _AudioItemCard extends ConsumerWidget {
  const _AudioItemCard({required this.item});
  final dynamic item; // AudioItemEntity or AudioItem

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () {
        ref.read(playerNotifierProvider.notifier).playDbItem(item);
      },
      child: Container(
        width: 120,
        margin: const EdgeInsets.only(right: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Artwork
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: AppTheme.surfaceHighlight,
                borderRadius: BorderRadius.circular(AppTheme.radiusMD),
              ),
              child: item.artworkPath != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(AppTheme.radiusMD),
                      child: Image.file(
                        File(item.artworkPath as String),
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) =>
                            const Icon(Icons.music_note_rounded,
                                color: AppTheme.textTertiary, size: 40),
                      ),
                    )
                  : const Icon(Icons.music_note_rounded,
                      color: AppTheme.textTertiary, size: 40),
            ),
            const SizedBox(height: 6),
            Text(
              (item.title as String?) ?? 'Unknown',
              style: const TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              (item.artist as String?) ?? 'Unknown Artist',
              style: const TextStyle(color: AppTheme.textTertiary, fontSize: 11),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
