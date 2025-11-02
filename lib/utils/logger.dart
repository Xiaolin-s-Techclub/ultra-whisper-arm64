import 'package:flutter/foundation.dart';

class AppLogger {
  static const bool _debugMode = kDebugMode;
  
  static void debug(String message, [String? tag]) {
    if (_debugMode) {
      final timestamp = DateTime.now().toIso8601String();
      final tagStr = tag != null ? '[$tag] ' : '';
      debugPrint('🐛 $timestamp ${tagStr}DEBUG: $message');
    }
  }
  
  static void info(String message, [String? tag]) {
    if (_debugMode) {
      final timestamp = DateTime.now().toIso8601String();
      final tagStr = tag != null ? '[$tag] ' : '';
      debugPrint('ℹ️ $timestamp ${tagStr}INFO: $message');
    }
  }
  
  static void warning(String message, [String? tag]) {
    if (_debugMode) {
      final timestamp = DateTime.now().toIso8601String();
      final tagStr = tag != null ? '[$tag] ' : '';
      debugPrint('⚠️ $timestamp ${tagStr}WARNING: $message');
    }
  }
  
  static void error(String message, [Object? error, String? tag]) {
    if (_debugMode) {
      final timestamp = DateTime.now().toIso8601String();
      final tagStr = tag != null ? '[$tag] ' : '';
      debugPrint('❌ $timestamp ${tagStr}ERROR: $message');
      if (error != null) {
        debugPrint('   Error details: $error');
      }
    }
  }
  
  static void success(String message, [String? tag]) {
    if (_debugMode) {
      final timestamp = DateTime.now().toIso8601String();
      final tagStr = tag != null ? '[$tag] ' : '';
      debugPrint('✅ $timestamp ${tagStr}SUCCESS: $message');
    }
  }
  
  static void hotkey(String message, [String? tag]) {
    if (_debugMode) {
      final timestamp = DateTime.now().toIso8601String();
      final tagStr = tag != null ? '[$tag] ' : '';
      debugPrint('🔥 $timestamp ${tagStr}HOTKEY: $message');
    }
  }
  
  static void audio(String message, [String? tag]) {
    if (_debugMode) {
      final timestamp = DateTime.now().toIso8601String();
      final tagStr = tag != null ? '[$tag] ' : '';
      debugPrint('🎤 $timestamp ${tagStr}AUDIO: $message');
    }
  }
  
  static void websocket(String message, [String? tag]) {
    if (_debugMode) {
      final timestamp = DateTime.now().toIso8601String();
      final tagStr = tag != null ? '[$tag] ' : '';
      debugPrint('🔌 $timestamp ${tagStr}WEBSOCKET: $message');
    }
  }
}