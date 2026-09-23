import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:record/record.dart';

/// Low-level interface to the native audio recorder.
/// Dynamically manages AudioRecorder instances to ensure clean native state
/// across repeated recording sessions.
class RecordingService {
  RecordingService();

  AudioRecorder? _recorder;

  /// Check if microphone permission is granted without prompting.
  Future<bool> hasPermission() async {
    try {
      final rec = _recorder ?? AudioRecorder();
      final hasPerm = await rec.hasPermission();
      if (_recorder == null) {
        await rec.dispose();
      }
      return hasPerm;
    } catch (e) {
      debugPrint('Error checking microphone permission: $e');
      return false;
    }
  }

  /// Start recording to the specified file path in AAC (.m4a) format.
  /// Always cleans up any previous recorder and initializes a fresh instance.
  Future<void> startRecording({required String destinationPath}) async {
    // 1. Ensure any lingering recorder is cleanly closed
    await _cleanupRecorder();

    // 2. Create brand-new recorder session
    final recorder = AudioRecorder();
    _recorder = recorder;

    const config = RecordConfig(
      encoder: AudioEncoder.aacLc,
      bitRate: 128000,
      sampleRate: 44100,
      numChannels: 1, // Mono channel ensures 100% universal Android mic compatibility
    );

    await recorder.start(config, path: destinationPath);
  }

  /// Pause current recording.
  Future<void> pauseRecording() async {
    final rec = _recorder;
    if (rec != null && await rec.isRecording()) {
      await rec.pause();
    }
  }

  /// Resume current recording.
  Future<void> resumeRecording() async {
    final rec = _recorder;
    if (rec != null && await rec.isPaused()) {
      await rec.resume();
    }
  }

  /// Stop recording, release native resources, and return the recorded file path.
  Future<String?> stopRecording() async {
    try {
      final rec = _recorder;
      if (rec == null) return null;
      final path = await rec.stop();
      await _cleanupRecorder();
      return path;
    } catch (e) {
      debugPrint('Error stopping audio recorder: $e');
      await _cleanupRecorder();
      return null;
    }
  }

  /// Cancel and discard ongoing recording.
  Future<void> cancelRecording() async {
    try {
      await _recorder?.cancel();
    } catch (e) {
      debugPrint('Error canceling audio recorder: $e');
    } finally {
      await _cleanupRecorder();
    }
  }

  /// Stream of live audio amplitude (decibels) every 100ms.
  Stream<Amplitude> getAmplitudeStream() {
    final rec = _recorder;
    if (rec == null) return const Stream.empty();
    return rec.onAmplitudeChanged(const Duration(milliseconds: 100));
  }

  Future<bool> isRecording() async {
    final rec = _recorder;
    if (rec == null) return false;
    try {
      return await rec.isRecording();
    } catch (_) {
      return false;
    }
  }

  Future<bool> isPaused() async {
    final rec = _recorder;
    if (rec == null) return false;
    try {
      return await rec.isPaused();
    } catch (_) {
      return false;
    }
  }

  Future<void> _cleanupRecorder() async {
    try {
      final rec = _recorder;
      _recorder = null;
      if (rec != null) {
        await rec.dispose();
      }
    } catch (e) {
      debugPrint('Error disposing AudioRecorder: $e');
    }
  }

  void dispose() {
    _cleanupRecorder();
  }
}
