#!/bin/bash

# StepAhead iOS Rebuild Script
# This script cleans and rebuilds the iOS app with the new StepAhead branding

set -e

echo "🧹 Cleaning old build artifacts..."
rm -rf ios/App/build
rm -rf ios/App/DerivedData
echo "✅ Build artifacts cleaned"
echo ""

echo "📦 Syncing Capacitor to iOS..."
npx cap sync ios 2>&1 | grep -E "✔|Copying|error" || true
echo "✅ Capacitor synced"
echo ""

echo "📱 Opening in Xcode..."
npx cap open ios

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✅ Ready to build in Xcode!"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "In Xcode:"
echo "  1. Press Shift+Cmd+K to clean build folder"
echo "  2. Select your simulator (iPhone 16 Pro, etc.)"
echo "  3. Press Cmd+R to build and run"
echo ""
echo "You should see:"
echo "  • App name: StepAhead"
echo "  • Bundle ID: com.stepahead.app"
echo "  • Login icon: 🏠"
echo ""
