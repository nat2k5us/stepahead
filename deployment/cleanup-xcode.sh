#!/bin/bash

# Xcode Cleanup Script
# Removes archives, derived data, and other temporary build files
# Run this to free up disk space after successful builds

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${CYAN}│${NC}           ${BLUE}Xcode Cleanup Script${NC}                     ${CYAN}│${NC}"
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

# Function to get directory size
get_size() {
    if [ -d "$1" ]; then
        du -sh "$1" 2>/dev/null | cut -f1
    else
        echo "0B"
    fi
}

# Function to calculate total size
calculate_total_size() {
    local total=0
    for dir in "$@"; do
        if [ -d "$dir" ]; then
            local size=$(du -sk "$dir" 2>/dev/null | cut -f1)
            total=$((total + size))
        fi
    done
    echo $((total / 1024)) # Convert to MB
}

echo -e "${YELLOW}📊 Analyzing Xcode temporary files...${NC}"
echo ""

# Get disk usage information using df
DISK_INFO=$(df -h / | tail -1)
TOTAL_DISK=$(echo $DISK_INFO | awk '{print $2}')
AVAILABLE_DISK=$(echo $DISK_INFO | awk '{print $4}')
PERCENT_USED=$(echo $DISK_INFO | awk '{print $5}')

# Get actual used space from diskutil for accuracy
DISKUTIL_INFO=$(diskutil info / | grep "Volume Free Space:" | awk '{print $4, $5}')
FREE_SPACE_GB=$(diskutil info / | grep "Volume Free Space:" | awk '{print $4}')

echo -e "${CYAN}💽 Disk Space (before cleanup):${NC}"
echo "  Capacity:  $TOTAL_DISK"
echo "  Available: $AVAILABLE_DISK"
echo "  Used:      $PERCENT_USED of capacity"
echo ""

# Paths to check
ARCHIVES_DIR="$HOME/Library/Developer/Xcode/Archives"
DERIVED_DATA="$HOME/Library/Developer/Xcode/DerivedData"
IOS_DEVICE_LOGS="$HOME/Library/Developer/Xcode/iOS DeviceSupport"
DEVICE_SUPPORT="$HOME/Library/Developer/Xcode/iOS Device Logs"
CORE_SIMULATOR="$HOME/Library/Developer/CoreSimulator"

# Show current sizes
echo -e "${BLUE}Current disk usage:${NC}"
echo ""
echo "  📦 Archives:           $(get_size "$ARCHIVES_DIR")"
echo "  🏗️  Derived Data:       $(get_size "$DERIVED_DATA")"
echo "  📱 iOS Device Logs:    $(get_size "$DEVICE_SUPPORT")"
echo "  📲 iOS DeviceSupport:  $(get_size "$IOS_DEVICE_LOGS")"
echo "  🖥️  CoreSimulator:      $(get_size "$CORE_SIMULATOR")"
echo ""

# Calculate total
TOTAL_MB=$(calculate_total_size "$ARCHIVES_DIR" "$DERIVED_DATA" "$DEVICE_SUPPORT" "$IOS_DEVICE_LOGS" "$CORE_SIMULATOR")
echo -e "${YELLOW}💾 Total potential space to free: ${TOTAL_MB} MB${NC}"
echo ""

# Menu
echo -e "${YELLOW}What do you want to clean?${NC}"
echo ""
echo "  1) 📦  Archives only (keeps last 3)"
echo "  2) 🏗️   Derived Data only"
echo "  3) 📱  Device Logs only"
echo "  4) 🖥️   CoreSimulator caches"
echo "  5) 🧹  Clean everything (keeps last 3 archives)"
echo "  6) 💀  Delete EVERYTHING (including all archives)"
echo "  0) ❌  Cancel"
echo ""
read -p "Enter choice [0-6]: " choice

case $choice in
    1)
        echo ""
        echo -e "${YELLOW}📦 Cleaning Archives (keeping last 3)...${NC}"
        if [ -d "$ARCHIVES_DIR" ]; then
            # Find and delete all but the 3 most recent archives
            find "$ARCHIVES_DIR" -maxdepth 2 -type d -name "*.xcarchive" -print0 | \
                xargs -0 ls -dt | tail -n +4 | while read archive; do
                echo "  🗑️  Deleting: $(basename "$archive")"
                rm -rf "$archive"
            done
            echo -e "${GREEN}✅ Archives cleaned (kept 3 most recent)${NC}"
        else
            echo -e "${BLUE}ℹ️  No archives directory found${NC}"
        fi
        ;;
    2)
        echo ""
        echo -e "${YELLOW}🏗️  Cleaning Derived Data...${NC}"
        if [ -d "$DERIVED_DATA" ]; then
            rm -rf "$DERIVED_DATA"/*
            echo -e "${GREEN}✅ Derived Data cleaned${NC}"
        else
            echo -e "${BLUE}ℹ️  No derived data found${NC}"
        fi
        ;;
    3)
        echo ""
        echo -e "${YELLOW}📱 Cleaning Device Logs...${NC}"
        if [ -d "$DEVICE_SUPPORT" ]; then
            rm -rf "$DEVICE_SUPPORT"/*
            echo -e "${GREEN}✅ Device Logs cleaned${NC}"
        fi
        if [ -d "$IOS_DEVICE_LOGS" ]; then
            rm -rf "$IOS_DEVICE_LOGS"/*
            echo -e "${GREEN}✅ iOS DeviceSupport cleaned${NC}"
        fi
        ;;
    4)
        echo ""
        echo -e "${YELLOW}🖥️  Cleaning CoreSimulator caches...${NC}"
        echo -e "${RED}⚠️  This will reset all simulators!${NC}"
        read -p "Are you sure? (y/N): " confirm
        if [ "$confirm" = "y" ] || [ "$confirm" = "Y" ]; then
            xcrun simctl shutdown all 2>/dev/null || true
            xcrun simctl erase all 2>/dev/null || true
            if [ -d "$CORE_SIMULATOR/Caches" ]; then
                rm -rf "$CORE_SIMULATOR/Caches"/*
            fi
            echo -e "${GREEN}✅ CoreSimulator cleaned${NC}"
        else
            echo -e "${BLUE}ℹ️  Cancelled${NC}"
        fi
        ;;
    5)
        echo ""
        echo -e "${YELLOW}🧹 Cleaning everything (keeping last 3 archives)...${NC}"

        # Archives (keep last 3)
        if [ -d "$ARCHIVES_DIR" ]; then
            echo "  📦 Cleaning archives..."
            find "$ARCHIVES_DIR" -maxdepth 2 -type d -name "*.xcarchive" -print0 | \
                xargs -0 ls -dt | tail -n +4 | while read archive; do
                rm -rf "$archive"
            done
        fi

        # Derived Data
        if [ -d "$DERIVED_DATA" ]; then
            echo "  🏗️  Cleaning derived data..."
            rm -rf "$DERIVED_DATA"/*
        fi

        # Device Logs
        if [ -d "$DEVICE_SUPPORT" ]; then
            echo "  📱 Cleaning device logs..."
            rm -rf "$DEVICE_SUPPORT"/*
        fi
        if [ -d "$IOS_DEVICE_LOGS" ]; then
            rm -rf "$IOS_DEVICE_LOGS"/*
        fi

        echo -e "${GREEN}✅ Full cleanup complete!${NC}"
        ;;
    6)
        echo ""
        echo -e "${RED}💀 DELETE EVERYTHING${NC}"
        echo -e "${RED}⚠️  This will delete ALL archives, derived data, and caches!${NC}"
        echo ""
        read -p "Type 'DELETE_ALL' to confirm: " confirm
        if [ "$confirm" = "DELETE_ALL" ]; then
            [ -d "$ARCHIVES_DIR" ] && rm -rf "$ARCHIVES_DIR"/*
            [ -d "$DERIVED_DATA" ] && rm -rf "$DERIVED_DATA"/*
            [ -d "$DEVICE_SUPPORT" ] && rm -rf "$DEVICE_SUPPORT"/*
            [ -d "$IOS_DEVICE_LOGS" ] && rm -rf "$IOS_DEVICE_LOGS"/*
            echo -e "${GREEN}✅ Everything deleted!${NC}"
        else
            echo -e "${BLUE}ℹ️  Cancelled${NC}"
        fi
        ;;
    0)
        echo ""
        echo -e "${BLUE}ℹ️  Cancelled${NC}"
        exit 0
        ;;
    *)
        echo ""
        echo -e "${RED}❌ Invalid choice${NC}"
        exit 1
        ;;
esac

echo ""
echo -e "${GREEN}🎉 Cleanup complete!${NC}"
echo ""

# Show new sizes
if [ "$choice" != "0" ]; then
    # Get updated disk usage
    DISK_INFO_AFTER=$(df -h / | tail -1)
    AVAILABLE_DISK_AFTER=$(echo $DISK_INFO_AFTER | awk '{print $4}')
    PERCENT_USED_AFTER=$(echo $DISK_INFO_AFTER | awk '{print $5}')

    # Calculate space freed (convert to MB for accurate diff)
    FREE_BEFORE=$(df -k / | tail -1 | awk '{print $4}')
    FREE_AFTER=$(df -k / | tail -1 | awk '{print $4}')
    SPACE_FREED=$((($FREE_AFTER - $FREE_BEFORE) / 1024))

    echo -e "${CYAN}💽 Disk Space (after cleanup):${NC}"
    echo "  Capacity:  $TOTAL_DISK"
    echo "  Available: $AVAILABLE_DISK_AFTER"
    echo "  Used:      $PERCENT_USED_AFTER of capacity"
    echo ""

    if [ $SPACE_FREED -gt 0 ]; then
        echo -e "${GREEN}📊 Space freed: ${SPACE_FREED} MB${NC}"
        echo "  Before: $AVAILABLE_DISK available"
        echo "  After:  $AVAILABLE_DISK_AFTER available"
    else
        echo -e "${YELLOW}📊 Space freed: Negligible (<1 MB)${NC}"
        echo "  Available: $AVAILABLE_DISK_AFTER"
    fi
    echo ""

    echo -e "${BLUE}Xcode temporary files:${NC}"
    echo ""
    echo "  📦 Archives:           $(get_size "$ARCHIVES_DIR")"
    echo "  🏗️  Derived Data:       $(get_size "$DERIVED_DATA")"
    echo "  📱 iOS Device Logs:    $(get_size "$DEVICE_SUPPORT")"
    echo "  📲 iOS DeviceSupport:  $(get_size "$IOS_DEVICE_LOGS")"
    echo "  🖥️  CoreSimulator:      $(get_size "$CORE_SIMULATOR")"
    echo ""
fi
