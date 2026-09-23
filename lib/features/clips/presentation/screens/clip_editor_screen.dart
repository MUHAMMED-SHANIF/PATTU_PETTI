import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class ClipEditorScreen extends StatefulWidget {
  const ClipEditorScreen({super.key, required this.sourceItemId});
  final String sourceItemId;
  @override
  State<ClipEditorScreen> createState() => _ClipEditorScreenState();
}
class _ClipEditorScreenState extends State<ClipEditorScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(title: const Text('Create Clip')),
      body: const Center(child: Text('Waveform clip editor coming in Phase 4', style: TextStyle(color: AppTheme.textTertiary))),
    );
  }
}
