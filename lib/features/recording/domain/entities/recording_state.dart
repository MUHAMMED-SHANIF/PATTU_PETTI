enum RecordingStatus {
  idle,
  preparing,
  recording,
  paused,
  stopping,
  preview,
  saving,
  saved,
  error,
}

class RecordingSessionState {
  const RecordingSessionState({
    this.status = RecordingStatus.idle,
    this.duration = Duration.zero,
    this.currentDecibels = -60.0,
    this.recentAmplitudes = const [],
    this.tempFilePath,
    this.finalFilePath,
    this.savedAudioItemId,
    this.errorMessage,
    this.permissionDenied = false,
    this.permissionPermanentlyDenied = false,
    this.trimStartMs,
    this.trimEndMs,
  });

  final RecordingStatus status;
  final Duration duration;
  final double currentDecibels;
  final List<double> recentAmplitudes;
  final String? tempFilePath;
  final String? finalFilePath;
  final String? savedAudioItemId;
  final String? errorMessage;
  final bool permissionDenied;
  final bool permissionPermanentlyDenied;
  final int? trimStartMs;
  final int? trimEndMs;

  bool get isRecording => status == RecordingStatus.recording;
  bool get isPaused => status == RecordingStatus.paused;
  bool get isIdle => status == RecordingStatus.idle;
  bool get isPreview => status == RecordingStatus.preview;
  bool get isSaving => status == RecordingStatus.saving;
  bool get isSaved => status == RecordingStatus.saved;
  bool get isError => status == RecordingStatus.error;

  RecordingSessionState copyWith({
    RecordingStatus? status,
    Duration? duration,
    double? currentDecibels,
    List<double>? recentAmplitudes,
    String? tempFilePath,
    String? finalFilePath,
    String? savedAudioItemId,
    String? errorMessage,
    bool? permissionDenied,
    bool? permissionPermanentlyDenied,
    int? trimStartMs,
    int? trimEndMs,
    bool clearError = false,
  }) {
    return RecordingSessionState(
      status: status ?? this.status,
      duration: duration ?? this.duration,
      currentDecibels: currentDecibels ?? this.currentDecibels,
      recentAmplitudes: recentAmplitudes ?? this.recentAmplitudes,
      tempFilePath: tempFilePath ?? this.tempFilePath,
      finalFilePath: finalFilePath ?? this.finalFilePath,
      savedAudioItemId: savedAudioItemId ?? this.savedAudioItemId,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      permissionDenied: permissionDenied ?? this.permissionDenied,
      permissionPermanentlyDenied:
          permissionPermanentlyDenied ?? this.permissionPermanentlyDenied,
      trimStartMs: trimStartMs ?? this.trimStartMs,
      trimEndMs: trimEndMs ?? this.trimEndMs,
    );
  }
}
