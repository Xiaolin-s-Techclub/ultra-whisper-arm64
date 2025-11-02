# How to Create GitHub Release

## Step 1: Create Release on GitHub

1. Go to your repository on GitHub
2. Click "Releases" → "Draft a new release"
3. Click "Choose a tag" → Enter `v0.3.0` → "Create new tag: v0.3.0"
4. **Release title**: `UltraWhisper v0.3.0 - Apple Silicon`
5. Copy the contents of `RELEASE_NOTES.md` into the description box
6. Upload `ultra-whisper-arm64-macos-arm64.zip` (drag & drop or click "Attach files")
7. Check "✅ This is a pre-release" (optional, if you want to mark it as beta)
8. Click "Publish release"

## Step 2: Update README Link

After publishing, GitHub will give you a download URL like:
```
https://github.com/YOUR_USERNAME/ultra-whisper-arm64/releases/download/v0.3.0/ultra-whisper-arm64-macos-arm64.zip
```

Copy this URL and update `RELEASE_NOTES.md` to replace `(link-to-release)` with the actual download link.

## Files to Upload

Upload these files to the release:

1. **`ultra-whisper-arm64-macos-arm64.zip`** (1.4 GB)
   - The main application archive

Optional additional files:
- `README.md` - User documentation (can also paste into description)
- SHA256 checksum file (see below)

## Optional: Generate Checksum

For security-conscious users:

```bash
cd dist
shasum -a 256 ultra-whisper-arm64-macos-arm64.zip > ultra-whisper-arm64-macos-arm64.zip.sha256
cat ultra-whisper-arm64-macos-arm64.zip.sha256
```

Include the SHA256 hash in your release notes so users can verify the download.

## Sample Release Description Template

```markdown
# UltraWhisper v0.3.0

Fast, local-only macOS transcription with Metal GPU acceleration.

## Download

**For Apple Silicon Macs (M1/M2/M3/M4):**
- [ultra-whisper-arm64-macos-arm64.zip](ACTUAL_DOWNLOAD_URL_HERE) (1.4 GB)
- SHA256: `[paste checksum here]`

## Installation

1. Download the zip file
2. Extract it
3. Drag `ultra-whisper-arm64.app` to Applications
4. Right-click → Open (first time only)

## Features

- ⚡ Lightning fast transcription (~0.35s for 3s audio)
- 🔒 100% local, no internet required
- 📦 Self-contained, no dependencies
- 🎯 Metal GPU acceleration
- 🎤 Hold-to-talk and toggle modes

## Requirements

- macOS 13.0+
- Apple Silicon Mac (M1/M2/M3/M4)
- ~2 GB disk space

⚠️ **ARM64 only** - Does not work on Intel Macs

[Full release notes below]
```

## Announcement Template

If you want to announce it elsewhere:

```
🎉 UltraWhisper v0.3.0 is out!

Fast, private, local speech-to-text for macOS (Apple Silicon)

✨ Features:
• Lightning fast (~0.35s transcription)
• 100% local & private
• Zero setup - fully bundled
• Metal GPU acceleration
• Beautiful glass UI

Download: [your GitHub releases link]

#macOS #AppleSilicon #AI #Privacy #OpenSource
```

## Tips

1. **Pin the release** - After publishing, you can pin it to show at the top
2. **Mark as latest** - Ensure it's marked as the "Latest" release
3. **Add screenshots** - Consider adding screenshots to the release description
4. **Update repo README** - Link to the release from your main README.md
5. **Add badges** - Consider adding a release badge to your README

Example badge:
```markdown
[![Release](https://img.shields.io/github/v/release/YOUR_USERNAME/ultra-whisper-arm64)](https://github.com/YOUR_USERNAME/ultra-whisper-arm64/releases/latest)
```
