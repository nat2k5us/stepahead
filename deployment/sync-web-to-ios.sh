#!/bin/bash

# Sync Web to iOS Script
# This script copies the web files to the iOS app bundle
# Pass --no-build to skip building and launching (useful when called from other scripts)

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# Navigate to project root (parent of deployment folder)
cd "$SCRIPT_DIR/.." || exit 1

# Check if --no-build flag is passed
NO_BUILD=false
if [ "$1" = "--no-build" ]; then
    NO_BUILD=true
fi

echo "🔄 Syncing web files to iOS..."

# Update version info in HTML
echo "📦 Updating version info..."
"$SCRIPT_DIR/update-app-version.sh"

echo ""
# Ensure www directory exists and has the latest index.html
echo "📋 Copying index.html to www directory..."
mkdir -p www
cp index.html www/index.html

# Copy and sync to iOS
echo "📱 Copying web assets to iOS..."
npx cap copy ios

echo "🔧 Syncing iOS project..."
npx cap sync ios

if [ "$NO_BUILD" = false ]; then
    echo ""
    echo "🧹 Cleaning Xcode build..."
    cd ios/App
    xcodebuild -workspace App.xcworkspace -scheme App -configuration Debug clean | xcbeautify

    echo ""
    echo "🔨 Building iOS app..."
    xcodebuild -workspace App.xcworkspace -scheme App -configuration Debug -sdk iphonesimulator -destination 'platform=iOS Simulator,name=iPhone 16 Pro Max' build | xcbeautify

    echo ""
    echo "🚀 Launching app on simulator..."
    xcrun simctl boot "iPhone 16 Pro Max" 2>/dev/null || echo "Simulator already running"

    # Find the built app in DerivedData (exclude Index.noindex)
    APP_PATH=$(find ~/Library/Developer/Xcode/DerivedData -name "App.app" -path "*/Build/Products/Debug-iphonesimulator/App.app" ! -path "*/Index.noindex/*" 2>/dev/null | head -1)

    if [ -z "$APP_PATH" ]; then
      echo "❌ Error: Could not find App.app in DerivedData/Build/Products"
      echo "   Make sure the build succeeded"
      exit 1
    fi

    echo "📦 Installing app from: $APP_PATH"
    xcrun simctl install booted "$APP_PATH"

    echo "🚀 Launching app..."
    # Get the bundle ID from capacitor config
    BUNDLE_ID=$(grep -o '"appId": "[^"]*"' capacitor.config.json | cut -d'"' -f4)
    if [ -z "$BUNDLE_ID" ]; then
        BUNDLE_ID="com.stepahead.app"
    fi
    echo "📱 Bundle ID: $BUNDLE_ID"
    xcrun simctl launch booted "$BUNDLE_ID"

    echo ""
    echo "✅ Complete! App should now be running on the simulator."
else
    echo ""
    echo "✅ Sync complete! (Build skipped)"
fi