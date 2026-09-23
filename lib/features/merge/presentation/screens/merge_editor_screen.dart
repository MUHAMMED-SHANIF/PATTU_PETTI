import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class MergeEditorScreen extends StatelessWidget {
  const MergeEditorScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(title: const Text('Merge Tracks')),
      body: const Center(child: Text('Merge editor coming in Phase 6', style: TextStyle(color: AppTheme.textTertiary))),
    );
  }
}
