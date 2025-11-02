enum RecordingState {
  idle,
  recording,
  processing,
  error
}

enum AudioSource {
  microphone,
  systemAudio
}

enum CaptureMode {
  holdToTalk,
  toggle
}

class AppState {
  final RecordingState recordingState;
  final AudioSource audioSource;
  final CaptureMode captureMode;
  final String? partialText;
  final String? finalText;
  final String? errorMessage;
  final Duration recordingDuration;
  final double audioLevel;
  final bool isOverlayVisible;
  final bool isPartialTextVisible;
  final bool isSettingsWindowOpen;
  
  const AppState({
    this.recordingState = RecordingState.idle,
    this.audioSource = AudioSource.microphone,
    this.captureMode = CaptureMode.holdToTalk,
    this.partialText,
    this.finalText,
    this.errorMessage,
    this.recordingDuration = Duration.zero,
    this.audioLevel = 0.0,
    this.isOverlayVisible = true,
    this.isPartialTextVisible = false,
    this.isSettingsWindowOpen = false,
  });
  
  AppState copyWith({
    RecordingState? recordingState,
    AudioSource? audioSource,
    CaptureMode? captureMode,
    String? partialText,
    String? finalText,
    String? errorMessage,
    Duration? recordingDuration,
    double? audioLevel,
    bool? isOverlayVisible,
    bool? isPartialTextVisible,
    bool? isSettingsWindowOpen,
  }) {
    return AppState(
      recordingState: recordingState ?? this.recordingState,
      audioSource: audioSource ?? this.audioSource,
      captureMode: captureMode ?? this.captureMode,
      partialText: partialText ?? this.partialText,
      finalText: finalText ?? this.finalText,
      errorMessage: errorMessage ?? this.errorMessage,
      recordingDuration: recordingDuration ?? this.recordingDuration,
      audioLevel: audioLevel ?? this.audioLevel,
      isOverlayVisible: isOverlayVisible ?? this.isOverlayVisible,
      isPartialTextVisible: isPartialTextVisible ?? this.isPartialTextVisible,
      isSettingsWindowOpen: isSettingsWindowOpen ?? this.isSettingsWindowOpen,
    );
  }
}