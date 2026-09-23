import 'package:permission_handler/permission_handler.dart';
import 'dart:io';

/// Handles all runtime permission requests for Pattu Petti.
/// Requests are just-in-time — we only ask when needed.
class PermissionService {
  PermissionService._();

  /// Request audio/storage permission (Android 13+: READ_MEDIA_AUDIO; older: READ_EXTERNAL_STORAGE)
  static Future<bool> requestAudioPermission() async {
    if (Platform.isAndroid) {
      final status = await Permission.audio.request();
      return status.isGranted;
    }
    if (Platform.isIOS) {
      final status = await Permission.mediaLibrary.request();
      return status.isGranted;
    }
    return true;
  }

  /// Check audio permission without requesting.
  static Future<bool> hasAudioPermission() async {
    if (Platform.isAndroid) return await Permission.audio.isGranted;
    if (Platform.isIOS) return await Permission.mediaLibrary.isGranted;
    return true;
  }

  /// Request microphone permission for recording.
  static Future<bool> requestMicrophonePermission() async {
    final status = await Permission.microphone.request();
    return status.isGranted;
  }

  /// Check microphone permission.
  static Future<bool> hasMicrophonePermission() async {
    return await Permission.microphone.isGranted;
  }

  /// Open app settings when user has permanently denied a permission.
  static Future<void> openSettings() => openAppSettings();

  /// Request notification permission (Android 13+).
  static Future<bool> requestNotificationPermission() async {
    if (Platform.isAndroid) {
      final status = await Permission.notification.request();
      return status.isGranted;
    }
    return true;
  }
}
