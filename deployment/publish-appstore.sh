#!/bin/bash

# Publish to App Store Script
# This script builds, archives, and uploads the app to the App Store for review

set -e  # Exit on any error

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# Navigate to project root (parent of deployment folder)
cd "$SCRIPT_DIR/.." || exit 1

echo "🏪 Publishing to App Store..."
echo ""

# Step 1: Auto-increment build number
echo "📦 Step 1/7: Auto-incrementing build number..."
"$SCRIPT_DIR/increment-version.sh" build

# Step 2: Update version in HTML
echo ""
echo "🔄 Step 2/7: Updating version info in app..."
"$SCRIPT_DIR/update-app-version.sh"

# Step 3: Sync web files
echo ""
echo "📋 Step 3/7: Syncing web files to iOS..."
mkdir -p www
cp index.html www/index.html
npx cap copy ios
npx cap sync ios

# Step 4: Navigate to iOS project
echo ""
echo "📂 Step 4/7: Navigating to iOS project..."
cd ios/App || exit 1

# Step 5: Clean build
echo ""
echo "🧹 Step 5/7: Cleaning Xcode build..."
xcodebuild -workspace App.xcworkspace -scheme App -configuration Release clean | xcbeautify

# Step 6: Archive the app
echo ""
echo "📦 Step 6/7: Creating archive..."
ARCHIVE_PATH="$HOME/Library/Developer/Xcode/Archives/App-AppStore-$(date +%Y%m%d-%H%M%S).xcarchive"
xcodebuild -workspace App.xcworkspace \
  -scheme App \
  -configuration Release \
  -archivePath "$ARCHIVE_PATH" \
  -destination 'generic/platform=iOS' \
  archive | xcbeautify

# Step 7: Export and upload to App Store
echo ""
echo "🚢 Step 7/7: Uploading to App Store..."
EXPORT_PATH="$HOME/Desktop/App-AppStore-$(date +%Y%m%d-%H%M%S)"
xcodebuild -exportArchive \
  -archivePath "$ARCHIVE_PATH" \
  -exportOptionsPlist exportOptionsAppStore.plist \
  -exportPath "$EXPORT_PATH"

echo ""
echo "📤 Uploading to App Store Connect..."
xcrun altool --upload-app \
  --type ios \
  --file "$EXPORT_PATH/App.ipa" \
  --username "YOUR_APPLE_ID@example.com" \
  --password "@keychain:AC_PASSWORD"

echo ""
echo "✅ Complete! App uploaded to App Store Connect."
echo "📍 Archive location: $ARCHIVE_PATH"
echo "📍 IPA location: $EXPORT_PATH"
echo ""
echo "Next steps:"
echo "1. Go to App Store Connect: https://appstoreconnect.apple.com"
echo "2. Navigate to your app"
echo "3. Submit for review"
echo ""
echo "NOTE: Update the Apple ID and password in this script before first use."
