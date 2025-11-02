#!/bin/bash

# This script copies the backend (whisper.cpp + Python server) into the macOS app bundle
# during the build process for v3.

set -e

echo "Copying backend to app bundle (v3 - whisper.cpp)..."

# The Flutter build sets these environment variables
BUNDLE_RESOURCES="${BUILT_PRODUCTS_DIR}/${PRODUCT_NAME}.app/Contents/Resources"
PROJECT_DIR="${SRCROOT}/../"

# Create backend directory in Resources
mkdir -p "${BUNDLE_RESOURCES}/backend"

# Copy the Python server and wrapper
echo "Copying backend/server.py..."
cp -f "${PROJECT_DIR}/backend/server.py" "${BUNDLE_RESOURCES}/backend/"

echo "Copying backend/whisper_wrapper.py..."
cp -f "${PROJECT_DIR}/backend/whisper_wrapper.py" "${BUNDLE_RESOURCES}/backend/"

echo "Copying backend/requirements.txt..."
cp -f "${PROJECT_DIR}/backend/requirements.txt" "${BUNDLE_RESOURCES}/backend/"

# Copy whisper.cpp library (NEW - for in-memory transcription)
echo "Copying libwhisper.dylib..."
mkdir -p "${BUNDLE_RESOURCES}/backend/whisper.cpp/build/src"
cp -f "${PROJECT_DIR}/backend/whisper.cpp/build/src/libwhisper.dylib" "${BUNDLE_RESOURCES}/backend/whisper.cpp/build/src/"
cp -f "${PROJECT_DIR}/backend/whisper.cpp/build/src/libwhisper.1.dylib" "${BUNDLE_RESOURCES}/backend/whisper.cpp/build/src/"
cp -f "${PROJECT_DIR}/backend/whisper.cpp/build/src/libwhisper.1.8.2.dylib" "${BUNDLE_RESOURCES}/backend/whisper.cpp/build/src/"

echo "Copying whisper.cpp models (turbo only)..."
mkdir -p "${BUNDLE_RESOURCES}/backend/whisper.cpp/models"
cp -f "${PROJECT_DIR}/backend/whisper.cpp/models/ggml-large-v3-turbo.bin" "${BUNDLE_RESOURCES}/backend/whisper.cpp/models/"

# Copy bundled Python runtime (NEW - self-contained distribution)
echo "Copying bundled Python runtime..."
if [ -d "${PROJECT_DIR}/backend/python_bundle/python" ]; then
    mkdir -p "${BUNDLE_RESOURCES}/python"
    cp -R "${PROJECT_DIR}/backend/python_bundle/python/"* "${BUNDLE_RESOURCES}/python/"
    echo "Bundled Python copied successfully"
else
    echo "WARNING: Bundled Python not found at ${PROJECT_DIR}/backend/python_bundle/python"
    echo "App will require system Python installation"
fi

# Make server.py executable
chmod +x "${BUNDLE_RESOURCES}/backend/server.py"

echo "Backend v3 copied successfully to: ${BUNDLE_RESOURCES}/backend/"
