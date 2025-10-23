#!/bin/bash

# ============================================================================
# Template Project Initializer
# ============================================================================
# This script converts the base template into a new project by prompting for
# all required information and replacing placeholders throughout the codebase.
# ============================================================================

set -e  # Exit on error

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# ============================================================================
# Helper Functions
# ============================================================================

print_header() {
    echo ""
    echo -e "${BLUE}============================================================${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}============================================================${NC}"
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

prompt_input() {
    local prompt_text="$1"
    local default_value="$2"
    local var_name="$3"

    if [ -n "$default_value" ]; then
        read -p "$(echo -e ${GREEN}$prompt_text ${NC}[${YELLOW}$default_value${NC}]): " input
        eval $var_name="${input:-$default_value}"
    else
        read -p "$(echo -e ${GREEN}$prompt_text${NC}): " input
        eval $var_name="$input"
    fi
}

confirm_proceed() {
    local message="$1"
    read -p "$(echo -e ${YELLOW}$message${NC} [y/N]): " confirm
    if [[ ! $confirm =~ ^[Yy]$ ]]; then
        print_error "Aborted by user"
        exit 1
    fi
}

# ============================================================================
# Validation Functions
# ============================================================================

validate_bundle_id() {
    local bundle_id="$1"
    if [[ ! $bundle_id =~ ^[a-z][a-z0-9]*(\.[a-z][a-z0-9]*)+$ ]]; then
        print_error "Invalid bundle ID format. Must be like: com.company.appname"
        return 1
    fi
    return 0
}

validate_email() {
    local email="$1"
    if [[ ! $email =~ ^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$ ]]; then
        print_error "Invalid email format"
        return 1
    fi
    return 0
}

# ============================================================================
# Main Script
# ============================================================================

print_header "🚀 Welcome to the Base Template Initializer"

cat << EOF
This script will help you convert this base template into your new project.

You will be prompted for the following information:
  - App name and display names
  - Bundle/Package identifiers
  - Firebase configuration
  - Company/Organization details
  - Contact information
  - App Store metadata
  - Color scheme

EOF

confirm_proceed "Ready to begin?"

# ============================================================================
# SECTION 1: Basic App Information
# ============================================================================

print_header "📱 Basic App Information"

prompt_input "App Display Name (shown under app icon)" "MyApp" APP_DISPLAY_NAME
prompt_input "App Full Name (for marketing)" "My Awesome App" APP_FULL_NAME
prompt_input "App Short Description" "A great mobile app" APP_SHORT_DESC
prompt_input "Package/Project Name (lowercase, no spaces)" "myapp" PACKAGE_NAME

# ============================================================================
# SECTION 2: Bundle/Package Identifiers
# ============================================================================

print_header "🔖 Bundle & Package Identifiers"

while true; do
    prompt_input "Bundle Identifier (e.g., com.company.appname)" "com.mycompany.myapp" BUNDLE_ID
    if validate_bundle_id "$BUNDLE_ID"; then
        break
    fi
done

# Extract package path from bundle ID (e.g., com.company.app -> com/company/app)
PACKAGE_PATH=$(echo $BUNDLE_ID | tr '.' '/')

# ============================================================================
# SECTION 3: Firebase Configuration
# ============================================================================

print_header "🔥 Firebase Configuration"
print_header "https://github.com/firebase/firebase-ios-sdk <-- not used in webview app but useful link"

echo "You can find these values in your Firebase console:"
echo "https://console.firebase.google.com/ → Project Settings → General"
# import SwiftUI
# import FirebaseCore


# class AppDelegate: NSObject, UIApplicationDelegate {
#   func application(_ application: UIApplication,
#                    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
#     FirebaseApp.configure()

#     return true
#   }
# }

# @main
# struct YourApp: App {
#   // register app delegate for Firebase setup
#   @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate


#   var body: some Scene {
#     WindowGroup {
#       NavigationView {
#         ContentView()
#       }
#     }
#   }
# }
echo ""

prompt_input "Firebase Project ID" "my-app-12345" FIREBASE_PROJECT_ID
prompt_input "Firebase API Key" "" FIREBASE_API_KEY
prompt_input "Firebase Auth Domain" "${FIREBASE_PROJECT_ID}.firebaseapp.com" FIREBASE_AUTH_DOMAIN
prompt_input "Firebase Storage Bucket" "${FIREBASE_PROJECT_ID}.firebasestorage.app" FIREBASE_STORAGE_BUCKET
prompt_input "Firebase Messaging Sender ID" "" FIREBASE_SENDER_ID
prompt_input "Firebase App ID" "" FIREBASE_APP_ID

# ============================================================================
# SECTION 4: Company/Organization Information
# ============================================================================

print_header "🏢 Company/Organization Information"

prompt_input "Company/Organization Name" "My Company" COMPANY_NAME
prompt_input "Company Website" "www.mycompany.com" COMPANY_WEBSITE
prompt_input "Developer Name" "John Doe" DEVELOPER_NAME

# ============================================================================
# SECTION 5: Contact Information
# ============================================================================

print_header "📧 Contact Information"

while true; do
    prompt_input "Support Email" "support@myapp.com" SUPPORT_EMAIL
    if validate_email "$SUPPORT_EMAIL"; then
        break
    fi
done

while true; do
    prompt_input "Privacy Email" "privacy@myapp.com" PRIVACY_EMAIL
    if validate_email "$PRIVACY_EMAIL"; then
        break
    fi
done

prompt_input "Contact Phone (with country code)" "+1 (555) 555-5555" CONTACT_PHONE
prompt_input "Company Address" "123 Main St, City, State, ZIP, Country" COMPANY_ADDRESS

# ============================================================================
# SECTION 6: URLs & Deployment
# ============================================================================

print_header "🌐 URLs & Deployment"

prompt_input "Primary Domain/URL (without https://)" "myapp.com" PRIMARY_DOMAIN
prompt_input "Netlify Site Name (if using Netlify)" "myapp" NETLIFY_SITE

# ============================================================================
# SECTION 7: App Store Metadata
# ============================================================================

print_header "🏪 App Store Metadata"

prompt_input "App Category" "Education" APP_CATEGORY
prompt_input "Keywords (comma-separated)" "app,mobile,productivity" APP_KEYWORDS
prompt_input "Age Rating" "4+" AGE_RATING

# ============================================================================
# SECTION 8: Design & Branding
# ============================================================================

print_header "🎨 Design & Branding"

prompt_input "Primary Brand Color (hex)" "#667eea" PRIMARY_COLOR

# ============================================================================
# SECTION 9: Bottom Navigation Bar
# ============================================================================

print_header "📱 Bottom Navigation Bar (4 tabs)"

echo "Configure your app's bottom navigation tabs:"
echo ""

prompt_input "Tab 1 Icon (emoji)" "🏠" NAV_TAB_1_ICON
prompt_input "Tab 1 Label" "Home" NAV_TAB_1_LABEL
prompt_input "Tab 1 ID (lowercase, no spaces)" "home" NAV_TAB_1_ID

prompt_input "Tab 2 Icon (emoji)" "🔍" NAV_TAB_2_ICON
prompt_input "Tab 2 Label" "Explore" NAV_TAB_2_LABEL
prompt_input "Tab 2 ID (lowercase, no spaces)" "explore" NAV_TAB_2_ID

prompt_input "Tab 3 Icon (emoji)" "⭐" NAV_TAB_3_ICON
prompt_input "Tab 3 Label" "Favorites" NAV_TAB_3_LABEL
prompt_input "Tab 3 ID (lowercase, no spaces)" "favorites" NAV_TAB_3_ID

prompt_input "Tab 4 Icon (emoji)" "👤" NAV_TAB_4_ICON
prompt_input "Tab 4 Label" "Profile" NAV_TAB_4_LABEL
prompt_input "Tab 4 ID (lowercase, no spaces)" "profile" NAV_TAB_4_ID

# ============================================================================
# SECTION 10: OAuth Configuration (Optional)
# ============================================================================

print_header "🔐 OAuth Configuration (Optional - press Enter to skip)"

prompt_input "Google OAuth Client ID (iOS)" "" GOOGLE_OAUTH_IOS

# ============================================================================
# SECTION 11: Master/Developer Login (Testing Only)
# ============================================================================

print_header "🔓 Master Login for Development/Testing"

echo "Configure backdoor credentials that bypass Firebase (for local testing only)"
echo "⚠️  IMPORTANT: Remove from production builds!"
echo ""

prompt_input "Master Email" "dev@master.local" MASTER_EMAIL
prompt_input "Master Password" "master123" MASTER_PASSWORD

# ============================================================================
# Review & Confirm
# ============================================================================

print_header "📋 Configuration Summary"

cat << EOF
App Information:
  Display Name:       ${APP_DISPLAY_NAME}
  Full Name:          ${APP_FULL_NAME}
  Package Name:       ${PACKAGE_NAME}
  Bundle ID:          ${BUNDLE_ID}

Firebase:
  Project ID:         ${FIREBASE_PROJECT_ID}
  Auth Domain:        ${FIREBASE_AUTH_DOMAIN}

Company:
  Name:               ${COMPANY_NAME}
  Website:            ${COMPANY_WEBSITE}
  Developer:          ${DEVELOPER_NAME}

Contact:
  Support Email:      ${SUPPORT_EMAIL}
  Privacy Email:      ${PRIVACY_EMAIL}
  Phone:              ${CONTACT_PHONE}

Deployment:
  Domain:             ${PRIMARY_DOMAIN}
  Netlify Site:       ${NETLIFY_SITE}

Design:
  Primary Color:      ${PRIMARY_COLOR}

EOF

confirm_proceed "Does everything look correct? This will modify the project files."

# ============================================================================
# Apply Template Replacements
# ============================================================================

print_header "🔄 Applying Template Configuration"

# Create backup
BACKUP_DIR="backups/pre-template-init-$(date +%Y%m%d-%H%M%S)"
print_warning "Creating backup at: $BACKUP_DIR"
mkdir -p "$BACKUP_DIR"

# Function to safely replace in file
replace_in_file() {
    local file="$1"
    local search="$2"
    local replace="$3"

    if [ -f "$file" ]; then
        # Create backup
        cp "$file" "$BACKUP_DIR/$(basename $file).bak" 2>/dev/null || true
        # Replace using sed (cross-platform compatible)
        if [[ "$OSTYPE" == "darwin"* ]]; then
            sed -i '' "s|$search|$replace|g" "$file"
        else
            sed -i "s|$search|$replace|g" "$file"
        fi
    fi
}

# ============================================================================
# Replace in Configuration Files
# ============================================================================

echo "Updating configuration files..."

# package.json
replace_in_file "package.json" "speech-therapy-app" "$PACKAGE_NAME"
replace_in_file "package.json" "Speech Reading Trainer.*" "$APP_SHORT_DESC"

# capacitor.config.json
replace_in_file "capacitor.config.json" "com.speechtherapy.app" "$BUNDLE_ID"
replace_in_file "capacitor.config.json" "Speech Therapy" "$APP_DISPLAY_NAME"
replace_in_file "capacitor.config.json" "#667eea" "$PRIMARY_COLOR"

# .firebaserc
replace_in_file ".firebaserc" "speechtherapy-fa851" "$FIREBASE_PROJECT_ID"

# ============================================================================
# Replace in Main HTML Files
# ============================================================================

echo "Updating HTML files..."

# index.html - Firebase config
replace_in_file "index.html" "iSpeakClear" "$APP_DISPLAY_NAME"
replace_in_file "index.html" "AIzaSyDLgMyx61LAewI3InaKKPOneXV3pMFrxvk" "$FIREBASE_API_KEY"
replace_in_file "index.html" "speechtherapy-fa851.firebaseapp.com" "$FIREBASE_AUTH_DOMAIN"
replace_in_file "index.html" "speechtherapy-fa851" "$FIREBASE_PROJECT_ID"
replace_in_file "index.html" "speechtherapy-fa851.firebasestorage.app" "$FIREBASE_STORAGE_BUCKET"
replace_in_file "index.html" "734817707263" "$FIREBASE_SENDER_ID"
replace_in_file "index.html" "1:734817707263:web:30723e86ca33b11c7858ca" "$FIREBASE_APP_ID"
replace_in_file "index.html" "Natraj Bontha" "$DEVELOPER_NAME"

# web/index.html
replace_in_file "web/index.html" "iSpeakClear" "$APP_DISPLAY_NAME"
replace_in_file "web/index.html" "AIzaSyDLgMyx61LAewI3InaKKPOneXV3pMFrxvk" "$FIREBASE_API_KEY"
replace_in_file "web/index.html" "speechtherapy-fa851.firebaseapp.com" "$FIREBASE_AUTH_DOMAIN"
replace_in_file "web/index.html" "speechtherapy-fa851" "$FIREBASE_PROJECT_ID"
replace_in_file "web/index.html" "speechtherapy-fa851.firebasestorage.app" "$FIREBASE_STORAGE_BUCKET"
replace_in_file "web/index.html" "734817707263" "$FIREBASE_SENDER_ID"
replace_in_file "web/index.html" "1:734817707263:web:30723e86ca33b11c7858ca" "$FIREBASE_APP_ID"
replace_in_file "web/index.html" "Natraj Bontha" "$DEVELOPER_NAME"

# Replace navbar configuration
replace_in_file "index.html" "{{NAV_TAB_1_ICON}}" "$NAV_TAB_1_ICON"
replace_in_file "index.html" "{{NAV_TAB_1_LABEL}}" "$NAV_TAB_1_LABEL"
replace_in_file "index.html" "{{NAV_TAB_1_ID}}" "$NAV_TAB_1_ID"

replace_in_file "index.html" "{{NAV_TAB_2_ICON}}" "$NAV_TAB_2_ICON"
replace_in_file "index.html" "{{NAV_TAB_2_LABEL}}" "$NAV_TAB_2_LABEL"
replace_in_file "index.html" "{{NAV_TAB_2_ID}}" "$NAV_TAB_2_ID"

replace_in_file "index.html" "{{NAV_TAB_3_ICON}}" "$NAV_TAB_3_ICON"
replace_in_file "index.html" "{{NAV_TAB_3_LABEL}}" "$NAV_TAB_3_LABEL"
replace_in_file "index.html" "{{NAV_TAB_3_ID}}" "$NAV_TAB_3_ID"

replace_in_file "index.html" "{{NAV_TAB_4_ICON}}" "$NAV_TAB_4_ICON"
replace_in_file "index.html" "{{NAV_TAB_4_LABEL}}" "$NAV_TAB_4_LABEL"
replace_in_file "index.html" "{{NAV_TAB_4_ID}}" "$NAV_TAB_4_ID"

replace_in_file "web/index.html" "{{NAV_TAB_1_ICON}}" "$NAV_TAB_1_ICON"
replace_in_file "web/index.html" "{{NAV_TAB_1_LABEL}}" "$NAV_TAB_1_LABEL"
replace_in_file "web/index.html" "{{NAV_TAB_1_ID}}" "$NAV_TAB_1_ID"

replace_in_file "web/index.html" "{{NAV_TAB_2_ICON}}" "$NAV_TAB_2_ICON"
replace_in_file "web/index.html" "{{NAV_TAB_2_LABEL}}" "$NAV_TAB_2_LABEL"
replace_in_file "web/index.html" "{{NAV_TAB_2_ID}}" "$NAV_TAB_2_ID"

replace_in_file "web/index.html" "{{NAV_TAB_3_ICON}}" "$NAV_TAB_3_ICON"
replace_in_file "web/index.html" "{{NAV_TAB_3_LABEL}}" "$NAV_TAB_3_LABEL"
replace_in_file "web/index.html" "{{NAV_TAB_3_ID}}" "$NAV_TAB_3_ID"

replace_in_file "web/index.html" "{{NAV_TAB_4_ICON}}" "$NAV_TAB_4_ICON"
replace_in_file "web/index.html" "{{NAV_TAB_4_LABEL}}" "$NAV_TAB_4_LABEL"
replace_in_file "web/index.html" "{{NAV_TAB_4_ID}}" "$NAV_TAB_4_ID"

# Replace master credentials
replace_in_file "index.html" "{{MASTER_EMAIL}}" "$MASTER_EMAIL"
replace_in_file "index.html" "{{MASTER_PASSWORD}}" "$MASTER_PASSWORD"
replace_in_file "web/index.html" "{{MASTER_EMAIL}}" "$MASTER_EMAIL"
replace_in_file "web/index.html" "{{MASTER_PASSWORD}}" "$MASTER_PASSWORD"

# ============================================================================
# Replace in iOS Files
# ============================================================================

echo "Updating iOS configuration..."

# iOS Info.plist
replace_in_file "ios/App/App/Info.plist" "iSpeakClear" "$APP_DISPLAY_NAME"
replace_in_file "ios/App/App/Info.plist" "com.speechtherapy.app" "$BUNDLE_ID"

# iOS project.pbxproj
replace_in_file "ios/App/App.xcodeproj/project.pbxproj" "Speech Therapy" "$APP_DISPLAY_NAME"
replace_in_file "ios/App/App.xcodeproj/project.pbxproj" "com.speechtherapy.app" "$BUNDLE_ID"

# iOS capacitor.config.json (if exists)
if [ -f "ios/App/App/capacitor.config.json" ]; then
    replace_in_file "ios/App/App/capacitor.config.json" "com.speechtherapy.app" "$BUNDLE_ID"
    replace_in_file "ios/App/App/capacitor.config.json" "Speech Therapy" "$APP_DISPLAY_NAME"
fi

# ============================================================================
# Replace in Android Files
# ============================================================================

echo "Updating Android configuration..."

# Android build.gradle
replace_in_file "android/app/build.gradle" "com.speechtherapy.app" "$BUNDLE_ID"

# Android strings.xml
replace_in_file "android/app/src/main/res/values/strings.xml" "Speech Therapy" "$APP_DISPLAY_NAME"
replace_in_file "android/app/src/main/res/values/strings.xml" "com.speechtherapy.app" "$BUNDLE_ID"

# Rename Android package directory if needed
OLD_PACKAGE_PATH="android/app/src/main/java/com/speechtherapy/app"
NEW_PACKAGE_PATH="android/app/src/main/java/$PACKAGE_PATH"

if [ -d "$OLD_PACKAGE_PATH" ] && [ "$OLD_PACKAGE_PATH" != "$NEW_PACKAGE_PATH" ]; then
    echo "Renaming Android package directory..."
    mkdir -p "$(dirname $NEW_PACKAGE_PATH)"
    mv "$OLD_PACKAGE_PATH" "$NEW_PACKAGE_PATH"

    # Update MainActivity.java package declaration
    replace_in_file "$NEW_PACKAGE_PATH/MainActivity.java" "package com.speechtherapy.app;" "package $BUNDLE_ID;"
fi

# ============================================================================
# Replace in Documentation Files
# ============================================================================

echo "Updating documentation..."

# Update deployment scripts
for script in deployment/*.sh; do
    if [ -f "$script" ]; then
        replace_in_file "$script" "speechtherapy-fa851" "$FIREBASE_PROJECT_ID"
        replace_in_file "$script" "com.speechtherapy.app" "$BUNDLE_ID"
        replace_in_file "$script" "Speech Therapy" "$APP_DISPLAY_NAME"
    fi
done

# ============================================================================
# Update Privacy & Marketing Files
# ============================================================================

echo "Updating privacy and marketing files..."

# These files need manual review, so we'll create template versions
cat > "README.md" << 'EOFREADME'
# {{APP_FULL_NAME}}

{{APP_SHORT_DESC}}

## Features

- Feature 1
- Feature 2
- Feature 3

## Installation

[Add installation instructions]

## Usage

[Add usage instructions]

## Support

For support, email {{SUPPORT_EMAIL}}

## Privacy

See our [Privacy Policy](privacy.html) for details.

## License

[Add license information]

EOFREADME

replace_in_file "README.md" "{{APP_FULL_NAME}}" "$APP_FULL_NAME"
replace_in_file "README.md" "{{APP_SHORT_DESC}}" "$APP_SHORT_DESC"
replace_in_file "README.md" "{{SUPPORT_EMAIL}}" "$SUPPORT_EMAIL"

# ============================================================================
# Create Configuration Summary File
# ============================================================================

cat > ".template-config" << EOF
# Template Configuration
# Generated on $(date)

APP_DISPLAY_NAME="$APP_DISPLAY_NAME"
APP_FULL_NAME="$APP_FULL_NAME"
APP_SHORT_DESC="$APP_SHORT_DESC"
PACKAGE_NAME="$PACKAGE_NAME"
BUNDLE_ID="$BUNDLE_ID"

FIREBASE_PROJECT_ID="$FIREBASE_PROJECT_ID"
FIREBASE_API_KEY="$FIREBASE_API_KEY"
FIREBASE_AUTH_DOMAIN="$FIREBASE_AUTH_DOMAIN"
FIREBASE_STORAGE_BUCKET="$FIREBASE_STORAGE_BUCKET"
FIREBASE_SENDER_ID="$FIREBASE_SENDER_ID"
FIREBASE_APP_ID="$FIREBASE_APP_ID"

COMPANY_NAME="$COMPANY_NAME"
COMPANY_WEBSITE="$COMPANY_WEBSITE"
DEVELOPER_NAME="$DEVELOPER_NAME"

SUPPORT_EMAIL="$SUPPORT_EMAIL"
PRIVACY_EMAIL="$PRIVACY_EMAIL"
CONTACT_PHONE="$CONTACT_PHONE"
COMPANY_ADDRESS="$COMPANY_ADDRESS"

PRIMARY_DOMAIN="$PRIMARY_DOMAIN"
NETLIFY_SITE="$NETLIFY_SITE"

APP_CATEGORY="$APP_CATEGORY"
APP_KEYWORDS="$APP_KEYWORDS"
AGE_RATING="$AGE_RATING"

PRIMARY_COLOR="$PRIMARY_COLOR"
EOF

print_success "Configuration saved to .template-config"

# ============================================================================
# Final Steps
# ============================================================================

print_header "✅ Template Initialization Complete!"

cat << EOF
Your project has been configured with the following:

  App Name:     ${APP_DISPLAY_NAME}
  Bundle ID:    ${BUNDLE_ID}
  Firebase:     ${FIREBASE_PROJECT_ID}

${YELLOW}Important Next Steps:${NC}

1. Review and update the following files manually:
   - README.md (add detailed app description)
   - PRIVACY_POLICY.md (update privacy policy)
   - APP_STORE_INFO.md (add App Store metadata)

2. Replace placeholder images:
   - icon.jpg (app icon source)
   - images/* (app-specific images)
   - iOS: ios/App/App/Assets.xcassets/
   - Android: android/app/src/main/res/

3. Update Firebase configuration files:
   - ios/App/App/GoogleService-Info.plist
   - android/app/google-services.json (if using Android)

4. Review and test:
   - Run: npm install
   - Run: npx cap sync
   - Test on iOS/Android

5. Remove app-specific documentation:
   - AGE_RATING_GUIDE.md
   - EXPORT_COMPLIANCE_GUIDE.md
   - FIXABLE_ISSUES.md

${GREEN}Backup created at: ${BACKUP_DIR}${NC}

${BLUE}Happy building! 🚀${NC}

EOF
