import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:record/record.dart';

/// Low-level interface to the native audio recorder.
class RecordingService {
  RecordingService() : _recorder = AudioRecorder();

  final AudioRecorder _recorder;

  /// Check if microphone permission is granted without prompting.
  Future<bool> hasPermission() async {
    try {
      return await _recorder.hasPermission();
    } catch (e) {
      debugPrint('Error checking microphone permission: $e');
      return false;
    }
  }

  /// Start recording to the specified file path in AAC (.m4a) format.
  Future<void> startRecording({required String destinationPath}) async {
    const config = RecordConfig(
      encoder: AudioEncoder.aacLc,
      bitRate: 128000,
      sampleRate: 44100,
      numChannels: 2,
    );

    await _recorder.start(config, path: destinationPath);
  }

  /// Pause current recording.
  Future<void> pauseRecording() async {
    if (await _recorder.isRecording()) {
      await _recorder.pause();
    }
  }

  /// Resume current recording.
  Future<void> resumeRecording() async {
    if (await _recorder.isPaused()) {
      await _recorder.resume();
    }
  }

  /// Stop recording and return the recorded file path.
  Future<String?> stopRecording() async {
    try {
      return await _recorder.stop();
    } catch (e) {
      debugPrint('Error stopping audio recorder: $e');
      return null;
    }
  }

  /// Cancel and discard ongoing recording.
  Future<void> cancelRecording() async {
    try {
      await _recorder.cancel();
    } catch (e) {
      debugPrint('Error canceling audio recorder: $e');
    }
  }

  /// Stream of live audio amplitude (decibels) every 100ms.
  Stream<Amplitude> getAmplitudeStream() {
    return _recorder.onAmplitudeChanged(const Duration(milliseconds: 100));
  }

  Future<bool> isRecording() => _recorder.isRecording();
  Future<bool> isPaused() => _recorder.isPaused();

  void dispose() {
    _recorder.dispose();
  }
}
