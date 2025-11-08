# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is **UltraWhisper v0.3** - a fast, local-only macOS transcription utility built with Flutter (macOS frontend) + Python backend (faster-whisper/CTranslate2 Metal). The project aims to provide a minimal, glass-like floating UI for voice transcription with two capture modes (press-and-hold, toggle) and automatic pasting into the currently focused app.

**Key Features:**
- Local-only transcription for privacy and offline use
- Flutter macOS app with glass/vibrancy floating overlay window
- Python backend using faster-whisper with Metal GPU acceleration
- WebSocket communication between Flutter app and Python backend
- Two capture modes: hold-to-talk and toggle record
- Automatic paste with clipboard preservation
- Optional AI handoff macro with configurable keystroke sequences
- Multi-language support (EN/JA auto-detect)

## Development Commands

### Flutter Commands
```bash
# Get dependencies
flutter pub get

# Run the app (macOS)
flutter run -d macos

# Build for release
flutter build macos --release

# Analyze code
flutter analyze

# Run tests
flutter test
```

### Backend Development (Python)
```bash
# Set up virtual environment (in backend directory)
python -m venv venv
source venv/bin/activate  # or `venv\Scripts\activate` on Windows

# Install dependencies
pip install -r backend/requirements.txt

# Run backend server
python backend/src/server.py

# Run with UV (if available)
uv venv && uv pip install -r backend/requirements.txt
```

### Testing Commands
```bash
# Run Flutter widget tests
flutter test

# Run Python backend tests (if pytest is configured)
pytest backend/

# Lint Python code (if ruff is configured)
ruff check backend/
```

### Distribution & Verification Commands
```bash
# Build release version
flutter build macos --release

# Verify app is standalone (no external dependencies)
./macos/Scripts/verify_standalone.sh build/macos/Build/Products/Release/UltraWhisper.app

# Create distributable archive
cd build/macos/Build/Products/Release
zip -r UltraWhisper-v0.4.0-macOS.zip UltraWhisper.app
```

See [docs/DISTRIBUTION_TESTING.md](docs/DISTRIBUTION_TESTING.md) for comprehensive testing guide.

## Architecture Overview

### High-Level Structure
- **Frontend**: Flutter macOS app provides UI (menu bar status, floating overlay, settings window)
- **Backend**: Python service using faster-whisper for transcription
- **Communication**: WebSocket connection on localhost with ephemeral ports
- **Audio Processing**: 16kHz PCM audio streaming in 20-40ms chunks
- **Models**: Whisper models (large-v3 default) with Metal GPU acceleration

### Key Components

#### Flutter App Structure
- `lib/main.dart` - Entry point with basic Flutter app template (currently default counter app)
- Platform-specific implementations for macOS, iOS, Android, Linux, Windows, Web
- Future architecture will include:
  - Menu bar status item with state indicators
  - Floating overlay window (420×120px) with glass/vibrancy effect
  - Settings window with tabbed interface
  - Swift plugin for hotkeys and system keystroke injection

#### Backend Architecture (Planned)
- WebSocket server handling audio streaming and transcription requests
- faster-whisper integration with CTranslate2 backend
- Model management and download system
- Audio processing pipeline (16kHz PCM, real-time streaming)
- Post-processing for punctuation, capitalization, disfluency cleanup

### Communication Protocol
- WebSocket messages use JSON envelope format with binary audio chunks
- Commands: `hello`, `start_session`, `audio_chunk` (binary), `end_session`, `cancel`
- Events: `hello_ack`, `partial`, `final`, `error`, `stats`
- Audio format: PCM 16-bit mono, 16kHz, 20-40ms chunks

## Development Setup

### Prerequisites
- Flutter stable SDK with macOS desktop support enabled
- Xcode for macOS development
- Python 3.11+ for backend development
- Optional: UV for Python package management
- Optional: BlackHole 2ch for system audio testing

### First-Time Setup
1. Enable Flutter macOS desktop: `flutter config --enable-macos-desktop`
2. Install dependencies: `flutter pub get`
3. Set up Python backend environment (when backend code exists)
4. Request necessary macOS permissions (Microphone, Accessibility)

### Permissions Required
- **NSMicrophoneUsageDescription**: For audio capture
- **Accessibility**: For global hotkeys and synthetic keystroke generation
- These permissions are configured in macOS-specific Info.plist files

## Project Status

**Current State**: This is a fresh Flutter project with default template code. The comprehensive architecture and features described in the documentation (`docs/Glassy Whisper Docs v0.3.md`) are planned but not yet implemented.

**Next Steps**:
1. Replace default Flutter template with actual UltraWhisper UI components
2. Implement menu bar integration and floating overlay window
3. Create Swift plugin for macOS-specific functionality (hotkeys, accessibility)
4. Develop Python backend with faster-whisper integration
5. Implement WebSocket communication layer
6. Add settings UI and configuration management

## Key Implementation Notes

- Target platform is **macOS 13+ on Apple Silicon** (optimized for M3 Max with 32GB RAM)
- Backend will be packaged as embedded Python runtime inside .app bundle
- Models stored in `~/Library/Application Support/UltraWhisper/models/`
- WebSocket communication on `127.0.0.1` with ephemeral port negotiation
- Clipboard-preserving paste algorithm maintains original clipboard as most recent item
- AI Handoff uses configurable keystroke sequence: `⌥Space → ⌘N → ⌃V → Enter` with 100ms delays

### Standalone Distribution System

The app is **completely self-contained** with no external dependencies:

- **Bundled Python Runtime**: Python 3.12 (arm64) with websockets + numpy (~91 MB)
- **whisper.cpp Libraries**: All GGML libraries with Metal GPU support (~3 MB)
- **Whisper Model**: large-v3-turbo GGML model embedded in app (1.5 GB)
- **Total App Size**: ~1.7 GB

**Build Process** ([macos/Scripts/copy_backend.sh](macos/Scripts/copy_backend.sh)):
1. Copies Python runtime and dependencies into app bundle
2. Copies whisper.cpp libraries (libwhisper, GGML libs, Metal shader)
3. Fixes library install_name paths to use `@loader_path` instead of absolute paths
4. Verifies all critical dependencies are present
5. Sets correct permissions

**Verification** ([macos/Scripts/verify_standalone.sh](macos/Scripts/verify_standalone.sh)):
- Checks all library dependencies use `@rpath`, `@executable_path`, or `@loader_path`
- Verifies no external library dependencies (only system frameworks allowed)
- Confirms all required files are bundled
- Validates code signatures

**Runtime Library Resolution** ([lib/services/backend_service.dart](lib/services/backend_service.dart)):
- Sets `DYLD_LIBRARY_PATH` environment variable to resolve `@rpath` at runtime
- Points to all GGML library locations within the app bundle
- Ensures Python can find libpython3.12.dylib using `@loader_path`

The app works on any macOS 13+ Apple Silicon Mac **without requiring**:
- Xcode or development tools
- Homebrew or package managers
- System Python installation
- Any external library installations

## Configuration Files

- `pubspec.yaml` - Flutter dependencies and project configuration
- `analysis_options.yaml` - Dart/Flutter linting rules using flutter_lints package
- Platform-specific configuration in respective directories (macos/, ios/, android/, etc.)
- Future: Settings will be stored in macOS preferences/UserDefaults