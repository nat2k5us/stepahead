#!/bin/bash

# Script to verify OAuth configuration for iOS app

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# Navigate to project root (parent of deployment folder)
cd "$SCRIPT_DIR/.." || exit 1

echo "🔍 Verifying OAuth Configuration for iOS..."
echo "=============================================="
echo ""

# 1. Check GoogleService-Info.plist
echo "1️⃣ Checking GoogleService-Info.plist..."
PLIST_PATH="ios/App/App/GoogleService-Info.plist"

if [ ! -f "$PLIST_PATH" ]; then
    echo "   ❌ GoogleService-Info.plist not found!"
    exit 1
fi

REVERSED_CLIENT_ID=$(grep -A1 "REVERSED_CLIENT_ID" "$PLIST_PATH" | grep string | sed 's/.*<string>//' | sed 's/<\/string>//' | tr -d '\t')
CLIENT_ID=$(grep -A1 "CLIENT_ID" "$PLIST_PATH" | grep string | sed 's/.*<string>//' | sed 's/<\/string>//' | tr -d '\t')

if [ -n "$REVERSED_CLIENT_ID" ]; then
    echo "   ✅ REVERSED_CLIENT_ID: ${REVERSED_CLIENT_ID:0:40}..."
else
    echo "   ❌ REVERSED_CLIENT_ID missing!"
    exit 1
fi

if [ -n "$CLIENT_ID" ]; then
    echo "   ✅ CLIENT_ID: ${CLIENT_ID:0:40}..."
else
    echo "   ❌ CLIENT_ID missing!"
    exit 1
fi

echo ""

# 2. Check Info.plist for URL scheme
echo "2️⃣ Checking Info.plist URL schemes..."
INFO_PLIST="ios/App/App/Info.plist"

if grep -q "CFBundleURLTypes" "$INFO_PLIST"; then
    echo "   ✅ CFBundleURLTypes found in Info.plist"

    if grep -q "$REVERSED_CLIENT_ID" "$INFO_PLIST"; then
        echo "   ✅ REVERSED_CLIENT_ID registered as URL scheme"
    else
        echo "   ❌ REVERSED_CLIENT_ID not found in URL schemes!"
        echo "   Expected: $REVERSED_CLIENT_ID"
        exit 1
    fi
else
    echo "   ❌ CFBundleURLTypes not found in Info.plist!"
    exit 1
fi

echo ""

# 3. Check AppDelegate
echo "3️⃣ Checking AppDelegate.swift..."
APP_DELEGATE="ios/App/App/AppDelegate.swift"

if grep -q "application(_ app: UIApplication, open url: URL" "$APP_DELEGATE"; then
    echo "   ✅ URL handling method found in AppDelegate"
else
    echo "   ❌ URL handling method missing in AppDelegate!"
    exit 1
fi

echo ""

# 4. Check Firebase Auth setup in HTML
echo "4️⃣ Checking Firebase Auth in index.html..."
if grep -q "GoogleAuthProvider" "index.html"; then
    echo "   ✅ GoogleAuthProvider imported"
else
    echo "   ❌ GoogleAuthProvider not found!"
    exit 1
fi

if grep -q "signInWithRedirect" "index.html"; then
    echo "   ✅ signInWithRedirect method implemented"
else
    echo "   ❌ signInWithRedirect not found!"
    exit 1
fi

if grep -q "getRedirectResult" "index.html"; then
    echo "   ✅ getRedirectResult handler implemented"
else
    echo "   ❌ getRedirectResult not found!"
    exit 1
fi

echo ""
echo "=============================================="
echo "🎉 All OAuth configuration checks passed!"
echo ""
echo "✅ Your iOS app is ready for Google Sign-In"
echo ""
echo "Next Steps:"
echo "1. Clean build in Xcode (Product → Clean Build Folder)"
echo "2. Rebuild the app (Product → Build)"
echo "3. Run on simulator or device"
echo "4. Click Google Sign-In button"
echo "5. Complete OAuth in browser"
echo "6. App should receive the callback and sign you in"
echo ""
echo "URL Scheme: $REVERSED_CLIENT_ID"
echo ""
