#!/bin/bash

# Speech Therapy iOS App Setup Script
# This script automates the initial setup for iOS development

set -e  # Exit on error

echo "🚀 Speech Therapy iOS Setup Script"
echo "===================================="
echo ""

# Check if running on macOS
if [[ "$OSTYPE" != "darwin"* ]]; then
    echo "❌ Error: This script must be run on macOS"
    exit 1
fi

# Check if Xcode is installed
if ! command -v xcodebuild &> /dev/null; then
    echo "❌ Error: Xcode is not installed"
    echo "Please install Xcode from the Mac App Store"
    exit 1
fi

echo "✅ Xcode is installed"

# Check if Node.js is installed
if ! command -v node &> /dev/null; then
    echo "❌ Error: Node.js is not installed"
    echo "Install with: brew install node"
    exit 1
fi

echo "✅ Node.js is installed ($(node --version))"

# Check if CocoaPods is installed
if ! command -v pod &> /dev/null; then
    echo "❌ Error: CocoaPods is not installed"
    echo "Install with: sudo gem install cocoapods"
    echo "Or with Homebrew: brew install cocoapods"
    exit 1
fi

echo "✅ CocoaPods is installed"

# Install npm dependencies
echo ""
echo "📦 Installing npm dependencies..."
npm install

# Initialize Capacitor (if not already done)
if [ ! -f "capacitor.config.json" ]; then
    echo ""
    echo "⚙️  Initializing Capacitor..."
    # NOTE: This setup script is deprecated. Use init-template.sh instead!
    # For reference, the command would be:
    # npx cap init "YourAppName" "com.yourcompany.yourapp"
    echo "⚠️  This setup script is deprecated."
    echo "Please use: ./init-template.sh to configure your app"
    exit 1
fi

# Add iOS platform
if [ ! -d "ios" ]; then
    echo ""
    echo "📱 Adding iOS platform..."
    npx cap add ios
else
    echo "✅ iOS platform already exists"
fi

# Sync web assets
echo ""
echo "🔄 Syncing web assets to iOS..."
npx cap sync ios

# Install CocoaPods dependencies
echo ""
echo "📦 Installing CocoaPods dependencies..."
cd ios/App
pod install
cd ../..

echo ""
echo "✅ Setup complete!"
echo ""
echo "Next steps:"
echo "1. Open Xcode project: npm run capacitor:open:ios"
echo "2. Configure signing in Xcode (Signing & Capabilities tab)"
echo "3. Connect your iOS device and run the app"
echo ""
echo "For detailed instructions, see docs/IOS_DEPLOYMENT_GUIDE.md"
echo ""
