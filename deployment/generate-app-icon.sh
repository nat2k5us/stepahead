#!/bin/bash

# ============================================================================
# App Icon Generator
# ============================================================================
# This script generates app icons for iOS and Android using:
# 1. Emoji-based icon (quick & fun)
# 2. AI-generated icon via URL (if you have one)
# 3. Gradient background icon (colorful placeholder)
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
MAGENTA='\033[0;35m'
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

print_header "App Icon Generator"

cat << EOF
${CYAN}Choose icon generation method:${NC}

${GREEN}1)${NC} 🎨 Emoji Icon (Quick & Fun)
   - Uses a large emoji as the app icon
   - Perfect for TacoTalk 🌮, or any emoji-based branding
   - Generates all required sizes automatically

${GREEN}2)${NC} 🌈 Gradient Icon (Colorful Placeholder)
   - Creates a gradient background with app initials
   - Customizable colors
   - Professional placeholder until you have final artwork

${GREEN}3)${NC} 🤖 AI-Generated Icon (via online service)
   - Opens browser to AI icon generators
   - You provide the generated image
   - Script will resize for all platforms

${GREEN}4)${NC} 📁 Use Existing Image
   - Point to an existing 1024x1024 PNG file
   - Script will generate all required sizes

${RED}0)${NC} Cancel

EOF

read -p "$(echo -e "${YELLOW}Enter choice [1-4]:${NC} ")" choice

case $choice in
    1)
        # Emoji Icon
        print_header "Emoji Icon Generator"

        echo -e "${CYAN}Popular emoji suggestions:${NC}"
        echo "  🌮 - TacoTalk (current)"
        echo "  🍕 - Food apps"
        echo "  🎮 - Gaming"
        echo "  📚 - Education"
        echo "  💬 - Messaging"
        echo "  🏃 - Fitness"
        echo "  🎵 - Music"
        echo "  📷 - Photography"
        echo "  ⭐ - StarGazing"
        echo "  🔭 - Astronomy"
        echo ""

        read -p "$(echo -e "${YELLOW}Enter emoji to use:${NC} ")" EMOJI

        if [ -z "$EMOJI" ]; then
            EMOJI="🌮"
        fi

        echo ""
        read -p "$(echo -e "${YELLOW}Background color (hex, e.g., #FF6B35):${NC} ")" BG_COLOR

        if [ -z "$BG_COLOR" ]; then
            BG_COLOR="#FF6B35"
        fi

        print_info "Generating emoji icon with $EMOJI on $BG_COLOR background..."

        # Check if ImageMagick is installed
        if ! command -v convert &> /dev/null && ! command -v magick &> /dev/null; then
            print_error "ImageMagick not found!"
            echo ""
            echo "Install with: brew install imagemagick"
            echo ""
            echo "Alternative: Use option 3 (AI-Generated) or 4 (Existing Image)"
            exit 1
        fi

        # Create temp directory
        mkdir -p /tmp/app-icons

        # Generate base 1024x1024 icon with emoji
        if command -v magick &> /dev/null; then
            CONVERT_CMD="magick"
        else
            CONVERT_CMD="convert"
        fi

        # Try to use Apple Color Emoji font, fall back to macOS method if it fails
        if ! $CONVERT_CMD -size 1024x1024 xc:"$BG_COLOR" \
            -gravity center \
            -pointsize 700 \
            -font "Apple-Color-Emoji" \
            -fill white \
            -annotate +0+0 "$EMOJI" \
            /tmp/app-icons/icon-1024.png 2>/dev/null; then

            print_info "Apple Color Emoji font not accessible, using alternative method..."

            # Alternative: Create background and use macOS to render emoji as PNG
            $CONVERT_CMD -size 1024x1024 xc:"$BG_COLOR" /tmp/app-icons/bg.png

            # Create emoji using macOS native rendering
            cat > /tmp/app-icons/render-emoji.sh << 'EMOJI_SCRIPT'
#!/bin/bash
EMOJI="$1"
OUTPUT="$2"
# Use Python with PIL to render emoji
python3 << PYTHON_END
import sys
from PIL import Image, ImageDraw, ImageFont
import os

emoji = "$EMOJI"
output = "$OUTPUT"

# Create transparent image for emoji
img = Image.new('RGBA', (800, 800), (0, 0, 0, 0))
draw = ImageDraw.Draw(img)

# Try to use system font
try:
    # Use a large font size
    font = ImageFont.truetype("/System/Library/Fonts/Apple Color Emoji.ttc", 600)
    # Draw emoji
    draw.text((400, 400), emoji, font=font, anchor="mm", embedded_color=True)
except Exception as e:
    # Fallback: just save the emoji as text using default font
    font = ImageFont.truetype("/System/Library/Fonts/Helvetica.ttc", 600)
    draw.text((400, 400), emoji, font=font, anchor="mm", fill=(255, 255, 255, 255))

img.save(output, "PNG")
print("Emoji rendered successfully")
PYTHON_END
EMOJI_SCRIPT

            chmod +x /tmp/app-icons/render-emoji.sh

            # Try Python method
            if /tmp/app-icons/render-emoji.sh "$EMOJI" /tmp/app-icons/emoji.png 2>/dev/null; then
                # Composite emoji onto background
                $CONVERT_CMD /tmp/app-icons/bg.png /tmp/app-icons/emoji.png \
                    -gravity center -composite /tmp/app-icons/icon-1024.png
            else
                # Ultimate fallback: use text with Helvetica
                print_info "Using text fallback with system font..."
                $CONVERT_CMD -size 1024x1024 xc:"$BG_COLOR" \
                    -gravity center \
                    -pointsize 600 \
                    -font "Helvetica-Bold" \
                    -fill white \
                    -annotate +0+0 "$EMOJI" \
                    /tmp/app-icons/icon-1024.png
            fi
        fi

        print_success "Generated base icon"

        # Copy to project root
        cp /tmp/app-icons/icon-1024.png icon.jpg
        print_success "Saved to icon.jpg"

        # Generate iOS icons
        print_info "Generating iOS icons..."

        IOS_ICONSET="ios/App/App/Assets.xcassets/AppIcon.appiconset"
        mkdir -p "$IOS_ICONSET"

        # iOS icon sizes
        declare -a iOS_SIZES=(
            "20:icon-20.png"
            "29:icon-29.png"
            "40:icon-40.png"
            "58:icon-58.png"
            "60:icon-60.png"
            "76:icon-76.png"
            "80:icon-80.png"
            "87:icon-87.png"
            "120:icon-120.png"
            "152:icon-152.png"
            "167:icon-167.png"
            "180:icon-180.png"
            "1024:icon-1024.png"
        )

        for size_entry in "${iOS_SIZES[@]}"; do
            IFS=':' read -r size filename <<< "$size_entry"
            $CONVERT_CMD /tmp/app-icons/icon-1024.png -resize ${size}x${size} "$IOS_ICONSET/$filename"
        done

        print_success "Generated iOS icons in $IOS_ICONSET"

        # Generate Android icons
        print_info "Generating Android icons..."

        declare -a ANDROID_SIZES=(
            "mdpi:48"
            "hdpi:72"
            "xhdpi:96"
            "xxhdpi:144"
            "xxxhdpi:192"
        )

        for density_entry in "${ANDROID_SIZES[@]}"; do
            IFS=':' read -r density size <<< "$density_entry"
            ANDROID_DIR="android/app/src/main/res/mipmap-$density"
            mkdir -p "$ANDROID_DIR"
            $CONVERT_CMD /tmp/app-icons/icon-1024.png -resize ${size}x${size} "$ANDROID_DIR/ic_launcher.png"
            $CONVERT_CMD /tmp/app-icons/icon-1024.png -resize ${size}x${size} "$ANDROID_DIR/ic_launcher_round.png"
        done

        print_success "Generated Android icons"

        echo ""
        print_success "Icon generation complete!"
        echo ""
        echo -e "${CYAN}Generated:${NC}"
        echo "  • icon.jpg (1024x1024)"
        echo "  • iOS icons in $IOS_ICONSET"
        echo "  • Android icons in android/app/src/main/res/mipmap-*"
        echo ""
        echo -e "${YELLOW}Next steps:${NC}"
        echo "  1. Run: npx cap sync ios"
        echo "  2. Clean build in Xcode (Product → Clean Build Folder)"
        echo "  3. Rebuild and test"
        ;;

    2)
        # Gradient Icon
        print_header "Gradient Icon Generator"

        # Get app name for initials
        APP_NAME=$(grep -o '"appName": "[^"]*"' capacitor.config.json | cut -d'"' -f4 || echo "TacoTalk")

        # Extract initials (first letter of each word)
        INITIALS=$(echo "$APP_NAME" | sed 's/\([A-Z]\)[a-z]*/\1/g' | head -c 3)

        echo -e "${CYAN}App Name:${NC} $APP_NAME"
        echo -e "${CYAN}Detected Initials:${NC} $INITIALS"
        echo ""

        read -p "$(echo -e "${YELLOW}Use these initials? (or enter custom):${NC} ")" CUSTOM_INITIALS

        if [ ! -z "$CUSTOM_INITIALS" ]; then
            INITIALS="$CUSTOM_INITIALS"
        fi

        echo ""
        read -p "$(echo -e "${YELLOW}Gradient start color (hex, e.g., #667eea):${NC} ")" COLOR1
        read -p "$(echo -e "${YELLOW}Gradient end color (hex, e.g., #764ba2):${NC} ")" COLOR2

        if [ -z "$COLOR1" ]; then COLOR1="#667eea"; fi
        if [ -z "$COLOR2" ]; then COLOR2="#764ba2"; fi

        print_info "Generating gradient icon with initials '$INITIALS'..."

        # Check if ImageMagick is installed
        if ! command -v convert &> /dev/null && ! command -v magick &> /dev/null; then
            print_error "ImageMagick not found!"
            echo ""
            echo "Install with: brew install imagemagick"
            exit 1
        fi

        if command -v magick &> /dev/null; then
            CONVERT_CMD="magick"
        else
            CONVERT_CMD="convert"
        fi

        # Create temp directory
        mkdir -p /tmp/app-icons

        # Generate gradient with initials
        $CONVERT_CMD -size 1024x1024 \
            gradient:"$COLOR1"-"$COLOR2" \
            -gravity center \
            -pointsize 400 \
            -font "Helvetica-Bold" \
            -fill white \
            -stroke "#00000040" \
            -strokewidth 4 \
            -annotate +0+0 "$INITIALS" \
            /tmp/app-icons/icon-1024.png

        # Copy to root and generate all sizes (same as emoji method)
        cp /tmp/app-icons/icon-1024.png icon.jpg
        print_success "Saved to icon.jpg"

        # Generate iOS and Android icons (same as method 1)
        print_info "Generating platform-specific icons..."

        IOS_ICONSET="ios/App/App/Assets.xcassets/AppIcon.appiconset"
        mkdir -p "$IOS_ICONSET"

        declare -a iOS_SIZES=(
            "20:icon-20.png" "29:icon-29.png" "40:icon-40.png"
            "58:icon-58.png" "60:icon-60.png" "76:icon-76.png"
            "80:icon-80.png" "87:icon-87.png" "120:icon-120.png"
            "152:icon-152.png" "167:icon-167.png" "180:icon-180.png"
            "1024:icon-1024.png"
        )

        for size_entry in "${iOS_SIZES[@]}"; do
            IFS=':' read -r size filename <<< "$size_entry"
            $CONVERT_CMD /tmp/app-icons/icon-1024.png -resize ${size}x${size} "$IOS_ICONSET/$filename"
        done

        declare -a ANDROID_SIZES=(
            "mdpi:48"
            "hdpi:72"
            "xhdpi:96"
            "xxhdpi:144"
            "xxxhdpi:192"
        )

        for density_entry in "${ANDROID_SIZES[@]}"; do
            IFS=':' read -r density size <<< "$density_entry"
            ANDROID_DIR="android/app/src/main/res/mipmap-$density"
            mkdir -p "$ANDROID_DIR"
            $CONVERT_CMD /tmp/app-icons/icon-1024.png -resize ${size}x${size} "$ANDROID_DIR/ic_launcher.png"
            $CONVERT_CMD /tmp/app-icons/icon-1024.png -resize ${size}x${size} "$ANDROID_DIR/ic_launcher_round.png"
        done

        print_success "Icon generation complete!"
        ;;

    3)
        # AI-Generated
        print_header "AI-Generated Icon"

        echo -e "${CYAN}AI Icon Generator Services:${NC}"
        echo ""
        echo "1. IconifyAI - https://www.iconifyai.com"
        echo "2. Recraft - https://www.recraft.ai"
        echo "3. Dall-E / ChatGPT - https://chat.openai.com"
        echo "4. Midjourney - https://www.midjourney.com"
        echo ""

        read -p "$(echo -e "${YELLOW}Open IconifyAI in browser? [Y/n]:${NC} ")" open_browser

        if [ "$open_browser" != "n" ] && [ "$open_browser" != "N" ]; then
            open "https://www.iconifyai.com" 2>/dev/null || echo "Visit: https://www.iconifyai.com"
        fi

        echo ""
        echo -e "${YELLOW}Steps:${NC}"
        echo "1. Generate your icon using the AI service"
        echo "2. Download as PNG (1024x1024 recommended)"
        echo "3. Save to this project directory"
        echo "4. Run this script again and choose option 4"
        echo ""
        print_info "Tip: For best results, use prompts like:"
        echo "  'Modern app icon for a taco restaurant, minimalist, flat design'"
        echo "  'Gradient app icon with taco emoji, iOS style'"
        ;;

    4)
        # Use Existing Image
        print_header "Use Existing Image"

        read -p "$(echo -e "${YELLOW}Enter path to your icon (1024x1024 PNG):${NC} ")" ICON_PATH

        if [ ! -f "$ICON_PATH" ]; then
            print_error "File not found: $ICON_PATH"
            exit 1
        fi

        # Check if ImageMagick is installed
        if ! command -v convert &> /dev/null && ! command -v magick &> /dev/null; then
            print_error "ImageMagick not found!"
            echo ""
            echo "Install with: brew install imagemagick"
            exit 1
        fi

        if command -v magick &> /dev/null; then
            CONVERT_CMD="magick"
        else
            CONVERT_CMD="convert"
        fi

        print_info "Processing icon..."

        # Copy to project root
        cp "$ICON_PATH" icon.jpg

        # Create temp 1024x1024 version
        mkdir -p /tmp/app-icons
        $CONVERT_CMD "$ICON_PATH" -resize 1024x1024 /tmp/app-icons/icon-1024.png

        # Generate all sizes (same as above)
        IOS_ICONSET="ios/App/App/Assets.xcassets/AppIcon.appiconset"
        mkdir -p "$IOS_ICONSET"

        declare -a iOS_SIZES=(
            "20:icon-20.png" "29:icon-29.png" "40:icon-40.png"
            "58:icon-58.png" "60:icon-60.png" "76:icon-76.png"
            "80:icon-80.png" "87:icon-87.png" "120:icon-120.png"
            "152:icon-152.png" "167:icon-167.png" "180:icon-180.png"
            "1024:icon-1024.png"
        )

        for size_entry in "${iOS_SIZES[@]}"; do
            IFS=':' read -r size filename <<< "$size_entry"
            $CONVERT_CMD /tmp/app-icons/icon-1024.png -resize ${size}x${size} "$IOS_ICONSET/$filename"
        done

        declare -a ANDROID_SIZES=(
            "mdpi:48"
            "hdpi:72"
            "xhdpi:96"
            "xxhdpi:144"
            "xxxhdpi:192"
        )

        for density_entry in "${ANDROID_SIZES[@]}"; do
            IFS=':' read -r density size <<< "$density_entry"
            ANDROID_DIR="android/app/src/main/res/mipmap-$density"
            mkdir -p "$ANDROID_DIR"
            $CONVERT_CMD /tmp/app-icons/icon-1024.png -resize ${size}x${size} "$ANDROID_DIR/ic_launcher.png"
            $CONVERT_CMD /tmp/app-icons/icon-1024.png -resize ${size}x${size} "$ANDROID_DIR/ic_launcher_round.png"
        done

        print_success "Icon generation complete!"
        ;;

    0)
        echo "Cancelled"
        exit 0
        ;;

    *)
        print_error "Invalid choice"
        exit 1
        ;;
esac

echo ""
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo -e "${GREEN}✅ All icons generated successfully!${NC}"
echo ""
echo -e "${YELLOW}Next steps:${NC}"
echo "  1. Run: ${GREEN}npx cap sync ios${NC}"
echo "  2. Clean Xcode build: ${GREEN}Product → Clean Build Folder${NC}"
echo "  3. Rebuild and launch your app"
echo ""
echo -e "${CYAN}Verify icons:${NC}"
echo "  • Check: ${BLUE}icon.jpg${NC}"
echo "  • iOS: ${BLUE}ios/App/App/Assets.xcassets/AppIcon.appiconset/${NC}"
echo "  • Android: ${BLUE}android/app/src/main/res/mipmap-*/${NC}"
echo ""
