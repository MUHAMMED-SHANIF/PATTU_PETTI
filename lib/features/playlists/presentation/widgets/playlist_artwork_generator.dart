import 'dart:io';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

/// Renders playlist artwork: custom file image, 2x2 collage of items, or modern gradient.
class PlaylistArtworkWidget extends StatelessWidget {
  const PlaylistArtworkWidget({
    super.key,
    this.artworkPath,
    this.itemArtworkPaths = const [],
    this.size = 64,
    this.borderRadius = 12,
    this.fallbackGradient,
    this.fallbackIcon = Icons.queue_music_rounded,
  });

  final String? artworkPath;
  final List<String> itemArtworkPaths;
  final double size;
  final double borderRadius;
  final List<Color>? fallbackGradient;
  final IconData fallbackIcon;

  @override
  Widget build(BuildContext context) {
    // 1. Explicit artwork file
    if (artworkPath != null && artworkPath!.isNotEmpty) {
      final file = File(artworkPath!);
      if (file.existsSync()) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(borderRadius),
          child: Image.file(
            file,
            width: size,
            height: size,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => _buildFallback(),
          ),
        );
      }
    }

    // 2. Collage if we have 4 or more distinct item artworks
    final validCollage = itemArtworkPaths
        .where((p) => p.isNotEmpty && File(p).existsSync())
        .take(4)
        .toList();

    if (validCollage.length == 4) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: SizedBox(
          width: size,
          height: size,
          child: GridView.count(
            crossAxisCount: 2,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            children: validCollage.map((path) {
              return Image.file(
                File(path),
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(color: AppTheme.surfaceHighlight),
              );
            }).toList(),
          ),
        ),
      );
    }

    // 3. Fallback gradient artwork
    return _buildFallback();
  }

  Widget _buildFallback() {
    final gradient = fallbackGradient ??
        const [
          Color(0xFF2C3E50),
          Color(0xFF000000),
        ];

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        gradient: LinearGradient(
          colors: gradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Center(
        child: Icon(
          fallbackIcon,
          size: size * 0.45,
          color: Colors.white70,
        ),
      ),
    );
  }
}
