// Application-wide constants for Pattu Petti.
// No hardcoded user IDs, roles, or feature keys that bypass the DB.

class AppConstants {
  AppConstants._();

  // ─── App Info ────────────────────────────────────────────────────────────
  static const String appName = 'Pattu Petti';
  static const String appVersion = '1.0.0';

  // ─── Local Storage Folders ───────────────────────────────────────────────
  static const String folderSongs = 'PattuPetti/Songs';
  static const String folderClips = 'PattuPetti/Clips';
  static const String folderMerged = 'PattuPetti/Merged';
  static const String folderDownloads = 'PattuPetti/Downloads';
  static const String folderRecordings = 'PattuPetti/Recordings';
  static const String folderArtwork = 'PattuPetti/Artwork';
  static const String folderCache = 'PattuPetti/Cache';

  // ─── Supported Audio Extensions ─────────────────────────────────────────
  static const List<String> supportedAudioExtensions = [
    'mp3',
    'aac',
    'm4a',
    'flac',
    'wav',
    'ogg',
    'opus',
    'aiff',
    'alac',
  ];

  // ─── Clip Precision ─────────────────────────────────────────────────────
  /// Minimum step in milliseconds for clip timestamps (0.1 second)
  static const int clipPrecisionMs = 100;

  // ─── Merge Transitions ──────────────────────────────────────────────────
  static const int mergeFadeMs = 500;

  // ─── Playback ────────────────────────────────────────────────────────────
  static const List<double> playbackSpeeds = [0.5, 0.75, 1.0, 1.25, 1.5, 2.0];

  // ─── Sleep Timer Options (minutes, -1 = end of song, -2 = end of playlist)
  static const List<int> sleepTimerMinutes = [5, 10, 15, 30, 45, 60, -1, -2];

  // ─── Username Rules ──────────────────────────────────────────────────────
  static const int usernameMinLength = 3;
  static const int usernameMaxLength = 30;
  static const String usernamePattern = r'^[a-zA-Z0-9_]+$';

  // ─── Roles (must match DB values, never hardcoded in logic) ─────────────
  static const String roleAdmin = 'admin';
  static const String roleNormal = 'normal';
  static const String rolePrivileged = 'privileged';

  // ─── Feature Keys (must match feature_flags table) ───────────────────────
  static const String featureUpload = 'upload';
  static const String featureDownload = 'download';
  static const String featureCreateClips = 'create_clips';
  static const String featureNestedClips = 'nested_clips';
  static const String featureMerge = 'merge';
  static const String featurePlaylists = 'playlists';
  static const String featureSharing = 'sharing';
  static const String featureCloudSync = 'cloud_sync';
  static const String featurePublicUpload = 'public_upload';
  static const String featureRecording = 'recording';
  static const String featurePremiumFeatures = 'premium_features';
  static const String featurePublicLibrary = 'public_library';
  static const String featureRegistration = 'registration';
  static const String featureMaintenance = 'maintenance_mode';

  // ─── Pagination ──────────────────────────────────────────────────────────
  static const int defaultPageSize = 50;
  static const int searchPageSize = 30;

  // ─── Queue ───────────────────────────────────────────────────────────────
  static const int maxQueueSize = 1000;

  // ─── Storage ─────────────────────────────────────────────────────────────
  static const int lowStorageThresholdBytes = 100 * 1024 * 1024; // 100MB

  // ─── Cache ───────────────────────────────────────────────────────────────
  static const Duration artworkCacheDuration = Duration(days: 30);
  static const int maxArtworkCacheMB = 200;
}
