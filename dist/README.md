# UltraWhisper v0.3 - macOS ARM64

Fast, local-only macOS transcription utility with Metal GPU acceleration.

## Download

**For Apple Silicon Macs (M1/M2/M3/M4):**
- `ultra-whisper-arm64-macos-arm64.zip` (1.4 GB)

## Features

- 🎤 **Local-only transcription** - Your audio never leaves your Mac
- ⚡ **Metal GPU acceleration** - Optimized for Apple Silicon
- 🚀 **Fast** - ~0.35s transcription time for 3s audio after initial model load
- 🎯 **Two capture modes** - Hold-to-talk and toggle record
- 📋 **Auto-paste** - Automatically pastes into focused app
- 🌍 **Multi-language** - Auto-detect or manual selection (EN/JA and more)
- 🪟 **Glass UI** - Beautiful vibrancy overlay window

## Installation

1. **Download** the zip file
2. **Extract** it (double-click or `unzip ultra-whisper-arm64-macos-arm64.zip`)
3. **Drag** `ultra-whisper-arm64.app` to your Applications folder
4. **First launch**: Right-click → Open (to bypass Gatekeeper warning)
   - macOS will ask "Are you sure?" → Click **Open**
5. **Grant permissions** when prompted:
   - Microphone access (required for recording)
   - Accessibility access (required for global hotkeys and auto-paste)

## System Requirements

- **macOS 13.0+** (Ventura or later)
- **Apple Silicon Mac** (M1/M2/M3/M4)
- **~2 GB** free disk space
- **Microphone** permissions

**Important:** This build is for Apple Silicon Macs only. It will not work on Intel-based Macs.

## Usage

1. **Launch the app** - A floating overlay window appears
2. **Configure hotkeys** - Open Settings to set your preferred keyboard shortcuts
3. **Start recording**:
   - **Hold-to-talk**: Press and hold your hotkey, release when done
   - **Toggle mode**: Press once to start, press again to stop
4. **Transcription** - Text automatically pastes into your focused application

## Default Hotkeys

- **Hold-to-talk**: `⌥Space` (Option + Space)
- **Toggle record**: `⌘⌥Space` (Command + Option + Space)

You can customize these in Settings.

## What's Bundled

✅ **Fully self-contained** - No dependencies required!

- Python 3.12 runtime (bundled)
- whisper.cpp with Metal GPU support
- large-v3-turbo model (1.5 GB)
- All required Python packages (websockets, numpy)

**No Python installation required!** Everything works out of the box.

## Performance

- **First transcription**: ~7 seconds (model loading + transcription)
- **Subsequent transcriptions**: ~0.35 seconds for 3 seconds of audio
- **Model**: Whisper large-v3-turbo (1.5 GB)
- **GPU acceleration**: Metal on Apple Silicon

## Troubleshooting

### "App is damaged and can't be opened"
This is a Gatekeeper warning because the app isn't code-signed.

**Solution:**
1. Right-click (or Ctrl+click) on the app
2. Select "Open"
3. Click "Open" in the dialog

### Microphone not working
1. Go to System Settings → Privacy & Security → Microphone
2. Enable access for UltraWhisper

### Global hotkeys not working
1. Go to System Settings → Privacy & Security → Accessibility
2. Enable access for UltraWhisper

### App won't launch
Check Console.app for error messages:
1. Open Console.app
2. Search for "ultra-whisper-arm64"
3. Look for error messages

## Technical Details

- **Frontend**: Flutter (macOS)
- **Backend**: Python server with whisper.cpp
- **Model**: Whisper large-v3-turbo (GGML format)
- **Communication**: WebSocket (localhost:8082)
- **Audio format**: PCM 16-bit mono, 16kHz

## Known Limitations

- **ARM64 only** - Does not run on Intel Macs
- **Not code-signed** - Requires manual "Open" on first launch
- **macOS 13+** - Older macOS versions not supported
- **Manual updates** - No auto-update mechanism

## Privacy

- All transcription happens **locally on your Mac**
- No internet connection required (after download)
- No telemetry or analytics
- Your audio data never leaves your device

## License

See LICENSE file for details.

## Support

For issues, questions, or feature requests, please open an issue on GitHub.

---

**Built with**: Flutter • Python • whisper.cpp • Metal GPU

**Model**: OpenAI Whisper large-v3-turbo

**Optimized for**: Apple Silicon (M1/M2/M3/M4)
