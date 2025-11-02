import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';
import 'app_service.dart';

class SettingsWindowService {
  static SettingsWindowService? _instance;
  static SettingsWindowService get instance => _instance ??= SettingsWindowService._();
  SettingsWindowService._();

  bool _isSettingsWindowOpen = false;
  Size? _originalSize;
  Offset? _originalPosition;
  bool? _originalAlwaysOnTop;
  
  bool get isSettingsWindowOpen => _isSettingsWindowOpen;

  Future<void> openSettingsWindow(AppService appService) async {
    if (_isSettingsWindowOpen) {
      return;
    }

    _isSettingsWindowOpen = true;

    // Store current window properties
    await _storeOriginalWindowProperties();
    
    // Configure window for settings
    await _configureSettingsWindow();
  }

  Future<void> _storeOriginalWindowProperties() async {
    try {
      _originalSize = await windowManager.getSize();
      _originalPosition = await windowManager.getPosition();
      _originalAlwaysOnTop = await windowManager.isAlwaysOnTop();
    } catch (e) {
      debugPrint('Error storing window properties: $e');
    }
  }

  Future<void> _configureSettingsWindow() async {
    try {
      // Set window properties for settings
      await windowManager.setSize(const Size(900, 700));
      await windowManager.setMinimumSize(const Size(700, 600));
      await windowManager.center();
      await windowManager.setTitle('UltraWhisper Settings');
      
      // Remove frameless and add title bar
      await windowManager.setTitleBarStyle(TitleBarStyle.normal);
      await windowManager.setBackgroundColor(const Color(0xFF1A1A1A));
      
      // Set window controls
      await windowManager.setResizable(true);
      await windowManager.setClosable(true);
      await windowManager.setMinimizable(true);
      await windowManager.setMaximizable(true);
      await windowManager.setAlwaysOnTop(false);
      
      await windowManager.show();
      await windowManager.focus();
    } catch (e) {
      debugPrint('Error configuring settings window: $e');
    }
  }

  Future<void> closeSettingsWindow() async {
    if (!_isSettingsWindowOpen) return;

    _isSettingsWindowOpen = false;

    // Restore original window properties
    await _restoreOriginalWindowProperties();
  }

  Future<void> _restoreOriginalWindowProperties() async {
    try {
      // Restore original window configuration
      if (_originalSize != null) {
        await windowManager.setSize(_originalSize!);
      }
      
      if (_originalPosition != null) {
        await windowManager.setPosition(_originalPosition!);
      }
      
      if (_originalAlwaysOnTop != null) {
        await windowManager.setAlwaysOnTop(_originalAlwaysOnTop!);
      }
      
      // Restore frameless style
      await windowManager.setAsFrameless();
      await windowManager.setBackgroundColor(Colors.transparent);
      
      await windowManager.show();
    } catch (e) {
      debugPrint('Error restoring window properties: $e');
    }
  }
}