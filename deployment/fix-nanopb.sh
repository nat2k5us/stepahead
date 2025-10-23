#!/bin/bash

# Fix nanopb build folder issue before TestFlight deployment
# This folder prevents Xcode clean from succeeding

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${CYAN}│${NC}        ${BLUE}Fix nanopb Build Folder Issue${NC}              ${CYAN}│${NC}"
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

# Find and remove the nanopb build folder
NANOPB_BUILD_FOLDER="/Users/natrajbontha/Library/Developer/Xcode/DerivedData/App-diakybxzarnrnzflbafmvceitnbl/SourcePackages/checkouts/nanopb/build"

if [ -d "$NANOPB_BUILD_FOLDER" ]; then
    echo -e "${YELLOW}Found nanopb build folder:${NC}"
    echo "  $NANOPB_BUILD_FOLDER"
    echo ""
    echo -e "${YELLOW}Removing...${NC}"
    rm -rf "$NANOPB_BUILD_FOLDER"
    echo -e "${GREEN}✅ Removed successfully${NC}"
else
    echo -e "${BLUE}ℹ️  nanopb build folder not found (this is fine)${NC}"
fi

# Also check for any other App DerivedData with nanopb issues
echo ""
echo -e "${YELLOW}Checking for other nanopb build folders...${NC}"
FOUND_COUNT=0

for nanopb_path in ~/Library/Developer/Xcode/DerivedData/App-*/SourcePackages/checkouts/nanopb/build; do
    if [ -d "$nanopb_path" ]; then
        echo -e "${YELLOW}Found: $nanopb_path${NC}"
        rm -rf "$nanopb_path"
        echo -e "${GREEN}✅ Removed${NC}"
        FOUND_COUNT=$((FOUND_COUNT + 1))
    fi
done

if [ $FOUND_COUNT -eq 0 ]; then
    echo -e "${BLUE}ℹ️  No additional nanopb folders found${NC}"
else
    echo -e "${GREEN}✅ Removed $FOUND_COUNT additional nanopb folder(s)${NC}"
fi

echo ""
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}│${NC}              ${BLUE}Ready for TestFlight!${NC}                  ${GREEN}│${NC}"
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo -e "${CYAN}Next step:${NC}"
echo "  ./deployment/publish-testflight.sh"
echo ""
