import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import '../models/settings.dart';
import 'keystroke_service.dart';

class PasteService {
  final KeystrokeService _keystrokeService = KeystrokeService();
  Future<void> performPasteAction(String text, PasteAction action) async {
    try {
      switch (action) {
        case PasteAction.paste:
          await _pasteWithClipboardPreservation(text, false);
          break;
        case PasteAction.pasteWithEnter:
          await _pasteWithClipboardPreservation(text, true);
          break;
        case PasteAction.clipboardOnly:
          await _copyToClipboard(text);
          break;
      }
      debugPrint('Paste action completed: $action');
    } catch (e) {
      debugPrint('Failed to perform paste action: $e');
      throw Exception('Paste action failed: $e');
    }
  }
  
  Future<void> _pasteWithClipboardPreservation(String text, bool pressEnter) async {
    try {
      // 1. Read current clipboard contents
      final originalClipboard = await _getClipboardData();
      debugPrint('Original clipboard: ${originalClipboard?.text}');
      
      // 2. Set transcript to clipboard
      await _copyToClipboard(text);
      debugPrint('Copied transcription to clipboard: $text');
      
      // 3. Check accessibility permissions first
      final hasPermission = await hasAccessibilityPermission();
      debugPrint('Accessibility permission status: $hasPermission');
      
      if (!hasPermission) {
        debugPrint('Accessibility permission not granted - requesting permission');
        try {
          await requestAccessibilityPermission();
          debugPrint('Accessibility permission request completed');
        } catch (e) {
          debugPrint('Failed to request accessibility permission: $e');
        }
      }
      
      // 4. Attempt to send keystrokes via platform channel
      try {
        debugPrint('Attempting to send Cmd+V keystroke...');
        await _keystrokeService.sendKeystroke('cmd+v');
        debugPrint('Successfully sent Cmd+V keystroke');
        
        // 5. Optionally press Enter
        if (pressEnter) {
          await Future.delayed(const Duration(milliseconds: 100)); // Longer delay for production
          debugPrint('Attempting to send Enter keystroke...');
          await _keystrokeService.sendKeystroke('enter');
          debugPrint('Successfully sent Enter keystroke');
        }
        
        // 6. Restore clipboard with proper ordering after successful paste
        _scheduleClipboardRestoreWithOrdering(text, originalClipboard);
        
      } catch (e) {
        debugPrint('Warning: Could not send keystrokes via platform channel: $e');
        debugPrint('Error details: ${e.toString()}');
        
        // Check if it's a permission issue
        if (e.toString().contains('Accessibility permission required')) {
          debugPrint('Permission issue detected - requesting accessibility access');
          try {
            await requestAccessibilityPermission();
          } catch (permError) {
            debugPrint('Failed to request permission: $permError');
          }
        }
        
        debugPrint('Note: Transcription copied to clipboard. User should manually paste with Cmd+V');
        debugPrint('Text ready for pasting: $text');
        
        // Fall back to delayed clipboard restoration for manual pasting
        // Give user more time to paste manually in production
        _scheduleClipboardRestoreForManualPaste(text, originalClipboard);
      }
      
      debugPrint('Clipboard-preserving paste completed');
    } catch (e) {
      debugPrint('Error in clipboard-preserving paste: $e');
      rethrow;
    }
  }
  
  Future<ClipboardData?> _getClipboardData() async {
    try {
      return await Clipboard.getData(Clipboard.kTextPlain);
    } catch (e) {
      debugPrint('Error getting clipboard data: $e');
      return null;
    }
  }
  
  Future<void> _restoreClipboardData(ClipboardData? data) async {
    try {
      if (data != null && data.text != null) {
        await Clipboard.setData(data);
      }
    } catch (e) {
      debugPrint('Error restoring clipboard data: $e');
    }
  }
  
  Future<void> _copyToClipboard(String text) async {
    try {
      await Clipboard.setData(ClipboardData(text: text));
      debugPrint('Successfully copied to clipboard: $text');
    } catch (e) {
      debugPrint('Error copying to clipboard: $e');
      throw Exception('Failed to copy to clipboard: $e');
    }
  }
  
  Future<void> sendKeystroke(String keystroke) async {
    // Delegate to the keystroke service which uses platform channel
    await _keystrokeService.sendKeystroke(keystroke);
  }
  
  Future<void> sendKeySequence(List<String> keystrokes, {int delayMs = 100}) async {
    // Delegate to the keystroke service which handles the sequence and delays
    await _keystrokeService.sendKeySequence(keystrokes, delayMs: delayMs);
  }
  
  void _scheduleClipboardRestore(ClipboardData? originalClipboard) {
    // Restore clipboard after 3 seconds to give user time to paste
    Timer(const Duration(seconds: 3), () async {
      await _restoreClipboardData(originalClipboard);
      debugPrint('Clipboard restored after delay');
    });
  }
  
  void _scheduleClipboardRestoreWithOrdering(String transcribedText, ClipboardData? originalClipboard) {
    // Schedule clipboard restoration with proper ordering:
    // 1. Keep transcribed text accessible for first few seconds
    // 2. Then restore original clipboard as most recent item
    // This allows user to paste transcribed text again within the window
    
    Timer(const Duration(milliseconds: 500), () async {
      // First, restore original clipboard as most recent
      if (originalClipboard != null && originalClipboard.text != null && originalClipboard.text!.isNotEmpty) {
        await _restoreClipboardData(originalClipboard);
        debugPrint('Restored original clipboard as most recent: ${originalClipboard.text}');
        
        // Then immediately put transcribed text back to maintain it in history
        await Future.delayed(const Duration(milliseconds: 50));
        await _copyToClipboard(transcribedText);
        debugPrint('Restored transcribed text to clipboard history');
        
        // Finally, restore original clipboard again to make it the most recent
        await Future.delayed(const Duration(milliseconds: 50));
        await _restoreClipboardData(originalClipboard);
        debugPrint('Final restoration - original clipboard is now most recent');
      }
    });
  }

  void _scheduleClipboardRestoreForManualPaste(String transcribedText, ClipboardData? originalClipboard) {
    // Extended timing for manual paste in production builds
    debugPrint('Scheduling extended clipboard restoration for manual pasting');
    debugPrint('User has 10 seconds to manually paste: $transcribedText');
    
    Timer(const Duration(seconds: 10), () async {
      debugPrint('Manual paste window expired - restoring original clipboard');
      
      if (originalClipboard != null && originalClipboard.text != null && originalClipboard.text!.isNotEmpty) {
        await _restoreClipboardData(originalClipboard);
        debugPrint('Restored original clipboard after manual paste window: ${originalClipboard.text}');
      }
    });
  }
  
  /// Check if accessibility permissions are granted for keystroke sending
  Future<bool> hasAccessibilityPermission() async {
    try {
      return await _keystrokeService.hasAccessibilityPermission();
    } catch (e) {
      debugPrint('Error checking accessibility permission: $e');
      return false;
    }
  }
  
  /// Request accessibility permissions (opens System Preferences)
  Future<void> requestAccessibilityPermission() async {
    try {
      await _keystrokeService.requestAccessibilityPermission();
    } catch (e) {
      debugPrint('Error requesting accessibility permission: $e');
      throw Exception('Failed to request accessibility permission: $e');
    }
  }
}