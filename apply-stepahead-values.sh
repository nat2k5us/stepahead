#!/bin/bash
# StepAhead App Template Configuration
# Applies all StepAhead-specific values to the template

set -e

echo "Applying StepAhead template values..."

# Define all values for StepAhead
APP_DISPLAY_NAME="StepAhead"
APP_FULL_NAME="StepAhead - Daily Task Helper"
APP_SHORT_DESC="Simple step-by-step household tasks for everyone"
PACKAGE_NAME="stepahead"
APP_KEYWORDS="tasks,household,daily,productivity,autism,memory,organization"
BUNDLE_ID="com.stepahead.app"
FIREBASE_PROJECT_ID="stepahead-519b0"
FIREBASE_API_KEY="AIzaSyDpD1Vv3WsRjB2g7zZjohO3I24sMJsHLGw"
FIREBASE_AUTH_DOMAIN="stepahead-519b0.firebaseapp.com"
FIREBASE_STORAGE_BUCKET="stepahead-519b0.firebasestorage.app"
FIREBASE_SENDER_ID="335105043215"
FIREBASE_APP_ID="1:335105043215:web:stepahead"
FIREBASE_MEASUREMENT_ID="G-STEPAHEAD"
COMPANY_NAME="StepAhead Apps"
COMPANY_WEBSITE="www.stepahead.app"
DEVELOPER_NAME="Natraj Bontha"
SUPPORT_EMAIL="support@stepahead.app"
PRIVACY_EMAIL="privacy@stepahead.app"
CONTACT_PHONE="+1 (555) 555-5555"
COMPANY_ADDRESS="123 Main St, City, State, ZIP, USA"
PRIMARY_DOMAIN="stepahead.app"
NETLIFY_SITE="stepahead"
APP_CATEGORY="Productivity"
APP_KEYWORDS="tasks,household,daily,productivity,autism,memory,organization"
AGE_RATING="4+"
PRIMARY_COLOR="#667eea"
GOOGLE_OAUTH_IOS=""

# Master login credentials (for testing only)
MASTER_EMAIL="dev@master.local"
MASTER_PASSWORD="master123"

# Navigation bar configuration - Simple single-page app
LOGIN_ICON="🏠"
NAV_TAB_1_ID="home"
NAV_TAB_1_ICON="📅"
NAV_TAB_1_LABEL="Days"
NAV_TAB_2_ID="settings"
NAV_TAB_2_ICON="⚙️"
NAV_TAB_2_LABEL="Settings"
NAV_TAB_3_ID="help"
NAV_TAB_3_ICON="❓"
NAV_TAB_3_LABEL="Help"
NAV_TAB_4_ID="profile"
NAV_TAB_4_ICON="👤"
NAV_TAB_4_LABEL="Profile"

# Function to replace in file
replace_in_file() {
    local file="$1"
    local search="$2"
    local replace="$3"

    if [ -f "$file" ]; then
        sed -i '' "s|$search|$replace|g" "$file"
    fi
}

echo "Updating configuration files..."

# package.json
replace_in_file "package.json" "{{PACKAGE_NAME}}" "$PACKAGE_NAME"
replace_in_file "package.json" "{{APP_SHORT_DESC}}" "$APP_SHORT_DESC"
replace_in_file "package.json" "{{DEVELOPER_NAME}}" "$DEVELOPER_NAME"
replace_in_file "package.json" "{{APP_KEYWORDS}}" "$APP_KEYWORDS"

# capacitor.config.json
replace_in_file "capacitor.config.json" "{{BUNDLE_ID}}" "$BUNDLE_ID"
replace_in_file "capacitor.config.json" "{{APP_DISPLAY_NAME}}" "$APP_DISPLAY_NAME"
replace_in_file "capacitor.config.json" "{{PRIMARY_COLOR}}" "$PRIMARY_COLOR"

# .firebaserc
replace_in_file ".firebaserc" "{{FIREBASE_PROJECT_ID}}" "$FIREBASE_PROJECT_ID"

# index.html - Firebase config
replace_in_file "index.html" "{{APP_DISPLAY_NAME}}" "$APP_DISPLAY_NAME"
replace_in_file "index.html" "{{FIREBASE_API_KEY}}" "$FIREBASE_API_KEY"
replace_in_file "index.html" "{{FIREBASE_AUTH_DOMAIN}}" "$FIREBASE_AUTH_DOMAIN"
replace_in_file "index.html" "{{FIREBASE_PROJECT_ID}}" "$FIREBASE_PROJECT_ID"
replace_in_file "index.html" "{{FIREBASE_STORAGE_BUCKET}}" "$FIREBASE_STORAGE_BUCKET"
replace_in_file "index.html" "{{FIREBASE_SENDER_ID}}" "$FIREBASE_SENDER_ID"
replace_in_file "index.html" "{{FIREBASE_APP_ID}}" "$FIREBASE_APP_ID"
replace_in_file "index.html" "{{FIREBASE_MEASUREMENT_ID}}" "$FIREBASE_MEASUREMENT_ID"
replace_in_file "index.html" "{{DEVELOPER_NAME}}" "$DEVELOPER_NAME"
replace_in_file "index.html" "{{PRIMARY_COLOR}}" "$PRIMARY_COLOR"

# web/index.html
replace_in_file "web/index.html" "{{APP_DISPLAY_NAME}}" "$APP_DISPLAY_NAME"
replace_in_file "web/index.html" "{{FIREBASE_API_KEY}}" "$FIREBASE_API_KEY"
replace_in_file "web/index.html" "{{FIREBASE_AUTH_DOMAIN}}" "$FIREBASE_AUTH_DOMAIN"
replace_in_file "web/index.html" "{{FIREBASE_PROJECT_ID}}" "$FIREBASE_PROJECT_ID"
replace_in_file "web/index.html" "{{FIREBASE_STORAGE_BUCKET}}" "$FIREBASE_STORAGE_BUCKET"
replace_in_file "web/index.html" "{{FIREBASE_SENDER_ID}}" "$FIREBASE_SENDER_ID"
replace_in_file "web/index.html" "{{FIREBASE_APP_ID}}" "$FIREBASE_APP_ID"
replace_in_file "web/index.html" "{{FIREBASE_MEASUREMENT_ID}}" "$FIREBASE_MEASUREMENT_ID"
replace_in_file "web/index.html" "{{DEVELOPER_NAME}}" "$DEVELOPER_NAME"
replace_in_file "web/index.html" "{{PRIMARY_COLOR}}" "$PRIMARY_COLOR"

# Replace login icon
replace_in_file "index.html" "{{LOGIN_ICON}}" "$LOGIN_ICON"
replace_in_file "web/index.html" "{{LOGIN_ICON}}" "$LOGIN_ICON"

# Replace navbar values in index.html
replace_in_file "index.html" "{{NAV_TAB_1_ID}}" "$NAV_TAB_1_ID"
replace_in_file "index.html" "{{NAV_TAB_1_ICON}}" "$NAV_TAB_1_ICON"
replace_in_file "index.html" "{{NAV_TAB_1_LABEL}}" "$NAV_TAB_1_LABEL"

replace_in_file "index.html" "{{NAV_TAB_2_ID}}" "$NAV_TAB_2_ID"
replace_in_file "index.html" "{{NAV_TAB_2_ICON}}" "$NAV_TAB_2_ICON"
replace_in_file "index.html" "{{NAV_TAB_2_LABEL}}" "$NAV_TAB_2_LABEL"

replace_in_file "index.html" "{{NAV_TAB_3_ID}}" "$NAV_TAB_3_ID"
replace_in_file "index.html" "{{NAV_TAB_3_ICON}}" "$NAV_TAB_3_ICON"
replace_in_file "index.html" "{{NAV_TAB_3_LABEL}}" "$NAV_TAB_3_LABEL"

replace_in_file "index.html" "{{NAV_TAB_4_ID}}" "$NAV_TAB_4_ID"
replace_in_file "index.html" "{{NAV_TAB_4_ICON}}" "$NAV_TAB_4_ICON"
replace_in_file "index.html" "{{NAV_TAB_4_LABEL}}" "$NAV_TAB_4_LABEL"

# Replace navbar values in web/index.html
replace_in_file "web/index.html" "{{NAV_TAB_1_ID}}" "$NAV_TAB_1_ID"
replace_in_file "web/index.html" "{{NAV_TAB_1_ICON}}" "$NAV_TAB_1_ICON"
replace_in_file "web/index.html" "{{NAV_TAB_1_LABEL}}" "$NAV_TAB_1_LABEL"

replace_in_file "web/index.html" "{{NAV_TAB_2_ID}}" "$NAV_TAB_2_ID"
replace_in_file "web/index.html" "{{NAV_TAB_2_ICON}}" "$NAV_TAB_2_ICON"
replace_in_file "web/index.html" "{{NAV_TAB_2_LABEL}}" "$NAV_TAB_2_LABEL"

replace_in_file "web/index.html" "{{NAV_TAB_3_ID}}" "$NAV_TAB_3_ID"
replace_in_file "web/index.html" "{{NAV_TAB_3_ICON}}" "$NAV_TAB_3_ICON"
replace_in_file "web/index.html" "{{NAV_TAB_3_LABEL}}" "$NAV_TAB_3_LABEL"

replace_in_file "web/index.html" "{{NAV_TAB_4_ID}}" "$NAV_TAB_4_ID"
replace_in_file "web/index.html" "{{NAV_TAB_4_ICON}}" "$NAV_TAB_4_ICON"
replace_in_file "web/index.html" "{{NAV_TAB_4_LABEL}}" "$NAV_TAB_4_LABEL"

# Replace master credentials
replace_in_file "index.html" "{{MASTER_EMAIL}}" "$MASTER_EMAIL"
replace_in_file "index.html" "{{MASTER_PASSWORD}}" "$MASTER_PASSWORD"
replace_in_file "web/index.html" "{{MASTER_EMAIL}}" "$MASTER_EMAIL"
replace_in_file "web/index.html" "{{MASTER_PASSWORD}}" "$MASTER_PASSWORD"

# iOS Info.plist
replace_in_file "ios/App/App/Info.plist" "{{APP_DISPLAY_NAME}}" "$APP_DISPLAY_NAME"
replace_in_file "ios/App/App/Info.plist" "{{BUNDLE_ID}}" "$BUNDLE_ID"
replace_in_file "ios/App/App/Info.plist" "{{GOOGLE_OAUTH_IOS}}" "$GOOGLE_OAUTH_IOS"

# Android strings.xml
replace_in_file "android/app/src/main/res/values/strings.xml" "{{APP_DISPLAY_NAME}}" "$APP_DISPLAY_NAME"
replace_in_file "android/app/src/main/res/values/strings.xml" "{{BUNDLE_ID}}" "$BUNDLE_ID"

# Android build.gradle
replace_in_file "android/app/build.gradle" "{{BUNDLE_ID}}" "$BUNDLE_ID"

echo "✅ Template values applied successfully!"
echo ""
echo "App: $APP_DISPLAY_NAME"
echo "Bundle ID: $BUNDLE_ID"
echo "Firebase Project: $FIREBASE_PROJECT_ID"
echo "Developer: $DEVELOPER_NAME"
echo ""
echo "Next steps:"
echo "1. The StepAhead content has been integrated into index.html"
echo "2. Run: npm install"
echo "3. Run: npx cap sync ios"
echo "4. Test in Xcode or web browser"
