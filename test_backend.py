#!/usr/bin/env python3
"""Test script to verify backend is using Metal GPU and working correctly"""

import sys
import os
import time
import numpy as np

# Add backend to path
sys.path.insert(0, os.path.join(os.path.dirname(__file__), 'backend'))

from whisper_wrapper import WhisperModel

def main():
    print("=" * 60)
    print("Testing GlassyWhisper v3 Backend")
    print("=" * 60)

    # Model path
    model_path = "backend/whisper.cpp/models/ggml-large-v3-turbo.bin"

    if not os.path.exists(model_path):
        print(f"ERROR: Model not found at {model_path}")
        return 1

    print(f"\n1. Loading model: {model_path}")
    print("   (This should take ~2 seconds and show Metal GPU messages)")
    print()

    start_load = time.time()
    model = WhisperModel(model_path, use_gpu=True)
    load_time = time.time() - start_load

    print()
    print(f"✓ Model loaded in {load_time:.2f} seconds")
    print()

    # Generate 3 seconds of test audio (silence)
    print("2. Testing transcription with 3 seconds of silent audio...")
    sample_rate = 16000
    duration = 3.0

    # Create silent audio
    audio = np.zeros(int(sample_rate * duration), dtype=np.float32)

    print(f"   Audio: {len(audio)} samples ({duration}s)")
    print()

    # Test 1: First transcription
    print("3. First transcription (model already loaded):")
    start_t1 = time.time()
    result1 = model.transcribe(audio, language='auto', n_threads=4)
    t1_time = time.time() - start_t1
    print(f"   Time: {t1_time:.3f}s")
    print(f"   Result: '{result1['text']}'")
    print(f"   Language: {result1['language']}")
    print()

    # Test 2: Second transcription (should be fast)
    print("4. Second transcription (testing speed):")
    start_t2 = time.time()
    result2 = model.transcribe(audio, language='auto', n_threads=4)
    t2_time = time.time() - start_t2
    print(f"   Time: {t2_time:.3f}s")
    print(f"   Result: '{result2['text']}'")
    print()

    # Test 3: Third transcription
    print("5. Third transcription:")
    start_t3 = time.time()
    result3 = model.transcribe(audio, language='auto', n_threads=4)
    t3_time = time.time() - start_t3
    print(f"   Time: {t3_time:.3f}s")
    print()

    print("=" * 60)
    print("RESULTS:")
    print("=" * 60)
    print(f"Model load time:     {load_time:.2f}s (one-time cost)")
    print(f"Transcription #1:    {t1_time:.3f}s")
    print(f"Transcription #2:    {t2_time:.3f}s")
    print(f"Transcription #3:    {t3_time:.3f}s")
    print(f"Avg transcription:   {(t1_time + t2_time + t3_time)/3:.3f}s")
    print()

    if load_time < 5:
        print("✓ Load time is good (< 5s)")
    else:
        print("⚠ Load time seems slow (> 5s)")

    avg_trans = (t1_time + t2_time + t3_time) / 3
    if avg_trans < 2:
        print("✓ Transcription speed is FAST (< 2s for 3s audio)")
    elif avg_trans < 5:
        print("⚠ Transcription speed is acceptable (< 5s)")
    else:
        print("✗ Transcription speed is SLOW (> 5s) - something is wrong")

    print()
    print("If you see 'ggml_metal' messages above, Metal GPU is working!")
    print("=" * 60)

    return 0

if __name__ == '__main__':
    sys.exit(main())
