#!/bin/bash

# Sync Web to Android Script
# This script copies the web files to the Android app bundle

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# Navigate to project root (parent of deployment folder)
cd "$SCRIPT_DIR/.." || exit 1

# Set up Java and Android environment
export JAVA_HOME="/opt/homebrew/opt/openjdk@17"
export ANDROID_HOME="$HOME/Library/Android/sdk"
export PATH="$JAVA_HOME/bin:$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools:$PATH"

echo "🔄 Syncing web files to Android..."

# Update version info in HTML
echo "📦 Updating version info..."
"$SCRIPT_DIR/update-app-version.sh"

echo ""
# Ensure www directory exists and has the latest index.html
echo "📋 Copying index.html to www directory..."
mkdir -p www
cp index.html www/index.html

# Copy and sync to Android
echo "📱 Copying web assets to Android..."
npx cap copy android

echo "🔧 Syncing Android project..."
npx cap sync android

echo ""
echo "🧹 Cleaning Android build..."
cd android
./gradlew clean

echo ""
echo "🔨 Building Android app (debug)..."
./gradlew assembleDebug

echo ""
echo "📦 Installing app on connected device/emulator..."
adb install -r app/build/outputs/apk/debug/app-debug.apk

echo ""
echo "🚀 Launching app..."
# Get the bundle ID from capacitor config
BUNDLE_ID=$(grep -o '"appId": "[^"]*"' capacitor.config.json | cut -d'"' -f4)
if [ -z "$BUNDLE_ID" ]; then
    BUNDLE_ID="com.stepahead.app"
fi
adb shell am start -n $BUNDLE_ID/.MainActivity

echo ""
echo "✅ Complete! App should now be running on the device/emulator."
