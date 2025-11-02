// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Settings _$SettingsFromJson(Map<String, dynamic> json) => Settings(
  defaultAction:
      $enumDecodeNullable(_$PasteActionEnumMap, json['defaultAction']) ??
      PasteAction.paste,
  aiHandoffEnabled: json['aiHandoffEnabled'] as bool? ?? false,
  aiHandoffSequence:
      (json['aiHandoffSequence'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const ['⌥Space', '⌘N', '⌃V', 'Enter'],
  aiHandoffDelay: (json['aiHandoffDelay'] as num?)?.toInt() ?? 100,
  inputDevice: json['inputDevice'] as String? ?? 'default',
  sampleRate: (json['sampleRate'] as num?)?.toInt() ?? 16000,
  chunkSizeMs: (json['chunkSizeMs'] as num?)?.toInt() ?? 30,
  model:
      $enumDecodeNullable(_$WhisperModelEnumMap, json['model']) ??
      WhisperModel.largeV3,
  device:
      $enumDecodeNullable(_$ComputeDeviceEnumMap, json['device']) ??
      ComputeDevice.auto,
  computeType:
      $enumDecodeNullable(_$ComputeTypeEnumMap, json['computeType']) ??
      ComputeType.int8Float32,
  modelStoragePath: json['modelStoragePath'] as String? ?? '',
  autoDetectLanguage: json['autoDetectLanguage'] as bool? ?? true,
  manualLanguage:
      $enumDecodeNullable(_$LanguageEnumMap, json['manualLanguage']) ??
      Language.english,
  holdToTalkHotkey: json['holdToTalkHotkey'] as String? ?? 'Right ⌥',
  toggleRecordHotkey: json['toggleRecordHotkey'] as String? ?? '⌥⇧R',
  partialTextPeekHotkey: json['partialTextPeekHotkey'] as String? ?? '',
  partialTextToggleHotkey: json['partialTextToggleHotkey'] as String? ?? '',
  aiHandoffTriggerHotkey: json['aiHandoffTriggerHotkey'] as String? ?? '',
  loggingLevel: json['loggingLevel'] as String? ?? 'INFO',
  smartCapitalization: json['smartCapitalization'] as bool? ?? true,
  punctuation: json['punctuation'] as bool? ?? true,
  disfluencyCleanup: json['disfluencyCleanup'] as bool? ?? true,
  pasteWithEnter: json['pasteWithEnter'] as bool? ?? false,
  overlayVisible: json['overlayVisible'] as bool? ?? true,
  overlayWidth: (json['overlayWidth'] as num?)?.toDouble() ?? 360.0,
  overlayHeight: (json['overlayHeight'] as num?)?.toDouble() ?? 100.0,
  overlayOpacity: (json['overlayOpacity'] as num?)?.toDouble() ?? 0.7,
  glassBlurRadius: (json['glassBlurRadius'] as num?)?.toDouble() ?? 20.0,
  glassOpacity: (json['glassOpacity'] as num?)?.toDouble() ?? 0.05,
  glassEffect: json['glassEffect'] as String? ?? 'hudWindow',
  borderOpacity: (json['borderOpacity'] as num?)?.toDouble() ?? 0.2,
  alwaysOnTop: json['alwaysOnTop'] as bool? ?? false,
  bringToFrontDuringRecording:
      json['bringToFrontDuringRecording'] as bool? ?? false,
);

Map<String, dynamic> _$SettingsToJson(Settings instance) => <String, dynamic>{
  'defaultAction': _$PasteActionEnumMap[instance.defaultAction]!,
  'aiHandoffEnabled': instance.aiHandoffEnabled,
  'aiHandoffSequence': instance.aiHandoffSequence,
  'aiHandoffDelay': instance.aiHandoffDelay,
  'inputDevice': instance.inputDevice,
  'sampleRate': instance.sampleRate,
  'chunkSizeMs': instance.chunkSizeMs,
  'model': _$WhisperModelEnumMap[instance.model]!,
  'device': _$ComputeDeviceEnumMap[instance.device]!,
  'computeType': _$ComputeTypeEnumMap[instance.computeType]!,
  'modelStoragePath': instance.modelStoragePath,
  'autoDetectLanguage': instance.autoDetectLanguage,
  'manualLanguage': _$LanguageEnumMap[instance.manualLanguage]!,
  'holdToTalkHotkey': instance.holdToTalkHotkey,
  'toggleRecordHotkey': instance.toggleRecordHotkey,
  'partialTextPeekHotkey': instance.partialTextPeekHotkey,
  'partialTextToggleHotkey': instance.partialTextToggleHotkey,
  'aiHandoffTriggerHotkey': instance.aiHandoffTriggerHotkey,
  'loggingLevel': instance.loggingLevel,
  'smartCapitalization': instance.smartCapitalization,
  'punctuation': instance.punctuation,
  'disfluencyCleanup': instance.disfluencyCleanup,
  'pasteWithEnter': instance.pasteWithEnter,
  'overlayVisible': instance.overlayVisible,
  'overlayWidth': instance.overlayWidth,
  'overlayHeight': instance.overlayHeight,
  'overlayOpacity': instance.overlayOpacity,
  'glassBlurRadius': instance.glassBlurRadius,
  'glassOpacity': instance.glassOpacity,
  'glassEffect': instance.glassEffect,
  'borderOpacity': instance.borderOpacity,
  'alwaysOnTop': instance.alwaysOnTop,
  'bringToFrontDuringRecording': instance.bringToFrontDuringRecording,
};

const _$PasteActionEnumMap = {
  PasteAction.paste: 'paste',
  PasteAction.pasteWithEnter: 'pasteWithEnter',
  PasteAction.clipboardOnly: 'clipboardOnly',
};

const _$WhisperModelEnumMap = {
  WhisperModel.small: 'small',
  WhisperModel.medium: 'medium',
  WhisperModel.large: 'large',
  WhisperModel.largeV3: 'largeV3',
  // WhisperModel.largeV3Turbo: 'largeV3Turbo',
};

const _$ComputeDeviceEnumMap = {
  ComputeDevice.auto: 'auto',
  ComputeDevice.metal: 'metal',
  ComputeDevice.cpu: 'cpu',
};

const _$ComputeTypeEnumMap = {
  ComputeType.int8Float16: 'int8Float16',
  ComputeType.int8Float32: 'int8Float32',
  ComputeType.float16: 'float16',
  ComputeType.int8: 'int8',
  ComputeType.float32: 'float32',
};

const _$LanguageEnumMap = {
  Language.auto: 'auto',
  Language.english: 'english',
  Language.japanese: 'japanese',
};
