import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';

class PlaylistsScreen extends ConsumerWidget {
  const PlaylistsScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(title: const Text('Playlists')),
      body: const Center(child: Text('Playlists coming soon', style: TextStyle(color: AppTheme.textTertiary))),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppTheme.accent,
        child: const Icon(Icons.add_rounded, color: Colors.black),
        onPressed: () {},
      ),
    );
  }
}
