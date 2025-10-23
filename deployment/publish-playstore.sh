#!/bin/bash

# Publish to Google Play Store Script
# This script builds a release APK/AAB and prepares it for Play Store upload

set -e  # Exit on any error

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# Navigate to project root (parent of deployment folder)
cd "$SCRIPT_DIR/.." || exit 1

# Set up Java and Android environment
export JAVA_HOME="/opt/homebrew/opt/openjdk@17"
export ANDROID_HOME="$HOME/Library/Android/sdk"
export PATH="$JAVA_HOME/bin:$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools:$PATH"

echo "🚀 Publishing to Google Play Store..."
echo ""

# Optional: Capture screenshots
read -r -p "Do you want to capture screenshots for Play Store? (y/n): " capture_screenshots
if [ "$capture_screenshots" = "y" ] || [ "$capture_screenshots" = "Y" ]; then
    echo ""
    echo "📸 Launching screenshot capture tool..."
    "$SCRIPT_DIR/capture-screenshots.sh"
    echo ""
    read -r -p "Screenshots captured. Press Enter to continue with build..."
fi

# Step 1: Auto-increment build number
echo "📦 Step 1/7: Auto-incrementing build number..."
"$SCRIPT_DIR/increment-version.sh" build

# Step 2: Update version in HTML
echo ""
echo "🔄 Step 2/7: Updating version info in app..."
"$SCRIPT_DIR/update-app-version.sh"

# Step 3: Sync web files
echo ""
echo "📋 Step 3/7: Syncing web files to Android..."
mkdir -p www
cp index.html www/index.html
npx cap copy android
npx cap sync android

# Step 4: Navigate to Android project
echo ""
echo "📂 Step 4/7: Navigating to Android project..."
cd android || exit 1

# Step 5: Clean build
echo ""
echo "🧹 Step 5/7: Cleaning Android build..."
./gradlew clean

# Step 6: Build release AAB (Android App Bundle - required for Play Store)
echo ""
echo "📦 Step 6/7: Building release AAB..."
./gradlew bundleRelease

# Step 7: Sign the AAB (you need to configure signing in android/app/build.gradle)
echo ""
echo "🔐 Step 7/7: AAB built successfully!"
echo ""

AAB_PATH="app/build/outputs/bundle/release/app-release.aab"

if [ -f "$AAB_PATH" ]; then
    echo "✅ Complete! Release AAB created."
    echo "📍 AAB location: android/$AAB_PATH"
    echo ""
    echo "Next steps:"
    echo "1. Sign your AAB if not auto-signed (see Android documentation)"
    echo "2. Go to Google Play Console: https://play.google.com/console"
    echo "3. Create or select your app"
    echo "4. Go to 'Release' → 'Production' or 'Testing'"
    echo "5. Upload the AAB file: android/$AAB_PATH"
    echo ""
    echo "⚠️  IMPORTANT: Configure signing in android/app/build.gradle first!"
    echo "   See: https://developer.android.com/studio/publish/app-signing"
else
    echo "❌ Error: AAB file not found at $AAB_PATH"
    exit 1
fi
