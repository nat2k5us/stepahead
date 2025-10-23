#!/bin/bash

# Capture Screenshots for App Store & Play Store
# This script captures screenshots from iOS Simulator and Android device

set -e  # Exit on any error

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# Navigate to project root (parent of deployment folder)
cd "$SCRIPT_DIR/.." || exit 1

# Create screenshots directory
SCREENSHOTS_DIR="screenshots"
IOS_DIR="$SCREENSHOTS_DIR/ios"
ANDROID_DIR="$SCREENSHOTS_DIR/android"

mkdir -p "$IOS_DIR"
mkdir -p "$ANDROID_DIR"

echo "📸 Screenshot Capture Script"
echo "============================"
echo ""

# App Store requires screenshots for:
# - 6.7" (iPhone 16 Pro Max) - 1290x2796
# - 6.5" (iPhone 11 Pro Max) - 1242x2688
# - 5.5" (iPhone 8 Plus) - 1242x2208

# Play Store recommends:
# - Phone: 1080x1920 or higher
# - 7" tablet: 1200x1920 or higher
# - 10" tablet: 1600x2560 or higher

echo "Choose screenshot capture method:"
echo "1) iOS iPhone screenshots (automated)"
echo "2) iOS iPad screenshots (automated)"
echo "3) Android device screenshots (manual guidance)"
echo "4) iOS iPhone + iPad"
echo "5) All platforms"
read -p "Enter choice (1-5): " choice

capture_ios_screenshots() {
    local DEVICE_TYPE="${1:-iPhone 16 Pro Max}"
    local SCREENSHOT_SUBDIR="${2:-iphone}"

    echo ""
    echo "📱 iOS Screenshot Instructions"
    echo "=============================="
    echo ""
    echo "AUTOMATED PROCESS:"
    echo "1. Launch iOS Simulator ($DEVICE_TYPE)"
    echo "2. The script will capture screenshots automatically"
    echo "3. Screenshots will be saved to: $IOS_DIR/$SCREENSHOT_SUBDIR/"
    echo ""
    read -p "Press Enter to start iOS Simulator capture..."

    # Create subdirectory for device type
    mkdir -p "$IOS_DIR/$SCREENSHOT_SUBDIR"

    # Launch simulator with selected device
    echo "🚀 Opening iOS Simulator ($DEVICE_TYPE)..."
    open -a Simulator

    echo ""
    echo "⏳ Waiting 5 seconds for simulator to open..."
    sleep 5

    # Boot the device
    xcrun simctl boot "$DEVICE_TYPE" 2>/dev/null || echo "Simulator already booted"

    echo ""
    echo "🚀 Building and running app in simulator..."
    cd ios/App
    xcodebuild -workspace App.xcworkspace \
        -scheme App \
        -configuration Release \
        -destination "platform=iOS Simulator,name=$DEVICE_TYPE" \
        -derivedDataPath ./build \
        clean build | grep -E "(error|warning|succeeded)" || true

    # Install the app
    xcrun simctl install "$DEVICE_TYPE" ./build/Build/Products/Release-iphonesimulator/App.app

    # Launch the app
    # Get the bundle ID from capacitor config
    BUNDLE_ID=$(grep -o '"appId": "[^"]*"' ../../capacitor.config.json | cut -d'"' -f4)
    if [ -z "$BUNDLE_ID" ]; then
        BUNDLE_ID="com.stepahead.app"
    fi
    xcrun simctl launch "$DEVICE_TYPE" "$BUNDLE_ID"

    cd ../..

    echo ""
    echo "📸 App is now running. Taking screenshots..."
    echo ""
    echo "Screenshot #1: Home Screen"
    read -p "Press Enter when ready to capture..."
    xcrun simctl io "$DEVICE_TYPE" screenshot "$IOS_DIR/$SCREENSHOT_SUBDIR/01-home-screen.png"
    echo "✅ Captured: 01-home-screen.png"

    echo ""
    echo "Screenshot #2: Explore View"
    echo "   → Tap the Explore tab"
    read -p "Press Enter when ready to capture..."
    xcrun simctl io "$DEVICE_TYPE" screenshot "$IOS_DIR/$SCREENSHOT_SUBDIR/02-explore-view.png"
    echo "✅ Captured: 02-explore-view.png"

    echo ""
    echo "Screenshot #3: Favorites View"
    echo "   → Tap the Favorites tab"
    read -p "Press Enter when ready to capture..."
    xcrun simctl io "$DEVICE_TYPE" screenshot "$IOS_DIR/$SCREENSHOT_SUBDIR/03-favorites-view.png"
    echo "✅ Captured: 03-favorites-view.png"

    echo ""
    echo "Screenshot #4: Profile Settings"
    echo "   → Navigate to Profile tab"
    read -p "Press Enter when ready to capture..."
    xcrun simctl io "$DEVICE_TYPE" screenshot "$IOS_DIR/$SCREENSHOT_SUBDIR/04-profile-settings.png"
    echo "✅ Captured: 04-profile-settings.png"

    echo ""
    echo "Screenshot #5: Theme Selection"
    echo "   → Scroll to theme section in Profile"
    read -p "Press Enter when ready to capture..."
    xcrun simctl io "$DEVICE_TYPE" screenshot "$IOS_DIR/$SCREENSHOT_SUBDIR/05-theme-settings.png"
    echo "✅ Captured: 05-theme-settings.png"

    echo ""
    echo "✅ iOS screenshots captured successfully!"
    echo "📁 Location: $IOS_DIR/$SCREENSHOT_SUBDIR/"
    open "$IOS_DIR/$SCREENSHOT_SUBDIR"
}

capture_android_screenshots() {
    echo ""
    echo "🤖 Android Screenshot Instructions"
    echo "=================================="
    echo ""
    echo "MANUAL CAPTURE PROCESS:"
    echo "Screenshots will be captured from your connected Android device"
    echo ""

    # Check if device is connected
    if ! adb devices | grep -q "device$"; then
        echo "❌ No Android device detected!"
        echo "Please connect your Android device and enable USB debugging"
        exit 1
    fi

    DEVICE_NAME=$(adb devices | grep "device$" | awk '{print $1}')
    echo "✅ Device connected: $DEVICE_NAME"
    echo ""

    read -p "Press Enter to start Android screenshot capture..."

    echo ""
    echo "📸 Taking screenshots from Android device..."
    echo ""

    echo "Screenshot #1: Home Screen (Story List)"
    read -p "Press Enter when ready to capture..."
    adb shell screencap -p /sdcard/screenshot-01.png
    adb pull /sdcard/screenshot-01.png "$ANDROID_DIR/01-home-screen.png"
    adb shell rm /sdcard/screenshot-01.png
    echo "✅ Captured: 01-home-screen.png"

    echo ""
    echo "Screenshot #2: Reading View (Start of story)"
    echo "   → Tap a story to open it"
    read -p "Press Enter when ready to capture..."
    adb shell screencap -p /sdcard/screenshot-02.png
    adb pull /sdcard/screenshot-02.png "$ANDROID_DIR/02-reading-view.png"
    adb shell rm /sdcard/screenshot-02.png
    echo "✅ Captured: 02-reading-view.png"

    echo ""
    echo "Screenshot #3: Reading in Progress (Word highlighting)"
    echo "   → Tap 'Start Reading' and read aloud"
    read -p "Press Enter when ready to capture..."
    adb shell screencap -p /sdcard/screenshot-03.png
    adb pull /sdcard/screenshot-03.png "$ANDROID_DIR/03-reading-active.png"
    adb shell rm /sdcard/screenshot-03.png
    echo "✅ Captured: 03-reading-active.png"

    echo ""
    echo "Screenshot #4: Profile Settings"
    echo "   → Navigate to Profile tab"
    read -p "Press Enter when ready to capture..."
    adb shell screencap -p /sdcard/screenshot-04.png
    adb pull /sdcard/screenshot-04.png "$ANDROID_DIR/04-profile-settings.png"
    adb shell rm /sdcard/screenshot-04.png
    echo "✅ Captured: 04-profile-settings.png"

    echo ""
    echo "Screenshot #5: Speech Recognition Settings"
    echo "   → Expand Speech Recognition section in Profile"
    read -p "Press Enter when ready to capture..."
    adb shell screencap -p /sdcard/screenshot-05.png
    adb pull /sdcard/screenshot-05.png "$ANDROID_DIR/05-speech-settings.png"
    adb shell rm /sdcard/screenshot-05.png
    echo "✅ Captured: 05-speech-settings.png"

    echo ""
    echo "✅ Android screenshots captured successfully!"
    echo "📁 Location: $ANDROID_DIR/"
    open "$ANDROID_DIR"
}

case $choice in
    1)
        capture_ios_screenshots "iPhone 16 Pro Max" "iphone"
        ;;
    2)
        capture_ios_screenshots "iPad Pro (12.9-inch) (6th generation)" "ipad"
        ;;
    3)
        capture_android_screenshots
        ;;
    4)
        capture_ios_screenshots "iPhone 16 Pro Max" "iphone"
        echo ""
        echo "════════════════════════════════════════"
        echo "Now capturing iPad screenshots..."
        echo "════════════════════════════════════════"
        sleep 2
        capture_ios_screenshots "iPad Pro (12.9-inch) (6th generation)" "ipad"
        ;;
    5)
        capture_ios_screenshots "iPhone 16 Pro Max" "iphone"
        echo ""
        echo "════════════════════════════════════════"
        echo "Now capturing iPad screenshots..."
        echo "════════════════════════════════════════"
        sleep 2
        capture_ios_screenshots "iPad Pro (12.9-inch) (6th generation)" "ipad"
        echo ""
        echo "════════════════════════════════════════"
        echo "Now capturing Android screenshots..."
        echo "════════════════════════════════════════"
        sleep 2
        capture_android_screenshots
        ;;
    *)
        echo "Invalid choice"
        exit 1
        ;;
esac

echo ""
echo "=========================================="
echo "📸 Screenshot Capture Complete!"
echo "=========================================="
echo ""
echo "Next Steps:"
echo ""
echo "For App Store (iOS):"
echo "1. Open App Store Connect: https://appstoreconnect.apple.com"
echo "2. Go to your app → App Store tab"
echo "3. Scroll to 'Screenshots' section"
echo "4. Upload screenshots from: $IOS_DIR/"
echo "   - Required: 6.7\" display (iPhone 16 Pro Max)"
echo "   - Optional: 6.5\" and 5.5\" displays"
echo ""
echo "For Play Store (Android):"
echo "1. Open Google Play Console: https://play.google.com/console"
echo "2. Go to your app → Store presence → Main store listing"
echo "3. Scroll to 'Screenshots' section"
echo "4. Upload screenshots from: $ANDROID_DIR/"
echo "   - Minimum 2 screenshots required"
echo "   - Maximum 8 screenshots allowed"
echo ""
echo "Screenshot Guidelines:"
echo "- App Store: 1290x2796 (6.7\"), 1242x2688 (6.5\"), 1242x2208 (5.5\")"
echo "- Play Store: 1080x1920 minimum"
echo "- Use high-quality, clear images"
echo "- Show key features and functionality"
echo "- No text overlay required (but can be added)"
echo ""
