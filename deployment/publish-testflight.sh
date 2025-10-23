#!/bin/bash

# Publish to TestFlight Script
# This script builds, archives, and uploads the app to TestFlight
# Usage: ./publish-testflight.sh [--screenshots]

set -e  # Exit on any error

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# Navigate to project root (parent of deployment folder)
cd "$SCRIPT_DIR/.." || exit 1

echo "🚀 Publishing to TestFlight..."
echo ""

# Check for --screenshots flag
CAPTURE_SCREENSHOTS="n"
if [ "$1" = "--screenshots" ]; then
    CAPTURE_SCREENSHOTS="y"
fi

# Optional: Capture screenshots
if [ "$CAPTURE_SCREENSHOTS" = "y" ]; then
    echo ""
    echo "📸 Launching screenshot capture tool..."
    "$SCRIPT_DIR/capture-screenshots.sh"
    echo ""
    read -r -p "Screenshots captured. Press Enter to continue with build..."
else
    echo "ℹ️  Skipping screenshots (use --screenshots flag to capture)"
    echo ""
fi

# Step 1: Verify leaderboard API accessibility
echo "🔍 Step 1/8: Verifying Firebase Firestore API accessibility..."

# Extract API key from index.html
API_KEY=$(grep -o 'apiKey: "[^"]*"' index.html | sed 's/apiKey: "\(.*\)"/\1/')

if [ -z "$API_KEY" ]; then
  echo "❌ ERROR: Could not find Firebase API key in index.html"
  exit 1
fi

echo "🔑 Found API key: ${API_KEY:0:20}..."

# Test Firestore REST API
echo "📡 Testing Firestore leaderboard endpoint..."
RESPONSE=$(curl -s -w "\n%{http_code}" \
  "https://firestore.googleapis.com/v1/projects/speechtherapy-fa851/databases/(default)/documents/reading_sessions?pageSize=1&key=$API_KEY")

HTTP_CODE=$(echo "$RESPONSE" | tail -n1)
BODY=$(echo "$RESPONSE" | sed '$d')

if [ "$HTTP_CODE" != "200" ]; then
  echo "❌ ERROR: Firestore API returned HTTP $HTTP_CODE"
  echo "Response: $BODY"
  echo ""

  # Check if this is a quota error
  if [ "$HTTP_CODE" = "429" ]; then
    echo "⚠️  QUOTA EXCEEDED: Firebase free tier quota has been exhausted."
    echo ""
    echo "📊 To check your quota usage:"
    echo "  1. Go to https://console.firebase.google.com"
    echo "  2. Select project: speechtherapy-fa851"
    echo "  3. Click 'Firestore Database' → 'Usage' tab"
    echo "     OR click Settings (⚙️) → 'Usage and billing'"
    echo ""
    echo "📋 Firebase Spark Plan (Free) Limits:"
    echo "  • 50,000 document reads per day"
    echo "  • 20,000 document writes per day"
    echo "  • Quota resets daily at midnight Pacific Time"
    echo ""
    echo "Options:"
    echo "  1. Wait for quota to reset (midnight Pacific Time)"
    echo "  2. Upgrade Firebase plan at https://console.firebase.google.com"
    echo "  3. Use SKIP_API_CHECK=1 to bypass this check and deploy anyway"
    echo ""
    echo "Note: If you're deploying a fix that reduces API calls, you may want to"
    echo "      bypass this check to deploy the fix that will prevent future quota issues."
    echo ""
SKIP_API_CHECK="1"
    # Check if user wants to skip the check
    if [ "${SKIP_API_CHECK}" = "1" ]; then
      echo "⚡ SKIP_API_CHECK=1 detected. Bypassing API check and continuing deployment..."
      echo ""
    else
      echo "🚫 Aborting TestFlight deployment. Set SKIP_API_CHECK=1 to bypass."
      exit 1
    fi
  else
    echo "🚫 Leaderboard is not accessible. Aborting TestFlight deployment."
    echo "Please check:"
    echo "  1. Firebase project is active"
    echo "  2. Firestore database exists"
    echo "  3. API key is valid"
    echo "  4. Network connectivity"
    echo ""
    echo "To bypass this check, set SKIP_API_CHECK=1"
    exit 1
  fi
fi

echo "✅ Leaderboard API is accessible (HTTP $HTTP_CODE)"
echo ""

# Step 2: Auto-increment build number
echo "📦 Step 2/8: Auto-incrementing build number..."
"$SCRIPT_DIR/increment-version.sh" build

# Step 3: Update version in HTML
echo ""
echo "🔄 Step 3/8: Updating version info in app..."
"$SCRIPT_DIR/update-app-version.sh"

# Step 4: Sync web files
echo ""
echo "📋 Step 4/8: Syncing web files to iOS..."
mkdir -p www
cp index.html www/index.html
npx cap copy ios
npx cap sync ios

# Step 5: Navigate to iOS project
echo ""
echo "📂 Step 5/8: Navigating to iOS project..."
cd ios/App || exit 1

# Step 6: Clean build
echo ""
echo "🧹 Step 6/8: Cleaning Xcode build..."
xcodebuild -workspace App.xcworkspace -scheme App -configuration Release clean | xcbeautify

# Step 7: Archive the app
echo ""
echo "📦 Step 7/8: Creating archive..."
ARCHIVE_PATH="$HOME/Library/Developer/Xcode/Archives/App-$(date +%Y%m%d-%H%M%S).xcarchive"
xcodebuild -workspace App.xcworkspace \
  -scheme App \
  -configuration Release \
  -archivePath "$ARCHIVE_PATH" \
  -destination 'generic/platform=iOS' \
  archive | xcbeautify

# Step 8: Upload to TestFlight
echo ""
echo "🚢 Step 8/8: Uploading to TestFlight..."
xcodebuild -exportArchive \
  -archivePath "$ARCHIVE_PATH" \
  -exportOptionsPlist exportOptions.plist \
  -exportPath "$HOME/Desktop/App-TestFlight-$(date +%Y%m%d-%H%M%S)"

echo ""
echo "✅ Complete! App uploaded to TestFlight."
echo "📍 Archive location: $ARCHIVE_PATH"
echo ""
echo "Next steps:"
echo "1. Go to App Store Connect: https://appstoreconnect.apple.com"
echo "2. Navigate to TestFlight"
echo "3. Add testers or distribute to groups"
