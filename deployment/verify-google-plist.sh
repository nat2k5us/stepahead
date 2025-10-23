#!/bin/bash

# Script to verify GoogleService-Info.plist has Google Sign-In credentials

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# Navigate to project root (parent of deployment folder)
cd "$SCRIPT_DIR/.." || exit 1

PLIST="ios/App/App/GoogleService-Info.plist"

echo "🔍 Verifying GoogleService-Info.plist for Google Sign-In..."
echo ""

if [ ! -f "$PLIST" ]; then
    echo "❌ GoogleService-Info.plist not found!"
    exit 1
fi

# Check for required keys
REVERSED_CLIENT_ID=$(grep -A1 "REVERSED_CLIENT_ID" "$PLIST" | grep string | sed 's/.*<string>//' | sed 's/<\/string>//')
CLIENT_ID=$(grep -A1 "CLIENT_ID" "$PLIST" | grep string | sed 's/.*<string>//' | sed 's/<\/string>//')
BUNDLE_ID=$(grep -A1 "BUNDLE_ID" "$PLIST" | grep string | sed 's/.*<string>//' | sed 's/<\/string>//')

echo "📦 Bundle ID: $BUNDLE_ID"
echo ""

if [ -n "$REVERSED_CLIENT_ID" ]; then
    echo "✅ REVERSED_CLIENT_ID: ${REVERSED_CLIENT_ID:0:50}..."
else
    echo "❌ REVERSED_CLIENT_ID: MISSING"
    echo "   This is required for Google Sign-In on iOS!"
fi

if [ -n "$CLIENT_ID" ]; then
    echo "✅ CLIENT_ID: ${CLIENT_ID:0:50}..."
else
    echo "❌ CLIENT_ID: MISSING"
    echo "   This is required for Google Sign-In on iOS!"
fi

echo ""

if [ -n "$REVERSED_CLIENT_ID" ] && [ -n "$CLIENT_ID" ]; then
    echo "🎉 GoogleService-Info.plist is ready for Google Sign-In!"
    echo ""
    echo "Next steps:"
    echo "1. Rebuild your iOS app in Xcode"
    echo "2. Try clicking the Google Sign-In button"
    exit 0
else
    echo "⚠️  Please download the updated GoogleService-Info.plist from Firebase Console"
    echo ""
    echo "Steps:"
    echo "1. Go to https://console.firebase.google.com"
    echo "2. Select project: speechtherapy-fa851"
    echo "3. Click Settings (⚙️) → Project settings"
    echo "4. Scroll to 'Your apps' → iOS app"
    echo "5. Download GoogleService-Info.plist"
    echo "6. Replace the file at: ios/App/App/GoogleService-Info.plist"
    exit 1
fi
