#!/bin/bash

# ============================================================================
# Template Revert Script
# ============================================================================
# This script reverts the template back to its original TacoTalk configuration
# Useful for:
# - Starting over after a mistake
# - Resetting after testing
# - Returning to clean slate
# ============================================================================

set -e  # Exit on error

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

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

print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠ $1${NC}"
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
}

# Function to replace in file
replace_in_file() {
    local file="$1"
    local search="$2"
    local replace="$3"

    if [ -f "$file" ]; then
        # Escape special characters for sed
        search_escaped=$(echo "$search" | sed 's/[[\.*^$/]/\\&/g')
        replace_escaped=$(echo "$replace" | sed 's/[\/&]/\\&/g')

        sed -i '' "s|${search_escaped}|${replace_escaped}|g" "$file" 2>/dev/null || true
        return 0
    else
        print_warning "File not found: $file"
        return 1
    fi
}

# Function to replace ANY value with template value (works for both template vars and actual values)
smart_replace_in_file() {
    local file="$1"
    local template_var="$2"
    local new_value="$3"

    if [ ! -f "$file" ]; then
        return 1
    fi

    # First try to replace the template variable itself
    sed -i '' "s|${template_var}|${new_value}|g" "$file" 2>/dev/null || true

    # Then do a smart replacement - this will catch actual values
    # We'll read the file and do intelligent replacement
    if [ -f "$file" ]; then
        # Use perl for more robust replacement
        perl -i -pe "s|${template_var}|${new_value}|g" "$file" 2>/dev/null || true
    fi
}

# ============================================================================
# Default TacoTalk Template Values
# ============================================================================

APP_DISPLAY_NAME="TacoTalk"
APP_FULL_NAME="TacoTalk - The Ultimate Burrito Debate Platform"
APP_SHORT_DESC="A revolutionary app for serious taco enthusiasts"
PACKAGE_NAME="tacotalk"
BUNDLE_ID="com.burrito.tacotalk"
FIREBASE_PROJECT_ID="tacotalk-firebase-42"
FIREBASE_API_KEY="AIzaSyTest123FakeTacoKey456"
FIREBASE_AUTH_DOMAIN="tacotalk-firebase-42.firebaseapp.com"
FIREBASE_STORAGE_BUCKET="tacotalk-firebase-42.firebasestorage.app"
FIREBASE_SENDER_ID="987654321"
FIREBASE_APP_ID="1:987654321:web:abc123tacotest"
FIREBASE_MEASUREMENT_ID="G-TACOTEST123"
COMPANY_NAME="Taco Innovations Inc"
COMPANY_WEBSITE="www.tacoinnovations.io"
DEVELOPER_NAME="Chef Burrito McGuacamole"
SUPPORT_EMAIL="tacos@tacotalk.app"
PRIVACY_EMAIL="privacy@tacotalk.app"
CONTACT_PHONE="+1 (555) TACO-TIME"
COMPANY_ADDRESS="123 Salsa Street, Guac City, TX 78701, USA"
PRIMARY_DOMAIN="tacotalk.app"
NETLIFY_SITE="tacotalk"
APP_CATEGORY="Food & Drink"
APP_KEYWORDS="tacos,burritos,food,debate,community"
AGE_RATING="4+"
PRIMARY_COLOR="#FF6B35"
GOOGLE_OAUTH_IOS="com.googleusercontent.apps.tacotalk-test"
LOGIN_ICON="🌮"
NAV_TAB_1_ID="home"
NAV_TAB_1_ICON="🏠"
NAV_TAB_1_LABEL="Home"
NAV_TAB_2_ID="explore"
NAV_TAB_2_ICON="🔍"
NAV_TAB_2_LABEL="Explore"
NAV_TAB_3_ID="favorites"
NAV_TAB_3_ICON="⭐"
NAV_TAB_3_LABEL="Favorites"
NAV_TAB_4_ID="profile"
NAV_TAB_4_ICON="👤"
NAV_TAB_4_LABEL="Profile"

# ============================================================================
# Main Script
# ============================================================================

print_header "🔄 Template Revert Tool"

cat << EOF
${YELLOW}⚠️  WARNING${NC}

This will revert the template back to its original TacoTalk configuration.

${CYAN}What will be reset:${NC}
  • App name → TacoTalk
  • Bundle ID → com.burrito.tacotalk
  • Firebase config → Test credentials
  • All branding and theming
  • Navigation configuration

${CYAN}What will NOT be affected:${NC}
  • Your custom code changes
  • Additional files you've added
  • Git history

${YELLOW}This is useful for:${NC}
  • Starting over after a mistake
  • Testing the init-template.sh script
  • Returning to a clean slate

EOF

read -p "$(echo -e ${YELLOW}Continue with revert? [y/N]:${NC} )" confirm
if [[ ! $confirm =~ ^[Yy]$ ]]; then
    print_error "Revert cancelled"
    exit 0
fi

echo ""
print_header "Reverting to TacoTalk Template"

# ============================================================================
# Get Current Values (to show what's being replaced)
# ============================================================================

echo -e "${BLUE}📋 Detecting current configuration...${NC}"
echo ""

# Try to detect current values from files
CURRENT_APP_NAME=$(grep -o '"name": "[^"]*"' package.json 2>/dev/null | cut -d'"' -f4 || echo "unknown")
CURRENT_BUNDLE_ID=$(grep -o '"appId": "[^"]*"' capacitor.config.json 2>/dev/null | cut -d'"' -f4 || echo "unknown")

echo -e "  Current App Name: ${YELLOW}$CURRENT_APP_NAME${NC}"
echo -e "  Current Bundle ID: ${YELLOW}$CURRENT_BUNDLE_ID${NC}"
echo ""
echo -e "  Reverting to: ${GREEN}$APP_DISPLAY_NAME${NC} (${GREEN}$BUNDLE_ID${NC})"
echo ""

# ============================================================================
# Create Backup
# ============================================================================

BACKUP_DIR=".template-backups"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
BACKUP_PATH="$BACKUP_DIR/pre-revert-$TIMESTAMP"

echo -e "${BLUE}💾 Creating backup...${NC}"
mkdir -p "$BACKUP_PATH"

# Backup key files
cp package.json "$BACKUP_PATH/" 2>/dev/null || true
cp capacitor.config.json "$BACKUP_PATH/" 2>/dev/null || true
cp .firebaserc "$BACKUP_PATH/" 2>/dev/null || true
cp index.html "$BACKUP_PATH/" 2>/dev/null || true
cp -r web "$BACKUP_PATH/" 2>/dev/null || true
cp ios/App/App/Info.plist "$BACKUP_PATH/" 2>/dev/null || true

print_success "Backup created at: $BACKUP_PATH"
echo ""

# ============================================================================
# Revert Configuration Files
# ============================================================================

echo -e "${BLUE}📝 Reverting configuration files...${NC}"

# package.json
if [ -f "package.json" ]; then
    # Replace current values with TacoTalk values
    sed -i '' "s|\"name\": \".*\"|\"name\": \"$PACKAGE_NAME\"|g" package.json
    sed -i '' "s|\"description\": \".*\"|\"description\": \"$APP_SHORT_DESC\"|g" package.json
    print_success "package.json reverted"
fi

# capacitor.config.json
if [ -f "capacitor.config.json" ]; then
    sed -i '' "s|\"appId\": \".*\"|\"appId\": \"$BUNDLE_ID\"|g" capacitor.config.json
    sed -i '' "s|\"appName\": \".*\"|\"appName\": \"$APP_DISPLAY_NAME\"|g" capacitor.config.json
    print_success "capacitor.config.json reverted"
fi

# .firebaserc
if [ -f ".firebaserc" ]; then
    sed -i '' "s|\"default\": \".*\"|\"default\": \"$FIREBASE_PROJECT_ID\"|g" .firebaserc
    print_success ".firebaserc reverted"
fi

echo ""

# ============================================================================
# Revert HTML Files (Web & iOS)
# ============================================================================

echo -e "${BLUE}🌐 Reverting HTML files...${NC}"

revert_html_file() {
    local file="$1"

    if [ ! -f "$file" ]; then
        return
    fi

    # App identity
    sed -i '' "s|<title>.*</title>|<title>$APP_DISPLAY_NAME</title>|g" "$file"

    # Firebase config - use more specific patterns
    sed -i '' "s|apiKey: \"[^\"]*\"|apiKey: \"$FIREBASE_API_KEY\"|g" "$file"
    sed -i '' "s|authDomain: \"[^\"]*\"|authDomain: \"$FIREBASE_AUTH_DOMAIN\"|g" "$file"
    sed -i '' "s|projectId: \"[^\"]*\"|projectId: \"$FIREBASE_PROJECT_ID\"|g" "$file"
    sed -i '' "s|storageBucket: \"[^\"]*\"|storageBucket: \"$FIREBASE_STORAGE_BUCKET\"|g" "$file"
    sed -i '' "s|messagingSenderId: \"[^\"]*\"|messagingSenderId: \"$FIREBASE_SENDER_ID\"|g" "$file"
    sed -i '' "s|appId: \"[^\"]*\"|appId: \"$FIREBASE_APP_ID\"|g" "$file"
    sed -i '' "s|measurementId: \"[^\"]*\"|measurementId: \"$FIREBASE_MEASUREMENT_ID\"|g" "$file"

    # Replace developer name in copyright
    sed -i '' "s|© 2025 [^<]*</div>|© 2025 $DEVELOPER_NAME</div>|g" "$file"

    # Navigation configuration
    sed -i '' "s|<div class=\"nav-icon\">[^<]*</div><!-- login-icon -->|<div class=\"nav-icon\">$LOGIN_ICON</div><!-- login-icon -->|g" "$file"

    # Tab configurations - more specific patterns
    sed -i '' "s|data-tab=\"[^\"]*\" class=\"nav-item\">.*<div class=\"nav-icon\">🏠|data-tab=\"$NAV_TAB_1_ID\" class=\"nav-item\"><div class=\"nav-icon\">$NAV_TAB_1_ICON|g" "$file"
    sed -i '' "s|<div class=\"nav-label\">[^<]*</div>.*<!-- tab1-label -->|<div class=\"nav-label\">$NAV_TAB_1_LABEL</div><!-- tab1-label -->|g" "$file"

    sed -i '' "s|data-tab=\"[^\"]*\" class=\"nav-item\">.*<div class=\"nav-icon\">🔍|data-tab=\"$NAV_TAB_2_ID\" class=\"nav-item\"><div class=\"nav-icon\">$NAV_TAB_2_ICON|g" "$file"
    sed -i '' "s|<div class=\"nav-label\">[^<]*</div>.*<!-- tab2-label -->|<div class=\"nav-label\">$NAV_TAB_2_LABEL</div><!-- tab2-label -->|g" "$file"

    sed -i '' "s|data-tab=\"[^\"]*\" class=\"nav-item\">.*<div class=\"nav-icon\">⭐|data-tab=\"$NAV_TAB_3_ID\" class=\"nav-item\"><div class=\"nav-icon\">$NAV_TAB_3_ICON|g" "$file"
    sed -i '' "s|<div class=\"nav-label\">[^<]*</div>.*<!-- tab3-label -->|<div class=\"nav-label\">$NAV_TAB_3_LABEL</div><!-- tab3-label -->|g" "$file"

    sed -i '' "s|data-tab=\"[^\"]*\" class=\"nav-item\">.*<div class=\"nav-icon\">👤|data-tab=\"$NAV_TAB_4_ID\" class=\"nav-item\"><div class=\"nav-icon\">$NAV_TAB_4_ICON|g" "$file"
    sed -i '' "s|<div class=\"nav-label\">[^<]*</div>.*<!-- tab4-label -->|<div class=\"nav-label\">$NAV_TAB_4_LABEL</div><!-- tab4-label -->|g" "$file"
}

revert_html_file "index.html"
print_success "index.html reverted"

revert_html_file "web/index.html"
print_success "web/index.html reverted"

# iOS public folder
if [ -d "ios/App/App/public" ]; then
    revert_html_file "ios/App/App/public/index.html"
    print_success "ios/App/App/public/index.html reverted"
fi

echo ""

# ============================================================================
# Revert iOS Configuration
# ============================================================================

echo -e "${BLUE}📱 Reverting iOS configuration...${NC}"

if [ -f "ios/App/App/Info.plist" ]; then
    # CFBundleDisplayName
    sed -i '' "s|<key>CFBundleDisplayName</key>[[:space:]]*<string>.*</string>|<key>CFBundleDisplayName</key>\
	<string>$APP_DISPLAY_NAME</string>|g" ios/App/App/Info.plist

    # CFBundleURLName
    sed -i '' "s|<key>CFBundleURLName</key>[[:space:]]*<string>.*</string>|<key>CFBundleURLName</key>\
			<string>$BUNDLE_ID</string>|g" ios/App/App/Info.plist

    # CFBundleURLSchemes
    sed -i '' "s|<string>com\.googleusercontent\.apps\..*</string>|<string>$GOOGLE_OAUTH_IOS</string>|g" ios/App/App/Info.plist

    # Reset version to 1.0 build 1
    sed -i '' "s|<key>CFBundleShortVersionString</key>[[:space:]]*<string>.*</string>|<key>CFBundleShortVersionString</key>\
	<string>1.0</string>|g" ios/App/App/Info.plist

    sed -i '' "s|<key>CFBundleVersion</key>[[:space:]]*<string>.*</string>|<key>CFBundleVersion</key>\
	<string>1</string>|g" ios/App/App/Info.plist

    print_success "iOS Info.plist reverted (version reset to 1.0 build 1)"
fi

echo ""

# ============================================================================
# Revert Android Configuration
# ============================================================================

echo -e "${BLUE}🤖 Reverting Android configuration...${NC}"

# strings.xml
if [ -f "android/app/src/main/res/values/strings.xml" ]; then
    sed -i '' "s|<string name=\"app_name\">.*</string>|<string name=\"app_name\">$APP_DISPLAY_NAME</string>|g" android/app/src/main/res/values/strings.xml
    sed -i '' "s|<string name=\"package_name\">.*</string>|<string name=\"package_name\">$BUNDLE_ID</string>|g" android/app/src/main/res/values/strings.xml
    print_success "Android strings.xml reverted"
fi

# build.gradle
if [ -f "android/app/build.gradle" ]; then
    sed -i '' "s|applicationId \".*\"|applicationId \"$BUNDLE_ID\"|g" android/app/build.gradle
    sed -i '' "s|versionCode [0-9]*|versionCode 1|g" android/app/build.gradle
    sed -i '' "s|versionName \".*\"|versionName \"1.0\"|g" android/app/build.gradle
    print_success "Android build.gradle reverted (version reset to 1.0 build 1)"
fi

echo ""

# ============================================================================
# Summary
# ============================================================================

print_header "✅ Revert Complete!"

cat << EOF
${GREEN}Template has been reverted to TacoTalk configuration${NC}

${CYAN}Configuration:${NC}
  • App Name: ${GREEN}$APP_DISPLAY_NAME${NC}
  • Bundle ID: ${GREEN}$BUNDLE_ID${NC}
  • Version: ${GREEN}1.0 (build 1)${NC}
  • Firebase: ${GREEN}$FIREBASE_PROJECT_ID${NC} (test credentials)

${CYAN}Backup Location:${NC}
  ${YELLOW}$BACKUP_PATH${NC}

${CYAN}Next Steps:${NC}
  1. Run: ${GREEN}npm install${NC}
  2. Sync: ${GREEN}./run-me-first.sh${NC} → "🔄 Sync web to iOS"
  3. Test the app
  4. When ready, run: ${GREEN}./init-template.sh${NC} to reconfigure

${YELLOW}Note:${NC} You can restore from backup if needed by copying files from:
  $BACKUP_PATH

EOF

print_success "Revert completed successfully!"
echo ""
