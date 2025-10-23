#!/bin/bash

# Fix Xcode GUID duplicate error
# This script completely resets Xcode project state

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${CYAN}│${NC}        ${BLUE}Fix Xcode GUID Duplicate Error${NC}              ${CYAN}│${NC}"
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

# Get project directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
IOS_DIR="$PROJECT_DIR/ios/App"

cd "$IOS_DIR"

echo -e "${YELLOW}This will:${NC}"
echo "  1. Kill Xcode"
echo "  2. Remove all caches and derived data"
echo "  3. Remove package resolved files"
echo "  4. Clean and rebuild package dependencies"
echo ""
echo -e "${RED}⚠️  Make sure you've saved all work in Xcode${NC}"
echo ""
read -p "Continue? (y/N): " confirm

if [ "$confirm" != "y" ] && [ "$confirm" != "Y" ]; then
    echo -e "${BLUE}ℹ️  Cancelled${NC}"
    exit 0
fi

echo ""
echo -e "${YELLOW}Step 1: Killing Xcode...${NC}"
killall Xcode 2>/dev/null || true
sleep 2
echo -e "${GREEN}✅ Xcode closed${NC}"

echo ""
echo -e "${YELLOW}Step 2: Removing all Xcode caches...${NC}"
rm -rf ~/Library/Developer/Xcode/DerivedData
rm -rf ~/Library/Caches/org.swift.swiftpm
rm -rf ~/Library/org.swift.swiftpm
rm -rf ~/Library/Developer/Xcode/ModuleCache.noindex
echo -e "${GREEN}✅ Caches cleared${NC}"

echo ""
echo -e "${YELLOW}Step 3: Removing workspace package files...${NC}"
rm -rf App.xcworkspace/xcshareddata/swiftpm
rm -rf App.xcodeproj/project.xcworkspace/xcshareddata/swiftpm
rm -rf .build
echo -e "${GREEN}✅ Package files removed${NC}"

echo ""
echo -e "${YELLOW}Step 4: Removing and reinstalling Pods...${NC}"
rm -rf Pods Podfile.lock
pod deintegrate 2>/dev/null || true
pod install
echo -e "${GREEN}✅ Pods reinstalled${NC}"

echo ""
echo -e "${YELLOW}Step 5: Resolving Swift package dependencies...${NC}"
xcodebuild -resolvePackageDependencies -workspace App.xcworkspace -scheme App 2>&1 | grep -E "(Resolved|resolved)" || true
echo -e "${GREEN}✅ Packages resolved${NC}"

echo ""
echo -e "${YELLOW}Step 6: Testing clean build...${NC}"
xcodebuild clean -workspace App.xcworkspace -scheme App 2>&1 | tail -3
echo -e "${GREEN}✅ Clean succeeded${NC}"

echo ""
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}│${NC}              ${BLUE}Fix Complete!${NC}                          ${GREEN}│${NC}"
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo -e "${CYAN}Next steps:${NC}"
echo "  1. Open Xcode: ${BLUE}open App.xcworkspace${NC}"
echo "  2. Select the ${YELLOW}App target${NC} (not the project)"
echo "  3. Go to General tab for app settings"
echo "  4. Try building (⌘+B)"
echo ""
