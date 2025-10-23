#!/bin/bash

# Screenshot Preparation Script for App Store Connect
# Validates and resizes screenshots to required dimensions

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${CYAN}│${NC}        ${BLUE}App Store Screenshot Preparation${NC}            ${CYAN}│${NC}"
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

# Get project directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
SCREENSHOTS_DIR="$PROJECT_DIR/screenshots/ios"

# Create screenshots directory if it doesn't exist
mkdir -p "$SCREENSHOTS_DIR"

echo -e "${YELLOW}📱 App Store Connect Screenshot Requirements${NC}"
echo ""
echo "Apple requires screenshots for at least ONE of these sizes:"
echo ""
echo "  1) 📱 6.9\" Display (iPhone 16 Pro Max):    1320 x 2868 px"
echo "  2) 📱 6.7\" Display (iPhone 15 Pro Max):    1290 x 2796 px"
echo "  3) 📱 6.5\" Display (iPhone 11 Pro Max):    1242 x 2688 px"
echo "  4) 📱 5.5\" Display (iPhone 8 Plus):        1242 x 2208 px"
echo ""
echo -e "${BLUE}Current screenshots in: ${SCREENSHOTS_DIR}${NC}"
echo ""

# Check existing screenshots
if [ -d "$SCREENSHOTS_DIR" ] && [ "$(ls -A $SCREENSHOTS_DIR/*.png 2>/dev/null)" ]; then
    echo -e "${GREEN}✅ Existing screenshots:${NC}"
    echo ""
    for file in "$SCREENSHOTS_DIR"/*.png; do
        if [ -f "$file" ]; then
            filename=$(basename "$file")
            dimensions=$(sips -g pixelWidth -g pixelHeight "$file" | grep -E 'pixelWidth|pixelHeight' | awk '{print $2}' | tr '\n' 'x' | sed 's/x$//')
            width=$(echo $dimensions | cut -d'x' -f1)
            height=$(echo $dimensions | cut -d'x' -f2)

            # Check if dimensions are valid
            if [[ "$width" == "1320" && "$height" == "2868" ]]; then
                echo -e "  ${GREEN}✓${NC} $filename: ${dimensions} px ${GREEN}(iPhone 16 Pro Max)${NC}"
            elif [[ "$width" == "1290" && "$height" == "2796" ]]; then
                echo -e "  ${GREEN}✓${NC} $filename: ${dimensions} px ${GREEN}(iPhone 15 Pro Max)${NC}"
            elif [[ "$width" == "1242" && "$height" == "2688" ]]; then
                echo -e "  ${GREEN}✓${NC} $filename: ${dimensions} px ${GREEN}(iPhone 11 Pro Max)${NC}"
            elif [[ "$width" == "1242" && "$height" == "2208" ]]; then
                echo -e "  ${GREEN}✓${NC} $filename: ${dimensions} px ${GREEN}(iPhone 8 Plus)${NC}"
            else
                echo -e "  ${RED}✗${NC} $filename: ${dimensions} px ${RED}(INVALID SIZE)${NC}"
            fi
        fi
    done
    echo ""
else
    echo -e "${YELLOW}⚠️  No screenshots found${NC}"
    echo ""
fi

# Menu
echo -e "${YELLOW}What do you want to do?${NC}"
echo ""
echo "  1) 📸  Add screenshots from Desktop (drag & drop)"
echo "  2) 🔍  Validate existing screenshots"
echo "  3) 📏  Resize screenshots to target size"
echo "  4) 📋  Show upload instructions"
echo "  5) 🗑️  Clean up invalid screenshots"
echo "  0) ❌  Exit"
echo ""
read -p "Enter choice [0-5]: " choice

case $choice in
    1)
        echo ""
        echo -e "${YELLOW}Drag and drop screenshot files here, then press Enter:${NC}"
        read -e files

        # Process each file
        for file in $files; do
            # Remove quotes if present
            file=$(echo "$file" | tr -d "'\"")

            if [ ! -f "$file" ]; then
                echo -e "${RED}✗ File not found: $file${NC}"
                continue
            fi

            filename=$(basename "$file")
            dimensions=$(sips -g pixelWidth -g pixelHeight "$file" | grep -E 'pixelWidth|pixelHeight' | awk '{print $2}' | tr '\n' 'x' | sed 's/x$//')
            width=$(echo $dimensions | cut -d'x' -f1)
            height=$(echo $dimensions | cut -d'x' -f2)

            echo ""
            echo -e "${BLUE}Processing: $filename${NC}"
            echo "  Dimensions: ${dimensions} px"

            # Check if valid size
            if [[ ("$width" == "1320" && "$height" == "2868") || \
                  ("$width" == "1290" && "$height" == "2796") || \
                  ("$width" == "1242" && "$height" == "2688") || \
                  ("$width" == "1242" && "$height" == "2208") ]]; then
                # Valid size - copy to screenshots directory
                cp "$file" "$SCREENSHOTS_DIR/"
                echo -e "  ${GREEN}✓ Valid size - copied to screenshots directory${NC}"
            else
                echo -e "  ${YELLOW}⚠️  Invalid size for App Store Connect${NC}"
                echo -e "  ${YELLOW}Would you like to resize it? (y/N):${NC}"
                read -p "  " resize
                if [[ "$resize" =~ ^[Yy]$ ]]; then
                    # Resize to iPhone 16 Pro Max (1320x2868)
                    output_file="$SCREENSHOTS_DIR/$filename"
                    sips -z 2868 1320 "$file" --out "$output_file" > /dev/null 2>&1
                    echo -e "  ${GREEN}✓ Resized to 1320x2868 and saved${NC}"
                else
                    echo -e "  ${RED}✗ Skipped${NC}"
                fi
            fi
        done
        ;;

    2)
        echo ""
        echo -e "${YELLOW}🔍 Validating screenshots...${NC}"
        echo ""

        valid_count=0
        invalid_count=0

        for file in "$SCREENSHOTS_DIR"/*.png; do
            if [ ! -f "$file" ]; then
                continue
            fi

            filename=$(basename "$file")
            dimensions=$(sips -g pixelWidth -g pixelHeight "$file" | grep -E 'pixelWidth|pixelHeight' | awk '{print $2}' | tr '\n' 'x' | sed 's/x$//')
            width=$(echo $dimensions | cut -d'x' -f1)
            height=$(echo $dimensions | cut -d'x' -f2)

            if [[ ("$width" == "1320" && "$height" == "2868") || \
                  ("$width" == "1290" && "$height" == "2796") || \
                  ("$width" == "1242" && "$height" == "2688") || \
                  ("$width" == "1242" && "$height" == "2208") ]]; then
                echo -e "${GREEN}✓${NC} $filename: ${dimensions} px"
                ((valid_count++))
            else
                echo -e "${RED}✗${NC} $filename: ${dimensions} px ${RED}(INVALID)${NC}"
                ((invalid_count++))
            fi
        done

        echo ""
        echo -e "${BLUE}Summary:${NC}"
        echo "  Valid:   $valid_count"
        echo "  Invalid: $invalid_count"

        if [ $valid_count -gt 0 ]; then
            echo ""
            echo -e "${GREEN}✅ You have valid screenshots ready for upload!${NC}"
        fi
        ;;

    3)
        echo ""
        echo -e "${YELLOW}📏 Target size:${NC}"
        echo "  1) 1320 x 2868 (iPhone 16 Pro Max) - Recommended"
        echo "  2) 1290 x 2796 (iPhone 15 Pro Max)"
        echo "  3) 1242 x 2688 (iPhone 11 Pro Max)"
        echo "  4) 1242 x 2208 (iPhone 8 Plus)"
        read -p "Choose target size [1-4]: " size_choice

        case $size_choice in
            1) target_width=1320; target_height=2868; device="iPhone 16 Pro Max" ;;
            2) target_width=1290; target_height=2796; device="iPhone 15 Pro Max" ;;
            3) target_width=1242; target_height=2688; device="iPhone 11 Pro Max" ;;
            4) target_width=1242; target_height=2208; device="iPhone 8 Plus" ;;
            *)
                echo -e "${RED}Invalid choice${NC}"
                exit 1
                ;;
        esac

        echo ""
        echo -e "${YELLOW}Resizing all screenshots to ${target_width}x${target_height} ($device)...${NC}"
        echo ""

        for file in "$SCREENSHOTS_DIR"/*.png; do
            if [ ! -f "$file" ]; then
                continue
            fi

            filename=$(basename "$file")
            echo "  Processing: $filename"
            sips -z $target_height $target_width "$file" > /dev/null 2>&1
            echo -e "    ${GREEN}✓ Resized${NC}"
        done

        echo ""
        echo -e "${GREEN}✅ All screenshots resized!${NC}"
        ;;

    4)
        echo ""
        echo -e "${CYAN}📋 Upload Instructions for App Store Connect:${NC}"
        echo ""
        echo "1. Go to: https://appstoreconnect.apple.com"
        echo "2. Select your app"
        echo "3. Go to: App Store → [Version] → App Screenshots"
        echo "4. Select device size (e.g., 6.9\" Display)"
        echo "5. Drag and drop screenshots in order:"
        echo ""
        ls -1 "$SCREENSHOTS_DIR"/*.png 2>/dev/null | while read file; do
            echo "   - $(basename "$file")"
        done
        echo ""
        echo -e "${YELLOW}⚠️  Upload screenshots in the order they appear above${NC}"
        echo -e "${BLUE}💡 First screenshot appears as the main preview${NC}"
        ;;

    5)
        echo ""
        echo -e "${RED}🗑️  Removing invalid screenshots...${NC}"
        echo ""

        for file in "$SCREENSHOTS_DIR"/*.png; do
            if [ ! -f "$file" ]; then
                continue
            fi

            filename=$(basename "$file")
            dimensions=$(sips -g pixelWidth -g pixelHeight "$file" | grep -E 'pixelWidth|pixelHeight' | awk '{print $2}' | tr '\n' 'x' | sed 's/x$//')
            width=$(echo $dimensions | cut -d'x' -f1)
            height=$(echo $dimensions | cut -d'x' -f2)

            if [[ ! (("$width" == "1320" && "$height" == "2868") || \
                     ("$width" == "1290" && "$height" == "2796") || \
                     ("$width" == "1242" && "$height" == "2688") || \
                     ("$width" == "1242" && "$height" == "2208")) ]]; then
                echo "  Removing: $filename (${dimensions} px)"
                rm "$file"
            fi
        done

        echo ""
        echo -e "${GREEN}✅ Cleanup complete!${NC}"
        ;;

    0)
        echo ""
        echo -e "${BLUE}👋 Goodbye!${NC}"
        exit 0
        ;;

    *)
        echo -e "${RED}❌ Invalid choice${NC}"
        exit 1
        ;;
esac

echo ""
