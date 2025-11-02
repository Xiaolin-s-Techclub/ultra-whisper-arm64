import 'package:flutter/services.dart';

class KeystrokeService {
  static const MethodChannel _channel = MethodChannel('com.glassywhisper.keystroke');
  
  /// Send a keystroke sequence to the system
  /// 
  /// Examples:
  /// - 'cmd+v' for Command+V
  /// - 'cmd+shift+n' for Command+Shift+N  
  /// - 'enter' for Enter key
  /// - 'space' for Space key
  Future<void> sendKeystroke(String keystroke) async {
    try {
      await _channel.invokeMethod('sendKeystroke', {'keystroke': keystroke});
    } on PlatformException catch (e) {
      throw Exception('Failed to send keystroke: ${e.message}');
    }
  }
  
  /// Send a sequence of keystrokes with delays between them
  Future<void> sendKeySequence(List<String> keystrokes, {int delayMs = 100}) async {
    try {
      await _channel.invokeMethod('sendKeySequence', {
        'keystrokes': keystrokes,
        'delayMs': delayMs,
      });
    } on PlatformException catch (e) {
      throw Exception('Failed to send key sequence: ${e.message}');
    }
  }
  
  /// Check if the service has the required accessibility permissions
  Future<bool> hasAccessibilityPermission() async {
    try {
      final result = await _channel.invokeMethod('hasAccessibilityPermission');
      return result as bool;
    } on PlatformException catch (e) {
      throw Exception('Failed to check accessibility permission: ${e.message}');
    }
  }
  
  /// Request accessibility permissions (opens System Preferences)
  Future<void> requestAccessibilityPermission() async {
    try {
      await _channel.invokeMethod('requestAccessibilityPermission');
    } on PlatformException catch (e) {
      throw Exception('Failed to request accessibility permission: ${e.message}');
    }
  }
}