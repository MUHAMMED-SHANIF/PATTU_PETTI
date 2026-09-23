import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Keys for secure and regular storage.
class StorageKeys {
  StorageKeys._();

  // Secure storage (sensitive data)
  static const String supabaseSession = 'supabase_session';
  static const String cachedUserId = 'cached_user_id';
  static const String cachedUserRole = 'cached_user_role';
  static const String offlineCredentials = 'offline_credentials';
  static const String cachedUserProfile = 'cached_user_profile';
  static const String lastVerifiedClockMs = 'last_verified_clock_ms';

  // SharedPreferences (non-sensitive)
  static const String lastPlayedItemId = 'last_played_item_id';
  static const String lastPlayedPositionMs = 'last_played_position_ms';
  static const String repeatMode = 'repeat_mode';
  static const String shuffleEnabled = 'shuffle_enabled';
  static const String playbackSpeed = 'playback_speed';
  static const String equalizerPreset = 'equalizer_preset';
  static const String sleepTimerMinutes = 'sleep_timer_minutes';
  static const String hasCompletedOnboarding = 'has_completed_onboarding';
  static const String selectedFolderPaths = 'selected_folder_paths';
  static const String themeMode = 'theme_mode';
  static const String lastScanTime = 'last_scan_time';
}

/// Secure storage service for sensitive data (auth tokens, credentials).
class SecureStorageService {
  SecureStorageService(this._storage);

  final FlutterSecureStorage _storage;

  static const _androidOptions = AndroidOptions(
    encryptedSharedPreferences: true,
  );

  Future<void> write(String key, String value) =>
      _storage.write(key: key, value: value, aOptions: _androidOptions);

  Future<String?> read(String key) =>
      _storage.read(key: key, aOptions: _androidOptions);

  Future<void> delete(String key) =>
      _storage.delete(key: key, aOptions: _androidOptions);

  Future<void> deleteAll() =>
      _storage.deleteAll(aOptions: _androidOptions);

  Future<void> writeJson(String key, Map<String, dynamic> json) =>
      write(key, jsonEncode(json));

  Future<Map<String, dynamic>?> readJson(String key) async {
    final raw = await read(key);
    if (raw == null) return null;
    try {
      return jsonDecode(raw) as Map<String, dynamic>;
    } catch (_) {
      return null;
    }
  }
}

/// Local preferences service for non-sensitive app state.
class LocalPrefsService {
  LocalPrefsService(this._prefs);

  final SharedPreferences _prefs;

  // ─── Generic ─────────────────────────────────────────────
  String? getString(String key) => _prefs.getString(key);
  Future<bool> setString(String key, String value) => _prefs.setString(key, value);

  bool? getBool(String key) => _prefs.getBool(key);
  Future<bool> setBool(String key, bool value) => _prefs.setBool(key, value);

  int? getInt(String key) => _prefs.getInt(key);
  Future<bool> setInt(String key, int value) => _prefs.setInt(key, value);

  double? getDouble(String key) => _prefs.getDouble(key);
  Future<bool> setDouble(String key, double value) => _prefs.setDouble(key, value);

  List<String> getStringList(String key) => _prefs.getStringList(key) ?? [];
  Future<bool> setStringList(String key, List<String> value) =>
      _prefs.setStringList(key, value);

  Future<bool> remove(String key) => _prefs.remove(key);

  // ─── Typed helpers ───────────────────────────────────────
  List<String> get selectedFolderPaths =>
      getStringList(StorageKeys.selectedFolderPaths);

  Future<void> setSelectedFolderPaths(List<String> paths) =>
      setStringList(StorageKeys.selectedFolderPaths, paths);

  bool get hasCompletedOnboarding =>
      getBool(StorageKeys.hasCompletedOnboarding) ?? false;

  Future<void> setOnboardingComplete() =>
      setBool(StorageKeys.hasCompletedOnboarding, true);

  double get playbackSpeed =>
      getDouble(StorageKeys.playbackSpeed) ?? 1.0;

  Future<void> setPlaybackSpeed(double speed) =>
      setDouble(StorageKeys.playbackSpeed, speed);

  String get repeatMode =>
      getString(StorageKeys.repeatMode) ?? 'off';

  Future<void> setRepeatMode(String mode) =>
      setString(StorageKeys.repeatMode, mode);

  bool get shuffleEnabled =>
      getBool(StorageKeys.shuffleEnabled) ?? false;

  Future<void> setShuffleEnabled(bool enabled) =>
      setBool(StorageKeys.shuffleEnabled, enabled);
}
