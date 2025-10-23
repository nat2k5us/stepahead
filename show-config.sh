#!/bin/bash

# ============================================================================
# Template Configuration Viewer
# ============================================================================
# This script displays all customizable parameters and their current values,
# comparing them to the default TacoTalk configuration.
# ============================================================================

# Note: No set -e because grep commands may return non-zero on no match

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
NC='\033[0m' # No Color

# ============================================================================
# Default TacoTalk Values
# ============================================================================

DEFAULT_APP_DISPLAY_NAME="TacoTalk"
DEFAULT_APP_FULL_NAME="TacoTalk - The Ultimate Burrito Debate Platform"
DEFAULT_APP_SHORT_DESC="A revolutionary app for serious taco enthusiasts"
DEFAULT_PACKAGE_NAME="tacotalk"
DEFAULT_BUNDLE_ID="com.burrito.tacotalk"
DEFAULT_FIREBASE_PROJECT_ID="tacotalk-firebase-42"
DEFAULT_FIREBASE_API_KEY="AIzaSyTest123FakeTacoKey456"
DEFAULT_FIREBASE_AUTH_DOMAIN="tacotalk-firebase-42.firebaseapp.com"
DEFAULT_FIREBASE_STORAGE_BUCKET="tacotalk-firebase-42.firebasestorage.app"
DEFAULT_FIREBASE_SENDER_ID="987654321"
DEFAULT_FIREBASE_APP_ID="1:987654321:web:abc123tacotest"
DEFAULT_FIREBASE_MEASUREMENT_ID=""  # Optional - not always required
DEFAULT_COMPANY_NAME="Taco Innovations Inc"
DEFAULT_COMPANY_WEBSITE="www.tacoinnovations.io"
DEFAULT_DEVELOPER_NAME="Chef Burrito McGuacamole"
DEFAULT_SUPPORT_EMAIL="tacos@tacotalk.app"
DEFAULT_PRIVACY_EMAIL="privacy@tacotalk.app"
DEFAULT_CONTACT_PHONE="+1 (555) TACO-TIME"
DEFAULT_COMPANY_ADDRESS="123 Salsa Street, Guac City, TX 78701, USA"
DEFAULT_PRIMARY_DOMAIN="tacotalk.app"
DEFAULT_NETLIFY_SITE="tacotalk"
DEFAULT_APP_CATEGORY="Food & Drink"
DEFAULT_APP_KEYWORDS="tacos,burritos,food,debate,community"
DEFAULT_AGE_RATING="4+"
DEFAULT_PRIMARY_COLOR="#FF6B35"
DEFAULT_GOOGLE_OAUTH_IOS=""  # Optional - only if using Google Sign-In
DEFAULT_LOGIN_ICON="🌮"
DEFAULT_NAV_TAB_1_ID="home"
DEFAULT_NAV_TAB_1_ICON="🏠"
DEFAULT_NAV_TAB_1_LABEL="Home"
DEFAULT_NAV_TAB_2_ID="explore"
DEFAULT_NAV_TAB_2_ICON="🔍"
DEFAULT_NAV_TAB_2_LABEL="Explore"
DEFAULT_NAV_TAB_3_ID="favorites"
DEFAULT_NAV_TAB_3_ICON="⭐"
DEFAULT_NAV_TAB_3_LABEL="Favorites"
DEFAULT_NAV_TAB_4_ID="profile"
DEFAULT_NAV_TAB_4_ICON="👤"
DEFAULT_NAV_TAB_4_LABEL="Profile"

# ============================================================================
# Helper Functions
# ============================================================================

print_header() {
    echo ""
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${CYAN}│${NC}           ${BLUE}$1${NC}                              ${CYAN}│${NC}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
}

print_section() {
    echo ""
    echo -e "${MAGENTA}$1${NC}"
    echo -e "${CYAN}────────────────────────────────────────────────────────${NC}"
}

print_param() {
    local label="$1"
    local current_value="$2"
    local default_value="$3"
    local is_default=false

    # Check if current matches default
    if [ "$current_value" = "$default_value" ]; then
        is_default=true
    fi

    # Format output
    printf "  ${YELLOW}%-25s${NC} " "$label:"

    if [ "$is_default" = true ]; then
        echo -e "${GREEN}$current_value${NC} ${CYAN}(default)${NC}"
    else
        echo -e "${BLUE}$current_value${NC}"
        echo -e "  ${YELLOW}%-25s${NC} ${GREEN}$default_value${NC} ${CYAN}(TacoTalk default)${NC}" ""
    fi
}

print_param_simple() {
    local label="$1"
    local current_value="$2"
    local default_value="$3"

    # Check if current matches default
    if [ "$current_value" = "$default_value" ]; then
        # Handle empty optional values
        if [ -z "$current_value" ]; then
            printf "  ${YELLOW}%-25s${NC} ${CYAN}(not configured)${NC}\n" "$label:"
        else
            printf "  ${YELLOW}%-25s${NC} ${GREEN}$current_value${NC} ${CYAN}✓${NC}\n" "$label:"
        fi
    else
        # Show actual customized value
        if [ -z "$current_value" ] || [ "$current_value" = "N/A" ]; then
            printf "  ${YELLOW}%-25s${NC} ${CYAN}(not configured)${NC}\n" "$label:"
        else
            printf "  ${YELLOW}%-25s${NC} ${BLUE}$current_value${NC} ${MAGENTA}(customized)${NC}\n" "$label:"
        fi
    fi
}

# ============================================================================
# Extract Current Values from Files
# ============================================================================

extract_current_values() {
    # From package.json
    CURRENT_PACKAGE_NAME=$(grep -o '"name": "[^"]*"' package.json 2>/dev/null | cut -d'"' -f4 || echo "N/A")
    CURRENT_APP_SHORT_DESC=$(grep -o '"description": "[^"]*"' package.json 2>/dev/null | cut -d'"' -f4 || echo "N/A")
    CURRENT_APP_KEYWORDS=$(grep -o '"keywords": "[^"]*"' package.json 2>/dev/null | cut -d'"' -f4 || echo "N/A")

    # From capacitor.config.json
    CURRENT_BUNDLE_ID=$(grep -o '"appId": "[^"]*"' capacitor.config.json 2>/dev/null | cut -d'"' -f4 || echo "N/A")
    CURRENT_APP_DISPLAY_NAME=$(grep -o '"appName": "[^"]*"' capacitor.config.json 2>/dev/null | cut -d'"' -f4 || echo "N/A")

    # From .firebaserc
    CURRENT_FIREBASE_PROJECT_ID=$(grep -o '"default": "[^"]*"' .firebaserc 2>/dev/null | cut -d'"' -f4 || echo "N/A")

    # From index.html - Firebase config
    CURRENT_FIREBASE_API_KEY=$(grep -o 'apiKey: "[^"]*"' index.html 2>/dev/null | head -1 | cut -d'"' -f2 || echo "N/A")
    CURRENT_FIREBASE_AUTH_DOMAIN=$(grep -o 'authDomain: "[^"]*"' index.html 2>/dev/null | head -1 | cut -d'"' -f2 || echo "N/A")
    CURRENT_FIREBASE_STORAGE_BUCKET=$(grep -o 'storageBucket: "[^"]*"' index.html 2>/dev/null | head -1 | cut -d'"' -f2 || echo "N/A")
    CURRENT_FIREBASE_SENDER_ID=$(grep -o 'messagingSenderId: "[^"]*"' index.html 2>/dev/null | head -1 | cut -d'"' -f2 || echo "N/A")
    CURRENT_FIREBASE_APP_ID=$(grep -o 'appId: "[^"]*"' index.html 2>/dev/null | head -1 | cut -d'"' -f2 || echo "N/A")
    CURRENT_FIREBASE_MEASUREMENT_ID=$(grep -o 'measurementId: "[^"]*"' index.html 2>/dev/null | head -1 | cut -d'"' -f2 || echo "N/A")

    # From index.html - title
    CURRENT_APP_FULL_NAME=$(grep -o '<title>[^<]*</title>' index.html 2>/dev/null | sed 's/<title>//;s/<\/title>//' || echo "N/A")

    # From package.json - developer/author name
    CURRENT_DEVELOPER_NAME=$(grep -o '"author": "[^"]*"' package.json 2>/dev/null | cut -d'"' -f4 || echo "N/A")

    # From index.html - login icon (inside login-logo div)
    CURRENT_LOGIN_ICON=$(grep 'class="login-logo"' index.html 2>/dev/null | sed 's/.*<div class="login-logo">\(.*\)<\/div>.*/\1/' || echo "N/A")

    # From navbar-config.js - navigation tabs
    if [ -f "navbar-config.js" ]; then
        # Tab 1
        CURRENT_NAV_TAB_1_ID=$(grep -A 10 'tabs: \[' navbar-config.js 2>/dev/null | grep "id:" | head -1 | sed "s/.*id: '\([^']*\)'.*/\1/" || echo "N/A")
        CURRENT_NAV_TAB_1_ICON=$(grep -A 10 'tabs: \[' navbar-config.js 2>/dev/null | grep "icon:" | head -1 | sed "s/.*icon: '\([^']*\)'.*/\1/" || echo "N/A")
        CURRENT_NAV_TAB_1_LABEL=$(grep -A 10 'tabs: \[' navbar-config.js 2>/dev/null | grep "label:" | head -1 | sed "s/.*label: '\([^']*\)'.*/\1/" || echo "N/A")

        # Tab 2
        CURRENT_NAV_TAB_2_ID=$(grep -A 20 'tabs: \[' navbar-config.js 2>/dev/null | grep "id:" | sed -n '2p' | sed "s/.*id: '\([^']*\)'.*/\1/" || echo "N/A")
        CURRENT_NAV_TAB_2_ICON=$(grep -A 20 'tabs: \[' navbar-config.js 2>/dev/null | grep "icon:" | sed -n '2p' | sed "s/.*icon: '\([^']*\)'.*/\1/" || echo "N/A")
        CURRENT_NAV_TAB_2_LABEL=$(grep -A 20 'tabs: \[' navbar-config.js 2>/dev/null | grep "label:" | sed -n '2p' | sed "s/.*label: '\([^']*\)'.*/\1/" || echo "N/A")

        # Tab 3
        CURRENT_NAV_TAB_3_ID=$(grep -A 30 'tabs: \[' navbar-config.js 2>/dev/null | grep "id:" | sed -n '3p' | sed "s/.*id: '\([^']*\)'.*/\1/" || echo "N/A")
        CURRENT_NAV_TAB_3_ICON=$(grep -A 30 'tabs: \[' navbar-config.js 2>/dev/null | grep "icon:" | sed -n '3p' | sed "s/.*icon: '\([^']*\)'.*/\1/" || echo "N/A")
        CURRENT_NAV_TAB_3_LABEL=$(grep -A 30 'tabs: \[' navbar-config.js 2>/dev/null | grep "label:" | sed -n '3p' | sed "s/.*label: '\([^']*\)'.*/\1/" || echo "N/A")

        # Tab 4
        CURRENT_NAV_TAB_4_ID=$(grep -A 40 'tabs: \[' navbar-config.js 2>/dev/null | grep "id:" | sed -n '4p' | sed "s/.*id: '\([^']*\)'.*/\1/" || echo "N/A")
        CURRENT_NAV_TAB_4_ICON=$(grep -A 40 'tabs: \[' navbar-config.js 2>/dev/null | grep "icon:" | sed -n '4p' | sed "s/.*icon: '\([^']*\)'.*/\1/" || echo "N/A")
        CURRENT_NAV_TAB_4_LABEL=$(grep -A 40 'tabs: \[' navbar-config.js 2>/dev/null | grep "label:" | sed -n '4p' | sed "s/.*label: '\([^']*\)'.*/\1/" || echo "N/A")
    else
        # Fallback to N/A if navbar-config.js doesn't exist
        CURRENT_NAV_TAB_1_ID="N/A"
        CURRENT_NAV_TAB_1_ICON="N/A"
        CURRENT_NAV_TAB_1_LABEL="N/A"
        CURRENT_NAV_TAB_2_ID="N/A"
        CURRENT_NAV_TAB_2_ICON="N/A"
        CURRENT_NAV_TAB_2_LABEL="N/A"
        CURRENT_NAV_TAB_3_ID="N/A"
        CURRENT_NAV_TAB_3_ICON="N/A"
        CURRENT_NAV_TAB_3_LABEL="N/A"
        CURRENT_NAV_TAB_4_ID="N/A"
        CURRENT_NAV_TAB_4_ICON="N/A"
        CURRENT_NAV_TAB_4_LABEL="N/A"
    fi

    # From iOS Info.plist
    CURRENT_IOS_VERSION=$(grep -A 1 'CFBundleShortVersionString' ios/App/App/Info.plist 2>/dev/null | grep '<string>' | sed 's/.*<string>//;s/<\/string>.*//' | tr -d '\t' || echo "N/A")
    CURRENT_IOS_BUILD=$(grep -A 1 'CFBundleVersion' ios/App/App/Info.plist 2>/dev/null | grep '<string>' | sed 's/.*<string>//;s/<\/string>.*//' | tr -d '\t' || echo "N/A")
    CURRENT_GOOGLE_OAUTH_IOS=$(grep -A 5 'CFBundleURLSchemes' ios/App/App/Info.plist 2>/dev/null | grep 'com.googleusercontent' | sed 's/.*<string>//;s/<\/string>.*//' | tr -d '\t' || echo "N/A")

    # iOS App Icons
    IOS_ICONSET="ios/App/App/Assets.xcassets/AppIcon.appiconset"
    if [ -d "$IOS_ICONSET" ]; then
        # Count icon files
        ICON_COUNT=$(ls -1 "$IOS_ICONSET"/*.png 2>/dev/null | wc -l | tr -d ' ')

        # Get the 1024px icon for analysis
        if [ -f "$IOS_ICONSET/icon-1024.png" ]; then
            ICON_1024_INFO=$(file "$IOS_ICONSET/icon-1024.png" 2>/dev/null)
            ICON_1024_SIZE=$(ls -lh "$IOS_ICONSET/icon-1024.png" 2>/dev/null | awk '{print $5}')

            # Determine if it's custom or default
            if echo "$ICON_1024_INFO" | grep -q "1024 x 1024"; then
                if [ "$ICON_1024_SIZE" = "1.3M" ] || [ "$ICON_1024_SIZE" = "1.2M" ]; then
                    ICON_STATUS="Custom (StepAhead)"
                elif [ -f "$IOS_ICONSET/AppIcon-512@2x.png" ]; then
                    ICON_STATUS="Template (iSpeakClear)"
                else
                    ICON_STATUS="Custom"
                fi
            else
                ICON_STATUS="Unknown"
            fi
        else
            ICON_STATUS="Not configured"
        fi
    else
        ICON_COUNT="0"
        ICON_STATUS="AppIcon.appiconset missing"
    fi
}

# ============================================================================
# Main Display
# ============================================================================

print_header "Template Configuration Viewer"

echo -e "${CYAN}This shows all customizable parameters for this template.${NC}"
echo ""
echo -e "${YELLOW}Legend:${NC}"
echo -e "  ${GREEN}Value ${CYAN}✓${NC}               = Using TacoTalk default"
echo -e "  ${BLUE}Value${NC} ${MAGENTA}(customized)${NC}  = Has been customized"
echo ""

# Extract all current values
extract_current_values

# Calculate customization status
customized_count=0
total_params=0

check_if_customized() {
    local current="$1"
    local default="$2"
    total_params=$((total_params + 1))
    if [ "$current" != "$default" ] && [ "$current" != "N/A" ]; then
        customized_count=$((customized_count + 1))
    fi
}

# Check all params (silent)
check_if_customized "$CURRENT_APP_DISPLAY_NAME" "$DEFAULT_APP_DISPLAY_NAME"
check_if_customized "$CURRENT_APP_FULL_NAME" "$DEFAULT_APP_FULL_NAME"
check_if_customized "$CURRENT_APP_SHORT_DESC" "$DEFAULT_APP_SHORT_DESC"
check_if_customized "$CURRENT_PACKAGE_NAME" "$DEFAULT_PACKAGE_NAME"
check_if_customized "$CURRENT_BUNDLE_ID" "$DEFAULT_BUNDLE_ID"
check_if_customized "$CURRENT_FIREBASE_PROJECT_ID" "$DEFAULT_FIREBASE_PROJECT_ID"
check_if_customized "$CURRENT_FIREBASE_API_KEY" "$DEFAULT_FIREBASE_API_KEY"
check_if_customized "$CURRENT_FIREBASE_AUTH_DOMAIN" "$DEFAULT_FIREBASE_AUTH_DOMAIN"
check_if_customized "$CURRENT_FIREBASE_STORAGE_BUCKET" "$DEFAULT_FIREBASE_STORAGE_BUCKET"
check_if_customized "$CURRENT_FIREBASE_SENDER_ID" "$DEFAULT_FIREBASE_SENDER_ID"
check_if_customized "$CURRENT_FIREBASE_APP_ID" "$DEFAULT_FIREBASE_APP_ID"
check_if_customized "$CURRENT_FIREBASE_MEASUREMENT_ID" "$DEFAULT_FIREBASE_MEASUREMENT_ID"
check_if_customized "$CURRENT_DEVELOPER_NAME" "$DEFAULT_DEVELOPER_NAME"
check_if_customized "$CURRENT_LOGIN_ICON" "$DEFAULT_LOGIN_ICON"
check_if_customized "$CURRENT_NAV_TAB_1_ID" "$DEFAULT_NAV_TAB_1_ID"
check_if_customized "$CURRENT_NAV_TAB_1_ICON" "$DEFAULT_NAV_TAB_1_ICON"
check_if_customized "$CURRENT_NAV_TAB_1_LABEL" "$DEFAULT_NAV_TAB_1_LABEL"
check_if_customized "$CURRENT_NAV_TAB_2_ID" "$DEFAULT_NAV_TAB_2_ID"
check_if_customized "$CURRENT_NAV_TAB_2_ICON" "$DEFAULT_NAV_TAB_2_ICON"
check_if_customized "$CURRENT_NAV_TAB_2_LABEL" "$DEFAULT_NAV_TAB_2_LABEL"
check_if_customized "$CURRENT_NAV_TAB_3_ID" "$DEFAULT_NAV_TAB_3_ID"
check_if_customized "$CURRENT_NAV_TAB_3_ICON" "$DEFAULT_NAV_TAB_3_ICON"
check_if_customized "$CURRENT_NAV_TAB_3_LABEL" "$DEFAULT_NAV_TAB_3_LABEL"
check_if_customized "$CURRENT_NAV_TAB_4_ID" "$DEFAULT_NAV_TAB_4_ID"
check_if_customized "$CURRENT_NAV_TAB_4_ICON" "$DEFAULT_NAV_TAB_4_ICON"
check_if_customized "$CURRENT_NAV_TAB_4_LABEL" "$DEFAULT_NAV_TAB_4_LABEL"
check_if_customized "$CURRENT_GOOGLE_OAUTH_IOS" "$DEFAULT_GOOGLE_OAUTH_IOS"

# Status summary
if [ $customized_count -eq 0 ]; then
    echo -e "${GREEN}✓ Template Status: Using TacoTalk defaults${NC}"
else
    echo -e "${MAGENTA}✓ Template Status: Customized ($customized_count of $total_params parameters)${NC}"
fi

# ============================================================================
# Display All Parameters
# ============================================================================

print_section "📱 App Identity"
print_param_simple "Display Name" "$CURRENT_APP_DISPLAY_NAME" "$DEFAULT_APP_DISPLAY_NAME"
print_param_simple "Full Name" "$CURRENT_APP_FULL_NAME" "$DEFAULT_APP_FULL_NAME"
print_param_simple "Description" "$CURRENT_APP_SHORT_DESC" "$DEFAULT_APP_SHORT_DESC"
print_param_simple "Package Name" "$CURRENT_PACKAGE_NAME" "$DEFAULT_PACKAGE_NAME"
print_param_simple "Bundle ID" "$CURRENT_BUNDLE_ID" "$DEFAULT_BUNDLE_ID"

print_section "🔥 Firebase Configuration"
print_param_simple "Project ID" "$CURRENT_FIREBASE_PROJECT_ID" "$DEFAULT_FIREBASE_PROJECT_ID"
print_param_simple "API Key" "$CURRENT_FIREBASE_API_KEY" "$DEFAULT_FIREBASE_API_KEY"
print_param_simple "Auth Domain" "$CURRENT_FIREBASE_AUTH_DOMAIN" "$DEFAULT_FIREBASE_AUTH_DOMAIN"
print_param_simple "Storage Bucket" "$CURRENT_FIREBASE_STORAGE_BUCKET" "$DEFAULT_FIREBASE_STORAGE_BUCKET"
print_param_simple "Messaging Sender ID" "$CURRENT_FIREBASE_SENDER_ID" "$DEFAULT_FIREBASE_SENDER_ID"
print_param_simple "App ID" "$CURRENT_FIREBASE_APP_ID" "$DEFAULT_FIREBASE_APP_ID"
print_param_simple "Measurement ID" "$CURRENT_FIREBASE_MEASUREMENT_ID" "$DEFAULT_FIREBASE_MEASUREMENT_ID"

print_section "👤 Developer Information"
print_param_simple "Developer Name" "$CURRENT_DEVELOPER_NAME" "$DEFAULT_DEVELOPER_NAME"

print_section "🎨 Navigation Configuration"
print_param_simple "Login Icon" "$CURRENT_LOGIN_ICON" "$DEFAULT_LOGIN_ICON"
echo ""
echo -e "  ${CYAN}Tab 1:${NC}"
print_param_simple "  - ID" "$CURRENT_NAV_TAB_1_ID" "$DEFAULT_NAV_TAB_1_ID"
print_param_simple "  - Icon" "$CURRENT_NAV_TAB_1_ICON" "$DEFAULT_NAV_TAB_1_ICON"
print_param_simple "  - Label" "$CURRENT_NAV_TAB_1_LABEL" "$DEFAULT_NAV_TAB_1_LABEL"

echo ""
echo -e "  ${CYAN}Tab 2:${NC}"
print_param_simple "  - ID" "$CURRENT_NAV_TAB_2_ID" "$DEFAULT_NAV_TAB_2_ID"
print_param_simple "  - Icon" "$CURRENT_NAV_TAB_2_ICON" "$DEFAULT_NAV_TAB_2_ICON"
print_param_simple "  - Label" "$CURRENT_NAV_TAB_2_LABEL" "$DEFAULT_NAV_TAB_2_LABEL"

echo ""
echo -e "  ${CYAN}Tab 3:${NC}"
print_param_simple "  - ID" "$CURRENT_NAV_TAB_3_ID" "$DEFAULT_NAV_TAB_3_ID"
print_param_simple "  - Icon" "$CURRENT_NAV_TAB_3_ICON" "$DEFAULT_NAV_TAB_3_ICON"
print_param_simple "  - Label" "$CURRENT_NAV_TAB_3_LABEL" "$DEFAULT_NAV_TAB_3_LABEL"

echo ""
echo -e "  ${CYAN}Tab 4:${NC}"
print_param_simple "  - ID" "$CURRENT_NAV_TAB_4_ID" "$DEFAULT_NAV_TAB_4_ID"
print_param_simple "  - Icon" "$CURRENT_NAV_TAB_4_ICON" "$DEFAULT_NAV_TAB_4_ICON"
print_param_simple "  - Label" "$CURRENT_NAV_TAB_4_LABEL" "$DEFAULT_NAV_TAB_4_LABEL"

print_section "📦 Version Information"
print_param_simple "iOS Version" "$CURRENT_IOS_VERSION" "1.0"
print_param_simple "iOS Build" "$CURRENT_IOS_BUILD" "1"

print_section "🔑 OAuth Configuration"
print_param_simple "Google OAuth (iOS)" "$CURRENT_GOOGLE_OAUTH_IOS" "$DEFAULT_GOOGLE_OAUTH_IOS"

print_section "🎨 iOS App Icons"
echo ""
if [ "$ICON_COUNT" -gt 0 ]; then
    echo -e "  ${CYAN}Status:${NC}              ${GREEN}$ICON_STATUS${NC}"
    echo -e "  ${CYAN}Icon Count:${NC}          ${BLUE}$ICON_COUNT files${NC}"

    if [ -f "$IOS_ICONSET/icon-1024.png" ]; then
        echo -e "  ${CYAN}Master Icon:${NC}         ${BLUE}icon-1024.png${NC} (${ICON_1024_SIZE})"

        # Show color depth
        if echo "$ICON_1024_INFO" | grep -q "8-bit/color RGB"; then
            echo -e "  ${CYAN}Color Depth:${NC}         ${GREEN}8-bit RGB (full color)${NC}"
        elif echo "$ICON_1024_INFO" | grep -q "16-bit/color"; then
            echo -e "  ${CYAN}Color Depth:${NC}         ${GREEN}16-bit RGB (full color)${NC}"
        elif echo "$ICON_1024_INFO" | grep -q "1-bit"; then
            echo -e "  ${CYAN}Color Depth:${NC}         ${RED}1-bit (monochrome - needs update!)${NC}"
        else
            echo -e "  ${CYAN}Color Depth:${NC}         ${YELLOW}Unknown${NC}"
        fi

        # Display icon preview in terminal (if supported)
        echo ""
        echo -e "  ${CYAN}Preview:${NC} ${YELLOW}(Note: Icon preview works in iTerm2, Kitty, or with chafa installed - does not work in Mac Terminal or VS Code terminal)${NC}"
        echo ""

        # Try different methods to display the image
        # Check if we're in iTerm2
        if [ "$TERM_PROGRAM" = "iTerm.app" ] && command -v imgcat &> /dev/null; then
            # iTerm2's imgcat
            imgcat --width 10 "$IOS_ICONSET/icon-120.png" 2>/dev/null || chafa -s 20x10 "$IOS_ICONSET/icon-120.png" 2>/dev/null
        elif [ -n "$KITTY_WINDOW_ID" ] && command -v kitty &> /dev/null; then
            # Kitty terminal
            kitty +kitten icat --align left "$IOS_ICONSET/icon-120.png" 2>/dev/null || chafa -s 20x10 "$IOS_ICONSET/icon-120.png" 2>/dev/null
        elif command -v chafa &> /dev/null; then
            # Chafa - works in most terminals (Terminal.app, VS Code, etc.)
            chafa -s 25x12 "$IOS_ICONSET/icon-120.png" 2>/dev/null
        elif command -v timg &> /dev/null; then
            # timg
            timg -W 25 -H 12 "$IOS_ICONSET/icon-120.png" 2>/dev/null
        else
            echo -e "    ${YELLOW}(Install 'chafa' to see icon preview: brew install chafa)${NC}"
        fi
    fi

    echo ""
    echo -e "  ${CYAN}Location:${NC}            ${BLUE}$IOS_ICONSET${NC}"
    echo ""
    echo -e "  ${YELLOW}To update icons:${NC}"
    echo -e "    ${GREEN}./deployment/generate-app-icon.sh${NC}"
    echo -e "    or ${GREEN}./run-me-first.sh${NC} → \"🎨 Generate App Icons\""
else
    echo -e "  ${RED}Status:${NC}              ${RED}No icons found${NC}"
    echo ""
    echo -e "  ${YELLOW}Generate icons with:${NC}"
    echo -e "    ${GREEN}./deployment/generate-app-icon.sh${NC}"
fi

# ============================================================================
# Footer with Actions
# ============================================================================

echo ""
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

if [ $customized_count -eq 0 ]; then
    echo -e "${CYAN}💡 Next Steps:${NC}"
    echo "  • This template is using TacoTalk defaults"
    echo -e "  • Run ${GREEN}./init-template.sh${NC} to customize for your app"
    echo -e "  • Or use ${GREEN}./run-me-first.sh${NC} → \"Initialize template\""
    echo ""
else
    echo -e "${CYAN}💡 Available Actions:${NC}"
    echo -e "  • ${GREEN}./init-template.sh${NC}     - Reconfigure template"
    echo -e "  • ${GREEN}./revert-template.sh${NC}   - Reset to TacoTalk defaults"
    echo -e "  • ${GREEN}./run-me-first.sh${NC}      - Access deployment menu"
    echo ""
fi

echo -e "${YELLOW}📁 Files that contain these values:${NC}"
echo -e "  • package.json"
echo -e "  • capacitor.config.json"
echo -e "  • .firebaserc"
echo -e "  • index.html, web/index.html"
echo -e "  • ios/App/App/Info.plist"
echo -e "  • android/app/src/main/res/values/strings.xml"
echo -e "  • android/app/build.gradle"
echo ""
