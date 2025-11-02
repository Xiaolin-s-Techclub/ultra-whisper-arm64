import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import '../utils/logger.dart';

class BackendService {
  Process? _backendProcess;
  int? _port;
  
  Future<void> initialize() async {
    try {
      AppLogger.info('Initializing backend service...');
      await _startBackendProcess();
      AppLogger.success('Backend service initialized on port $_port');
    } catch (e) {
      AppLogger.error('Failed to initialize backend', e);
      throw Exception('Backend initialization failed: $e');
    }
  }
  
  Future<void> _startBackendProcess() async {
    try {
      // Always try to launch the backend process
      // Check if backend is already running on port 8082 (v3 uses 8082, v2 uses 8081)
      if (await _isPortInUse(8082)) {
        AppLogger.debug('Backend already running on port 8082, using existing instance');
        _port = 8082;
        AppLogger.success('Connected to existing backend on port $_port');
        return;
      }

      AppLogger.debug('Starting new backend process...');

      // Production code would launch the embedded backend here
      // Get the path to the backend script
      final backendPath = await _getBackendPath();
      AppLogger.debug('Backend path: $backendPath');

      if (!await File(backendPath).exists()) {
        throw Exception('Backend script not found at: $backendPath');
      }

      // Get the path to Python executable (bundled or system)
      final pythonPath = await _getPythonPath();
      AppLogger.debug('Python path: $pythonPath');

      // Start the Python backend process with fixed port 8082 (v3 uses 8082, v2 uses 8081)
      AppLogger.debug('Starting backend process...');
      _backendProcess = await Process.start(
        pythonPath,
        [backendPath, '--port', '8082', '--host', '127.0.0.1'],
        mode: ProcessStartMode.normal,
      );

      if (_backendProcess == null) {
        throw Exception('Failed to start backend process');
      }

      AppLogger.debug('Backend process started, waiting for port...');

      // Wait for the backend to report its port (should be 8082 for v3)
      _port = await _readPortFromBackend();

      if (_port == null || _port != 8082) {
        throw Exception('Failed to get correct port from backend, expected 8082, got $_port');
      }
      
      AppLogger.success('Backend started successfully on port $_port');
    } catch (e) {
      AppLogger.error('Error starting backend process', e);
      await _cleanup();
      rethrow;
    }
  }
  
  Future<bool> _isPortInUse(int port) async {
    try {
      final socket = await Socket.connect('127.0.0.1', port, timeout: const Duration(seconds: 2));
      await socket.close();
      return true;
    } catch (e) {
      return false;
    }
  }
  
  Future<String> _getBackendPath() async {
    // In development, we'll assume the backend is in a relative path
    // In production, it would be embedded in the app bundle
    if (kDebugMode) {
      // Development path - look for backend relative to project root
      // You may need to adjust this path based on your project location
      final currentDir = Directory.current.path;
      return '$currentDir/backend/server.py';
    } else {
      // Production path - embedded in app bundle
      // Get the path to the executable to determine bundle location
      final executablePath = Platform.resolvedExecutable;
      final executableDir = File(executablePath).parent.path;

      // In a macOS app bundle: Contents/MacOS/executable
      // We need to go to: Contents/Resources/backend/server.py (v3 uses root backend dir)
      final backendPath = '$executableDir/../Resources/backend/server.py';

      AppLogger.debug('Resolved backend path: $backendPath');
      return backendPath;
    }
  }

  Future<String> _getPythonPath() async {
    // Try bundled Python first (for self-contained distribution)
    if (!kDebugMode) {
      // Production: Use bundled Python
      final executablePath = Platform.resolvedExecutable;
      final executableDir = File(executablePath).parent.path;
      final bundledPython = '$executableDir/../Resources/python/bin/python3';

      if (await File(bundledPython).exists()) {
        AppLogger.debug('Using bundled Python: $bundledPython');
        return bundledPython;
      } else {
        AppLogger.warning('Bundled Python not found at $bundledPython, falling back to system Python');
      }
    }

    // Development or fallback: Use system Python
    AppLogger.debug('Using system Python: python3');
    return 'python3';
  }
  
  Future<int?> _readPortFromBackend() async {
    if (_backendProcess == null) return null;
    
    try {
      // Listen to stdout for port information
      final completer = Completer<int?>();
      
      _backendProcess!.stdout
          .transform(utf8.decoder)
          .transform(const LineSplitter())
          .listen((line) {
        AppLogger.debug('Backend stdout: $line');
        
        // Look for port information in the format "SERVER_PORT:8080"
        if (line.startsWith('SERVER_PORT:')) {
          final portStr = line.substring('SERVER_PORT:'.length);
          final port = int.tryParse(portStr);
          if (port != null && !completer.isCompleted) {
            AppLogger.debug('Found backend port: $port');
            completer.complete(port);
          }
        }
      });
      
      _backendProcess!.stderr
          .transform(utf8.decoder)
          .transform(const LineSplitter())
          .listen((line) {
        AppLogger.error('Backend stderr: $line');
      });
      
      // Monitor process exit
      _backendProcess!.exitCode.then((exitCode) {
        AppLogger.error('Backend process exited with code: $exitCode');
        if (!completer.isCompleted) {
          completer.complete(null);
        }
      });
      
      // Timeout after 30 seconds (backend needs time to download models)
      Timer(const Duration(seconds: 30), () {
        if (!completer.isCompleted) {
          AppLogger.error('Timeout waiting for backend port');
          completer.complete(null);
        }
      });
      
      return await completer.future;
    } catch (e) {
      AppLogger.error('Error reading port from backend', e);
      return null;
    }
  }
  
  int? getPort() {
    return _port;
  }
  
  bool get isRunning => _backendProcess != null && _port != null;
  
  Future<void> restart() async {
    AppLogger.info('Restarting backend...');
    await stop();
    await _startBackendProcess();
  }
  
  Future<void> stop() async {
    if (_backendProcess != null) {
      AppLogger.info('Stopping backend process...');
      
      // First try graceful shutdown
      _backendProcess!.kill(ProcessSignal.sigterm);
      
      // Wait for process to exit with timeout
      try {
        await _backendProcess!.exitCode.timeout(const Duration(seconds: 5));
        AppLogger.success('Backend process terminated gracefully');
      } catch (e) {
        // If it doesn't exit gracefully, force kill
        AppLogger.warning('Backend didn\'t respond to SIGTERM, force killing...');
        _backendProcess!.kill(ProcessSignal.sigkill);
        await _backendProcess!.exitCode;
        AppLogger.info('Backend process force killed');
      }
      
      await _cleanup();
    } else {
      AppLogger.debug('No backend process to stop');
    }
  }
  
  Future<void> _cleanup() async {
    _backendProcess = null;
    _port = null;
  }
  
  void dispose() {
    AppLogger.info('Disposing BackendService...');
    // Note: This is called synchronously, backend cleanup should happen in cleanup() method
    if (_backendProcess != null) {
      AppLogger.warning('Backend process still running during dispose, force killing...');
      _backendProcess!.kill(ProcessSignal.sigkill);
    }
  }
}