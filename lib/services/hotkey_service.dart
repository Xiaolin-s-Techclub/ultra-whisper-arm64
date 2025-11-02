import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:hotkey_manager/hotkey_manager.dart';
import '../utils/logger.dart';

class HotkeyService {
  final Map<String, HotKey> _registeredHotkeys = {};
  
  Future<void> initialize() async {
    AppLogger.hotkey('Initializing HotkeyService...');
    try {
      AppLogger.debug('Unregistering all existing hotkeys...');
      await hotKeyManager.unregisterAll();
      AppLogger.success('Hotkey service initialized successfully');
    } catch (e, stackTrace) {
      AppLogger.error('Failed to initialize hotkey service', e);
      AppLogger.debug('Stack trace: $stackTrace');
    }
  }
  
  Future<void> registerHotkey(
    String keyCombo, {
    VoidCallback? onPressed,
    VoidCallback? onReleased,
  }) async {
    AppLogger.hotkey('Attempting to register hotkey: $keyCombo');
    
    try {
      // Parse the key combination string into HotKey
      AppLogger.debug('Parsing key combination: $keyCombo');
      final hotKey = _parseKeyCombo(keyCombo);
      if (hotKey == null) {
        AppLogger.error('Failed to parse hotkey: $keyCombo');
        return;
      }
      AppLogger.debug('Successfully parsed hotkey: $hotKey');
      
      // Unregister if already exists
      if (_registeredHotkeys.containsKey(keyCombo)) {
        AppLogger.warning('Hotkey $keyCombo already exists, unregistering first...');
        await unregisterHotkey(keyCombo);
      }
      
      // Register the hotkey
      AppLogger.debug('Registering hotkey with hotKeyManager...');
      await hotKeyManager.register(
        hotKey,
        keyDownHandler: onPressed != null ? (hotKey) {
          AppLogger.hotkey('Hotkey $keyCombo key DOWN event fired');
          onPressed();
        } : null,
        keyUpHandler: onReleased != null ? (hotKey) {
          AppLogger.hotkey('Hotkey $keyCombo key UP event fired');
          onReleased();
        } : null,
      );
      
      _registeredHotkeys[keyCombo] = hotKey;
      AppLogger.success('Successfully registered hotkey: $keyCombo');
    } catch (e, stackTrace) {
      AppLogger.error('Failed to register hotkey $keyCombo', e);
      AppLogger.debug('Stack trace: $stackTrace');
    }
  }
  
  Future<void> unregisterHotkey(String keyCombo) async {
    final hotKey = _registeredHotkeys[keyCombo];
    if (hotKey != null) {
      try {
        await hotKeyManager.unregister(hotKey);
        _registeredHotkeys.remove(keyCombo);
        debugPrint('Unregistered hotkey: $keyCombo');
      } catch (e) {
        debugPrint('Failed to unregister hotkey $keyCombo: $e');
      }
    }
  }
  
  Future<void> unregisterAllHotkeys() async {
    try {
      await hotKeyManager.unregisterAll();
      _registeredHotkeys.clear();
      debugPrint('All hotkeys unregistered');
    } catch (e) {
      debugPrint('Failed to unregister all hotkeys: $e');
    }
  }
  
  HotKey? _parseKeyCombo(String keyCombo) {
    AppLogger.debug('Parsing key combo: $keyCombo');
    
    try {
      // First, try to parse as compact format (e.g., "⌥⇧R") which is what HotkeyRecorder outputs
      if (keyCombo.contains('⌥') || keyCombo.contains('⌃') || keyCombo.contains('⌘') || keyCombo.contains('⇧')) {
        AppLogger.debug('Attempting compact format parsing for: $keyCombo');
        final result = _parseCompactKeyCombo(keyCombo);
        if (result != null) {
          return result;
        }
        AppLogger.warning('Compact format parsing failed, falling back to space-separated parsing');
      }
      
      // Special handling for modifier-only combinations like "Right ⌥" or "Left ⌥"
      if (keyCombo == 'Right ⌥' || keyCombo == 'Left ⌥') {
        // For modifier-only hotkeys, use the modifier key itself as the key
        AppLogger.debug('Detected modifier-only hotkey: $keyCombo');
        return HotKey(key: LogicalKeyboardKey.altLeft, modifiers: []);
      }
      
      // Simple parsing for space-separated key combinations
      final parts = keyCombo.split(' ');
      AppLogger.debug('Key combo parts: $parts');
      
      final modifiers = <HotKeyModifier>[];
      LogicalKeyboardKey? key;
      
      for (final part in parts) {
        AppLogger.debug('Processing part: $part');
        
        switch (part.toLowerCase()) {
          case '⌘':
          case 'cmd':
          case 'command':
            modifiers.add(HotKeyModifier.meta);
            AppLogger.debug('Added meta modifier');
            break;
          case '⌥':
          case 'opt':
          case 'option':
          case 'alt':
            modifiers.add(HotKeyModifier.alt);
            AppLogger.debug('Added alt modifier');
            break;
          case '⌃':
          case 'ctrl':
          case 'control':
            modifiers.add(HotKeyModifier.control);
            AppLogger.debug('Added control modifier');
            break;
          case '⇧':
          case 'shift':
            modifiers.add(HotKeyModifier.shift);
            AppLogger.debug('Added shift modifier');
            break;
          case 'right':
          case 'left':
            // Handle "Right ⌥" case - skip "right"/"left" and process next part
            AppLogger.debug('Skipping "$part" modifier prefix');
            continue;
          default:
            // Try to parse as a key
            AppLogger.debug('Attempting to parse as key: $part');
            key = _parseKey(part);
            if (key != null) {
              AppLogger.debug('Successfully parsed key: $key');
            } else {
              AppLogger.warning('Failed to parse key: $part');
            }
            break;
        }
      }
      
      AppLogger.debug('Final modifiers: $modifiers');
      AppLogger.debug('Final key: $key');
      
      if (key != null) {
        final hotKey = HotKey(key: key, modifiers: modifiers);
        AppLogger.success('Successfully created HotKey: $hotKey');
        return hotKey;
      } else if (modifiers.isNotEmpty) {
        // If we have modifiers but no key, use the modifier as the key (for modifier-only hotkeys)
        AppLogger.debug('Using modifier as key for modifier-only hotkey');
        final hotKey = HotKey(key: LogicalKeyboardKey.altLeft, modifiers: []);
        AppLogger.success('Successfully created modifier-only HotKey: $hotKey');
        return hotKey;
      } else {
        AppLogger.error('No valid key found in combo: $keyCombo');
      }
      
      return null;
    } catch (e, stackTrace) {
      AppLogger.error('Error parsing key combo $keyCombo', e);
      AppLogger.debug('Stack trace: $stackTrace');
      return null;
    }
  }
  
  HotKey? _parseCompactKeyCombo(String keyCombo) {
    AppLogger.debug('Parsing compact key combo: $keyCombo');
    
    final modifiers = <HotKeyModifier>[];
    String keyString = keyCombo;
    
    // Extract modifiers iteratively to handle any order
    bool foundModifier = true;
    while (foundModifier && keyString.isNotEmpty) {
      foundModifier = false;
      
      if (keyString.startsWith('⌘')) {
        modifiers.add(HotKeyModifier.meta);
        keyString = keyString.substring(1);
        foundModifier = true;
        AppLogger.debug('Added meta modifier');
      } else if (keyString.startsWith('⌥')) {
        modifiers.add(HotKeyModifier.alt);
        keyString = keyString.substring(1);
        foundModifier = true;
        AppLogger.debug('Added alt modifier');
      } else if (keyString.startsWith('⌃')) {
        modifiers.add(HotKeyModifier.control);
        keyString = keyString.substring(1);
        foundModifier = true;
        AppLogger.debug('Added control modifier');
      } else if (keyString.startsWith('⇧')) {
        modifiers.add(HotKeyModifier.shift);
        keyString = keyString.substring(1);
        foundModifier = true;
        AppLogger.debug('Added shift modifier');
      }
    }
    
    AppLogger.debug('Remaining key string: $keyString');
    AppLogger.debug('Final modifiers: $modifiers');
    
    if (keyString.isNotEmpty) {
      final key = _parseKey(keyString);
      if (key != null) {
        final hotKey = HotKey(key: key, modifiers: modifiers);
        AppLogger.success('Successfully created compact HotKey: $hotKey');
        return hotKey;
      } else {
        AppLogger.error('Failed to parse key from: $keyString');
      }
    } else {
      AppLogger.error('No key found after parsing modifiers from: $keyCombo');
    }
    
    return null;
  }
  
  LogicalKeyboardKey? _parseKey(String keyString) {
    // Handle special cases
    switch (keyString.toLowerCase()) {
      case '⌥':
      case 'option':
        return LogicalKeyboardKey.altLeft;
      case 'r':
        return LogicalKeyboardKey.keyR;
      case 'space':
        return LogicalKeyboardKey.space;
      case 'enter':
        return LogicalKeyboardKey.enter;
      case 'n':
        return LogicalKeyboardKey.keyN;
      case 'v':
        return LogicalKeyboardKey.keyV;
      default:
        // Try to get the key by name
        try {
          if (keyString.length == 1) {
            final char = keyString.toUpperCase();
            switch (char) {
              case 'A': return LogicalKeyboardKey.keyA;
              case 'B': return LogicalKeyboardKey.keyB;
              case 'C': return LogicalKeyboardKey.keyC;
              case 'D': return LogicalKeyboardKey.keyD;
              case 'E': return LogicalKeyboardKey.keyE;
              case 'F': return LogicalKeyboardKey.keyF;
              case 'G': return LogicalKeyboardKey.keyG;
              case 'H': return LogicalKeyboardKey.keyH;
              case 'I': return LogicalKeyboardKey.keyI;
              case 'J': return LogicalKeyboardKey.keyJ;
              case 'K': return LogicalKeyboardKey.keyK;
              case 'L': return LogicalKeyboardKey.keyL;
              case 'M': return LogicalKeyboardKey.keyM;
              case 'N': return LogicalKeyboardKey.keyN;
              case 'O': return LogicalKeyboardKey.keyO;
              case 'P': return LogicalKeyboardKey.keyP;
              case 'Q': return LogicalKeyboardKey.keyQ;
              case 'R': return LogicalKeyboardKey.keyR;
              case 'S': return LogicalKeyboardKey.keyS;
              case 'T': return LogicalKeyboardKey.keyT;
              case 'U': return LogicalKeyboardKey.keyU;
              case 'V': return LogicalKeyboardKey.keyV;
              case 'W': return LogicalKeyboardKey.keyW;
              case 'X': return LogicalKeyboardKey.keyX;
              case 'Y': return LogicalKeyboardKey.keyY;
              case 'Z': return LogicalKeyboardKey.keyZ;
            }
          }
        } catch (e) {
          debugPrint('Error parsing key: $keyString');
        }
        return null;
    }
  }
  
  void dispose() {
    unregisterAllHotkeys();
  }
}