import 'package:json_annotation/json_annotation.dart';

part 'settings.g.dart';

enum PasteAction {
  paste,
  pasteWithEnter,
  clipboardOnly
}

enum WhisperModel {
  small,
  medium,
  large,
  largeV3,
  largeV3Turbo
}

enum ComputeDevice {
  auto,
  metal,
  cpu
}

enum ComputeType {
  int8Float16,
  int8Float32,
  float16,
  int8,
  float32
}

enum Language {
  auto,
  english,
  japanese
}

@JsonSerializable()
class Settings {
  // General settings
  final PasteAction defaultAction;
  final bool aiHandoffEnabled;
  final List<String> aiHandoffSequence;
  final int aiHandoffDelay;
  
  // Audio settings
  final String inputDevice;
  final int sampleRate;
  final int chunkSizeMs;
  
  // Model settings
  final WhisperModel model;
  final ComputeDevice device;
  final ComputeType computeType;
  final String modelStoragePath;
  
  // Language settings
  final bool autoDetectLanguage;
  final Language manualLanguage;
  
  // Hotkeys (stored as key combinations)
  final String holdToTalkHotkey;
  final String toggleRecordHotkey;
  final String partialTextPeekHotkey;
  final String partialTextToggleHotkey;
  final String aiHandoffTriggerHotkey;
  
  // Advanced settings
  final String loggingLevel;
  final bool smartCapitalization;
  final bool punctuation;
  final bool disfluencyCleanup;
  final bool pasteWithEnter;
  
  // UI settings
  final bool overlayVisible;
  final double overlayWidth;
  final double overlayHeight;
  final double overlayOpacity;
  
  // Appearance settings
  final double glassBlurRadius;
  final double glassOpacity;
  final String glassEffect; // 'hudWindow', 'sidebar', 'menu', 'popover', 'titlebar'
  final double borderOpacity;
  final bool alwaysOnTop;
  final bool bringToFrontDuringRecording;
  
  const Settings({
    this.defaultAction = PasteAction.paste,
    this.aiHandoffEnabled = false,
    this.aiHandoffSequence = const ['⌥Space', '⌘N', '⌃V', 'Enter'],
    this.aiHandoffDelay = 100,
    
    this.inputDevice = 'default',
    this.sampleRate = 16000,
    this.chunkSizeMs = 30,
    
    this.model = WhisperModel.largeV3Turbo,
    this.device = ComputeDevice.auto,
    this.computeType = ComputeType.int8Float32,
    this.modelStoragePath = '',
    
    this.autoDetectLanguage = true,
    this.manualLanguage = Language.english,
    
    this.holdToTalkHotkey = 'Right ⌥',
    this.toggleRecordHotkey = '⌥⇧R',
    this.partialTextPeekHotkey = '',
    this.partialTextToggleHotkey = '',
    this.aiHandoffTriggerHotkey = '',
    
    this.loggingLevel = 'INFO',
    this.smartCapitalization = true,
    this.punctuation = true,
    this.disfluencyCleanup = true,
    this.pasteWithEnter = false,
    
    this.overlayVisible = true,
    this.overlayWidth = 360.0,
    this.overlayHeight = 100.0,
    this.overlayOpacity = 0.7,
    
    this.glassBlurRadius = 20.0,
    this.glassOpacity = 0.05,
    this.glassEffect = 'hudWindow',
    this.borderOpacity = 0.2,
    this.alwaysOnTop = false,
    this.bringToFrontDuringRecording = false,
  });
  
  factory Settings.fromJson(Map<String, dynamic> json) => _$SettingsFromJson(json);
  Map<String, dynamic> toJson() => _$SettingsToJson(this);
  
  Settings copyWith({
    PasteAction? defaultAction,
    bool? aiHandoffEnabled,
    List<String>? aiHandoffSequence,
    int? aiHandoffDelay,
    String? inputDevice,
    int? sampleRate,
    int? chunkSizeMs,
    WhisperModel? model,
    ComputeDevice? device,
    ComputeType? computeType,
    String? modelStoragePath,
    bool? autoDetectLanguage,
    Language? manualLanguage,
    String? holdToTalkHotkey,
    String? toggleRecordHotkey,
    String? partialTextPeekHotkey,
    String? partialTextToggleHotkey,
    String? aiHandoffTriggerHotkey,
    String? loggingLevel,
    bool? smartCapitalization,
    bool? punctuation,
    bool? disfluencyCleanup,
    bool? pasteWithEnter,
    bool? overlayVisible,
    double? overlayWidth,
    double? overlayHeight,
    double? overlayOpacity,
    double? glassBlurRadius,
    double? glassOpacity,
    String? glassEffect,
    double? borderOpacity,
    bool? alwaysOnTop,
    bool? bringToFrontDuringRecording,
  }) {
    return Settings(
      defaultAction: defaultAction ?? this.defaultAction,
      aiHandoffEnabled: aiHandoffEnabled ?? this.aiHandoffEnabled,
      aiHandoffSequence: aiHandoffSequence ?? this.aiHandoffSequence,
      aiHandoffDelay: aiHandoffDelay ?? this.aiHandoffDelay,
      inputDevice: inputDevice ?? this.inputDevice,
      sampleRate: sampleRate ?? this.sampleRate,
      chunkSizeMs: chunkSizeMs ?? this.chunkSizeMs,
      model: model ?? this.model,
      device: device ?? this.device,
      computeType: computeType ?? this.computeType,
      modelStoragePath: modelStoragePath ?? this.modelStoragePath,
      autoDetectLanguage: autoDetectLanguage ?? this.autoDetectLanguage,
      manualLanguage: manualLanguage ?? this.manualLanguage,
      holdToTalkHotkey: holdToTalkHotkey ?? this.holdToTalkHotkey,
      toggleRecordHotkey: toggleRecordHotkey ?? this.toggleRecordHotkey,
      partialTextPeekHotkey: partialTextPeekHotkey ?? this.partialTextPeekHotkey,
      partialTextToggleHotkey: partialTextToggleHotkey ?? this.partialTextToggleHotkey,
      aiHandoffTriggerHotkey: aiHandoffTriggerHotkey ?? this.aiHandoffTriggerHotkey,
      loggingLevel: loggingLevel ?? this.loggingLevel,
      smartCapitalization: smartCapitalization ?? this.smartCapitalization,
      punctuation: punctuation ?? this.punctuation,
      disfluencyCleanup: disfluencyCleanup ?? this.disfluencyCleanup,
      pasteWithEnter: pasteWithEnter ?? this.pasteWithEnter,
      overlayVisible: overlayVisible ?? this.overlayVisible,
      overlayWidth: overlayWidth ?? this.overlayWidth,
      overlayHeight: overlayHeight ?? this.overlayHeight,
      overlayOpacity: overlayOpacity ?? this.overlayOpacity,
      glassBlurRadius: glassBlurRadius ?? this.glassBlurRadius,
      glassOpacity: glassOpacity ?? this.glassOpacity,
      glassEffect: glassEffect ?? this.glassEffect,
      borderOpacity: borderOpacity ?? this.borderOpacity,
      alwaysOnTop: alwaysOnTop ?? this.alwaysOnTop,
      bringToFrontDuringRecording: bringToFrontDuringRecording ?? this.bringToFrontDuringRecording,
    );
  }
}