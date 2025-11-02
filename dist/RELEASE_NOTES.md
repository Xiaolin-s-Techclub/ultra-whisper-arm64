# UltraWhisper v0.3.0 Release Notes

## 🎉 First Public Release

Fast, local-only macOS transcription with Metal GPU acceleration, optimized for Apple Silicon.

---

## 📥 Download

**For Apple Silicon Macs (M1/M2/M3/M4):**

[⬇️ ultra-whisper-arm64-macos-arm64.zip](link-to-release) (1.4 GB)

---

## ✨ What's New

### 🚀 Performance Optimized
- **In-memory model loading** - Model loads once on startup, stays resident in memory
- **Metal GPU acceleration** - Full Apple Silicon optimization
- **Blazing fast** - ~0.35s transcription for 3s audio (after initial ~7s model load)

### 📦 Self-Contained Distribution
- **No dependencies** - Python runtime, libraries, and model all bundled
- **Zero setup** - Unzip and run, no Python installation needed
- **Fully offline** - Works without internet connection

### 🎤 Transcription Features
- **Two capture modes**: Hold-to-talk and toggle record
- **Auto-paste** - Text automatically appears in focused app
- **Multi-language** - Auto-detect or manual selection
- **High accuracy** - Uses Whisper large-v3-turbo model

### 🪟 User Interface
- **Glass/vibrancy overlay** - Beautiful transparent floating window
- **Minimal footprint** - Compact 420×120px overlay
- **Always accessible** - Global hotkeys work from any app

---

## 🔧 Technical Specifications

| Component | Details |
|-----------|---------|
| **Model** | Whisper large-v3-turbo (1.5 GB) |
| **Backend** | whisper.cpp with Metal GPU |
| **Python** | 3.12.12 (bundled) |
| **Frontend** | Flutter (macOS) |
| **Audio** | PCM 16-bit mono, 16kHz |
| **Port** | WebSocket on 127.0.0.1:8082 |

---

## 💻 System Requirements

- macOS 13.0+ (Ventura or later)
- Apple Silicon Mac (M1/M2/M3/M4)
- ~2 GB free disk space
- Microphone and Accessibility permissions

**⚠️ Important:** This build is **ARM64 only**. It will not work on Intel-based Macs.

---

## 📦 Installation

1. Download `ultra-whisper-arm64-macos-arm64.zip`
2. Extract the zip file
3. Drag `ultra-whisper-arm64.app` to Applications folder
4. **First launch**: Right-click → Open (to bypass Gatekeeper)
5. Grant Microphone and Accessibility permissions when prompted

---

## 🎯 Quick Start

1. Launch the app - floating overlay appears
2. Use default hotkeys:
   - **Hold-to-talk**: `⌥Space` (Option + Space)
   - **Toggle record**: `⌘⌥Space` (Cmd + Opt + Space)
3. Speak into your microphone
4. Transcription appears in your focused app

---

## ⚡ Performance Benchmarks

Tested on **Apple M3 Max** with 32 GB RAM:

| Metric | Value |
|--------|-------|
| Model load time | ~7 seconds (once on startup) |
| Transcription (3s audio) | ~0.35 seconds |
| Memory usage | ~1.6 GB (model in VRAM) |
| GPU utilization | Metal GPU via Apple Silicon |

---

## 🔒 Privacy

- **100% local** - All processing happens on your Mac
- **No internet required** - Works completely offline
- **No telemetry** - No analytics or tracking
- **Your data stays yours** - Audio never leaves your device

---

## ⚠️ Known Limitations

- **ARM64 only** - Intel Macs not supported in this release
- **Not code-signed** - Manual "Open" required on first launch
- **No auto-update** - Manual download required for updates
- **macOS 13+ only** - Earlier versions not supported

---

## 🐛 Troubleshooting

### Gatekeeper Warning
**Problem:** "App is damaged and can't be opened"

**Solution:**
1. Right-click on app → Open
2. Click "Open" in the dialog

### Permissions Issues
**Problem:** Microphone or hotkeys not working

**Solution:**
1. System Settings → Privacy & Security
2. Enable Microphone and Accessibility for UltraWhisper

### Port Conflict
**Problem:** "Port already in use" error

**Solution:**
```bash
# Kill any orphaned backend process
pkill -f "server.py.*8082"
```

---

## 📝 What's Included

- ✅ Flutter macOS app (universal binary: arm64 + x86_64)
- ✅ Python 3.12 runtime (bundled, ARM64)
- ✅ whisper.cpp with Metal GPU support (ARM64)
- ✅ Whisper large-v3-turbo model (1.5 GB GGML format)
- ✅ Python dependencies (websockets, numpy)
- ✅ All required frameworks and libraries

**Total size:**
- Uncompressed: 1.76 GB
- Compressed (zip): 1.4 GB

---

## 🛣️ Roadmap

Future improvements being considered:

- Intel Mac support (universal binary for whisper.cpp)
- Code signing and notarization
- Auto-update mechanism
- Additional models (smaller/faster options)
- Homebrew distribution
- More language support

---

## 🙏 Credits

- **Whisper model**: OpenAI
- **whisper.cpp**: ggml-org
- **Flutter**: Google
- **Python**: Python Software Foundation

---

## 📄 License

[Add your license here]

---

## 🐛 Found a Bug?

Please report issues on GitHub with:
- macOS version
- Mac model (M1/M2/M3/M4)
- Steps to reproduce
- Console.app logs (if applicable)

---

**Enjoy fast, private, local transcription on your Mac!** 🎉
