#!/bin/bash
# Quick template value application for testing

set -e

echo "Applying TacoTalk template values..."

# Define all values
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

# index.html
replace_in_file "index.html" "{{APP_DISPLAY_NAME}}" "$APP_DISPLAY_NAME"
replace_in_file "index.html" "{{FIREBASE_API_KEY}}" "$FIREBASE_API_KEY"
replace_in_file "index.html" "{{FIREBASE_AUTH_DOMAIN}}" "$FIREBASE_AUTH_DOMAIN"
replace_in_file "index.html" "{{FIREBASE_PROJECT_ID}}" "$FIREBASE_PROJECT_ID"
replace_in_file "index.html" "{{FIREBASE_STORAGE_BUCKET}}" "$FIREBASE_STORAGE_BUCKET"
replace_in_file "index.html" "{{FIREBASE_SENDER_ID}}" "$FIREBASE_SENDER_ID"
replace_in_file "index.html" "{{FIREBASE_APP_ID}}" "$FIREBASE_APP_ID"
replace_in_file "index.html" "{{FIREBASE_MEASUREMENT_ID}}" "$FIREBASE_MEASUREMENT_ID"
replace_in_file "index.html" "{{DEVELOPER_NAME}}" "$DEVELOPER_NAME"

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
echo "Developer: $DEVELOPER_NAME"
echo ""
echo "Next: Run 'npm install' and 'npx cap sync ios'"

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

# Replace login icon
replace_in_file "index.html" "{{LOGIN_ICON}}" "$LOGIN_ICON"
replace_in_file "web/index.html" "{{LOGIN_ICON}}" "$LOGIN_ICON"

# Replace navbar values
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

echo "✅ Navbar configuration applied"
