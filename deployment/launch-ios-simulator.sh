#!/bin/bash

# ============================================================================
# Launch iOS App in Simulator
# ============================================================================
# This script builds and launches the app in the iOS simulator
# ============================================================================

set -e

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

print_header() {
    echo ""
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${CYAN}│${NC}           ${BLUE}$1${NC}                              ${CYAN}│${NC}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
}

print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
}

print_info() {
    echo -e "${BLUE}ℹ $1${NC}"
}

# ============================================================================
# Main Script
# ============================================================================

cd "$PROJECT_ROOT"

print_header "Launch iOS App in Simulator"

# Check if Xcode is installed
if ! command -v xcodebuild &> /dev/null; then
    print_error "Xcode is not installed!"
    echo ""
    echo "Please install Xcode from the App Store:"
    echo "https://apps.apple.com/us/app/xcode/id497799835"
    exit 1
fi

# Check if iOS folder exists
if [ ! -d "ios/App" ]; then
    print_error "iOS project not found at ios/App"
    echo ""
    echo "Please run Capacitor sync first:"
    echo "  npx cap sync ios"
    exit 1
fi

# Step 1: Sync web files to iOS
echo -e "${BLUE}📱 Step 1: Syncing web files to iOS...${NC}"
echo ""

if [ -f "deployment/sync-web-to-ios.sh" ]; then
    # Call with --no-build to skip the build/launch steps
    bash deployment/sync-web-to-ios.sh --no-build
else
    # Fallback: do manual sync
    echo -e "${YELLOW}Syncing manually...${NC}"
    cp web/index.html ios/App/App/public/ 2>/dev/null || true
    npx cap sync ios
fi

echo ""
print_success "Web files synced"

# Step 2: Get available simulators
echo ""
echo -e "${BLUE}📱 Step 2: Finding iOS simulators...${NC}"
echo ""

# Check if user wants iPad
echo "Select device type:"
echo "1) iPhone (default)"
echo "2) iPad"
read -p "Enter choice (1-2, or press Enter for iPhone): " DEVICE_CHOICE

if [ "$DEVICE_CHOICE" = "2" ]; then
    # Get list of available iPad simulators
    SIMULATORS=$(xcrun simctl list devices available | grep "iPad" | grep -v "unavailable" | head -5)
    DEVICE_TYPE="iPad"
else
    # Get list of available iPhone simulators
    SIMULATORS=$(xcrun simctl list devices available | grep "iPhone" | grep -v "unavailable" | head -5)
    DEVICE_TYPE="iPhone"
fi

if [ -z "$SIMULATORS" ]; then
    print_error "No $DEVICE_TYPE simulators found!"
    echo ""
    echo "Please open Xcode and install iOS simulators:"
    echo "  Xcode → Settings → Platforms → iOS Simulators"
    exit 1
fi

# Find the first available simulator of selected type
SIMULATOR_ID=$(xcrun simctl list devices available | grep "$DEVICE_TYPE" | grep -v "unavailable" | head -1 | grep -oE '\([A-F0-9-]+\)' | tr -d '()')
SIMULATOR_NAME=$(xcrun simctl list devices available | grep "$DEVICE_TYPE" | grep -v "unavailable" | head -1 | sed 's/ (.*$//')

if [ -z "$SIMULATOR_ID" ]; then
    print_error "Could not find a suitable $DEVICE_TYPE simulator"
    echo ""
    echo "Available devices:"
    xcrun simctl list devices available | grep "$DEVICE_TYPE"
    exit 1
fi

print_success "Found simulator: $SIMULATOR_NAME"
echo -e "  ${CYAN}ID: $SIMULATOR_ID${NC}"

# Step 3: Boot the simulator if not already running
echo ""
echo -e "${BLUE}📱 Step 3: Starting simulator...${NC}"
echo ""

SIMULATOR_STATE=$(xcrun simctl list devices | grep "$SIMULATOR_ID" | grep -oE '\((Booted|Shutdown)\)' | tr -d '()')

if [ "$SIMULATOR_STATE" != "Booted" ]; then
    print_info "Booting $SIMULATOR_NAME..."
    xcrun simctl boot "$SIMULATOR_ID" 2>/dev/null || true
    sleep 3
    print_success "Simulator started"
else
    print_info "Simulator already running"
fi

# Open Simulator app
open -a Simulator

# Step 4: Build and install the app
echo ""
echo -e "${BLUE}📱 Step 4: Building app...${NC}"
echo ""

cd ios/App

# Get app name from Info.plist
APP_NAME=$(grep -A 1 "CFBundleDisplayName" App/Info.plist | grep "<string>" | sed 's/.*<string>//;s/<\/string>.*//' | tr -d '\t')

if [ -z "$APP_NAME" ]; then
    APP_NAME="App"
fi

print_info "Building $APP_NAME for simulator..."

# Clean old build first to avoid cached issues
print_info "Cleaning old builds..."
rm -rf build 2>/dev/null || true

# Build for simulator
xcodebuild \
    -workspace App.xcworkspace \
    -scheme App \
    -configuration Debug \
    -sdk iphonesimulator \
    -destination "id=$SIMULATOR_ID" \
    -derivedDataPath build \
    clean build 2>&1 | grep -E "error:|warning:|Build succeeded|BUILD|Cleaning" || true

if [ ${PIPESTATUS[0]} -ne 0 ]; then
    cd "$PROJECT_ROOT"
    print_error "Build failed!"
    echo ""
    echo "Try these steps:"
    echo "  1. Open ios/App/App.xcworkspace in Xcode"
    echo "  2. Fix any build errors"
    echo "  3. Try building from Xcode first"
    echo "  4. Then run this script again"
    exit 1
fi

print_success "Build completed"

# Step 5: Install the app
echo ""
echo -e "${BLUE}📱 Step 5: Installing app...${NC}"
echo ""

# Find the .app bundle
APP_BUNDLE=$(find build/Build/Products/Debug-iphonesimulator -name "*.app" -type d | head -1)

if [ -z "$APP_BUNDLE" ]; then
    cd "$PROJECT_ROOT"
    print_error "Could not find built app bundle"
    exit 1
fi

# Get the actual bundle ID from the built app or pbxproj
# First, try to get it from the xcodeproj
BUNDLE_ID=$(grep -m 1 "PRODUCT_BUNDLE_IDENTIFIER" App.xcodeproj/project.pbxproj | sed 's/.*= //;s/;//;s/"//g' | tr -d '\t' || echo "")

# If that didn't work, try from capacitor config
if [ -z "$BUNDLE_ID" ]; then
    BUNDLE_ID=$(grep -o '"appId": "[^"]*"' ../../capacitor.config.json | cut -d'"' -f4)
fi

# Fallback to Info.plist default
if [ -z "$BUNDLE_ID" ]; then
    BUNDLE_ID="com.stepahead.app"
fi

print_info "Bundle ID: $BUNDLE_ID"

# Uninstall old version if exists
xcrun simctl uninstall "$SIMULATOR_ID" "$BUNDLE_ID" 2>/dev/null || true

# Install new version
print_info "Installing to simulator..."
xcrun simctl install "$SIMULATOR_ID" "$APP_BUNDLE"

print_success "App installed"

# Step 6: Launch the app
echo ""
echo -e "${BLUE}📱 Step 6: Launching app...${NC}"
echo ""

xcrun simctl launch "$SIMULATOR_ID" "$BUNDLE_ID"

cd "$PROJECT_ROOT"

print_success "App launched successfully!"

echo ""
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo -e "${GREEN}✅ $APP_NAME is now running in the iOS Simulator!${NC}"
echo ""
echo -e "${CYAN}App Name:${NC} $APP_NAME"
echo -e "${CYAN}Bundle ID:${NC} $BUNDLE_ID"
echo -e "${CYAN}Simulator:${NC} $SIMULATOR_NAME"
echo ""
echo -e "${YELLOW}💡 Tips:${NC}"
echo "  • Simulator window should be open now"
echo "  • Use ⌘+D to open developer menu in simulator"
echo "  • Use ⌘+K to toggle software keyboard"
echo "  • Shake gesture: Device → Shake"
echo "  • Reload app: Make changes and run this script again"
echo ""
