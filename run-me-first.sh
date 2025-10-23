#!/bin/bash

# Interactive FZF-based deployment menu with preview
# Modern alternative to what-do-you-want-2-do.sh

set -e

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DEPLOYMENT_DIR="$SCRIPT_DIR/deployment"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
NC='\033[0m' # No Color

# Check if fzf is installed
if ! command -v fzf &> /dev/null; then
    echo -e "${RED}❌ Error: fzf is not installed${NC}"
    echo ""
    echo "fzf is required for this interactive menu."
    echo ""
    echo "Install it with:"
    echo "  macOS:   brew install fzf"
    echo "  Linux:   apt install fzf  or  yum install fzf"
    echo ""
    echo -e "${CYAN}Alternatively, use the classic menu:${NC}"
    echo "  ./what-do-you-want-2-do.sh"
    echo ""
    exit 1
fi

# Function to show header (removed - fzf handles display)
show_header() {
    clear
}

# Function to get preview text for each option
get_preview() {
    local key="$1"

    case "$key" in
        "sync-ios")
            cat <<'EOF'
📋 Sync Web Files to iOS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📝 What it does:
   • Copies web/index.html to iOS public folder
   • Syncs using Capacitor (npx cap sync ios)
   • Updates native iOS app with latest web changes

⏱️  Duration: ~10-30 seconds

🎯 Use when:
   • You've made changes to web/index.html
   • You want to test changes in iOS simulator/device
   • Before building for TestFlight or App Store

📂 Files affected:
   • web/index.html → ios/App/App/public/index.html
   • Capacitor native bridge updates

🔧 Command:
   ./deployment/sync-web-to-ios.sh
EOF
            ;;
        "launch-ios-simulator")
            cat <<'EOF'
🚀 Launch in iOS Simulator
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📝 What it does:
   • Syncs web files to iOS
   • Builds the app for simulator
   • Boots an iOS simulator
   • Installs and launches your app
   • Opens Simulator window

⏱️  Duration: ~30-60 seconds (first time may be longer)

🎯 Use when:
   • Testing TacoTalk or your app
   • Want to see changes in iOS simulator
   • Developing and testing features
   • Quick preview of app appearance

⚠️  Prerequisites:
   • Xcode installed
   • iOS simulators installed
   • Capacitor iOS platform added

📱 Features:
   • Auto-selects available iPhone simulator
   • Rebuilds app with latest changes
   • Launches simulator automatically
   • Shows helpful keyboard shortcuts

💡 Tips after launch:
   • ⌘+D - Developer menu
   • ⌘+K - Toggle keyboard
   • Device → Shake - Shake gesture
   • Hot reload - Just run script again

🔧 Script:
   ./deployment/launch-ios-simulator.sh
EOF
            ;;
        "testflight")
            cat <<'EOF'
🚀 Publish to TestFlight
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📝 What it does:
   • Increments build number automatically
   • Syncs web files to iOS
   • Builds the app for release
   • Uploads to TestFlight for beta testing

⏱️  Duration: ~5-10 minutes

🎯 Use when:
   • Ready to release a new beta version
   • Want testers to try new features
   • Need to test on real devices via TestFlight

⚠️  Prerequisites:
   • Valid Apple Developer account
   • App Store Connect API key configured
   • Certificates and provisioning profiles set up
   • Beta testers added in App Store Connect

📂 Creates:
   • New build in TestFlight
   • Archive in Xcode organizer

🔧 Script:
   ./deployment/publish-testflight.sh
EOF
            ;;
        "appstore")
            cat <<'EOF'
🏪 Publish to App Store
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📝 What it does:
   • Increments version number
   • Builds release version
   • Uploads to App Store for review

⏱️  Duration: ~10-15 minutes

🎯 Use when:
   • Ready for public release
   • All testing is complete
   • App Store metadata is ready

⚠️  Prerequisites:
   • Approved for App Store distribution
   • All App Store assets ready (screenshots, etc.)
   • Privacy policy and support URLs active
   • Export compliance completed

📋 After submission:
   • App goes into "Waiting for Review"
   • Review takes 1-3 days typically
   • You'll be notified via email

🔧 Script:
   ./deployment/publish-appstore.sh
EOF
            ;;
        "sync-android")
            cat <<'EOF'
🤖 Sync Web Files to Android
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📝 What it does:
   • Copies web/index.html to Android assets
   • Syncs using Capacitor (npx cap sync android)
   • Updates native Android app

⏱️  Duration: ~10-30 seconds

🎯 Use when:
   • Made changes to web/index.html
   • Want to test in Android emulator/device
   • Before building APK or AAB

📂 Files affected:
   • web/index.html → android/app/src/main/assets/
   • Capacitor native bridge updates

🔧 Command:
   npx cap sync android
EOF
            ;;
        "playstore")
            cat <<'EOF'
📦 Publish to Play Store
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📝 What it does:
   • Builds signed AAB (Android App Bundle)
   • Uploads to Google Play Console
   • Creates new release for review

⏱️  Duration: ~5-10 minutes

🎯 Use when:
   • Ready for production or beta release
   • All testing complete
   • Play Store listing ready

⚠️  Prerequisites:
   • Google Play Developer account
   • Upload key and signing configured
   • Play Store listing created
   • Privacy policy URL active

📋 Release tracks:
   • Internal testing (immediate)
   • Closed testing (beta)
   • Production (public release)

🔧 Script:
   ./deployment/publish-playstore.sh
EOF
            ;;
        "init-template")
            cat <<'EOF'
🎯 Initialize Template
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📝 What it does:
   • Interactive setup for your app
   • Replaces all template placeholders
   • Configures Firebase, bundle IDs, app names
   • Updates all config files automatically

⏱️  Duration: ~5-10 minutes (interactive)

🎯 Use when:
   • Starting a new app from this template
   • First time setup
   • Need to reconfigure app identity

📋 Will prompt you for:
   • App name and display name
   • Bundle ID / Package name
   • Firebase configuration
   • Company/developer details
   • Contact information (email, phone)
   • Domain and URLs
   • Theme colors
   • Navigation tab configuration

📂 Files updated:
   • package.json
   • capacitor.config.json
   • .firebaserc
   • index.html, web/index.html
   • iOS Info.plist
   • Android strings.xml, build.gradle

💡 Tip: Have your Firebase project ready first!

🔧 Script:
   ./init-template.sh
EOF
            ;;
        "revert-template")
            cat <<'EOF'
🔄 Revert Template to TacoTalk
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📝 What it does:
   • Reverts template back to TacoTalk configuration
   • Restores all default values
   • Creates backup before reverting
   • Resets version to 1.0 build 1

⏱️  Duration: ~10 seconds

🎯 Use when:
   • Want to start over from scratch
   • Made a mistake during initialization
   • Testing the init-template script
   • Need to reset to clean state

⚠️  What gets reverted:
   • App name → TacoTalk
   • Bundle ID → com.burrito.tacotalk
   • Firebase config → Test credentials
   • All branding and navigation
   • Version numbers reset to 1.0 build 1

✅ What stays:
   • Your custom code changes
   • Additional files you've added
   • Git history

💾 Safety:
   • Creates backup in .template-backups/
   • Can restore from backup if needed
   • Asks for confirmation before reverting

💡 After revert:
   • Run npm install
   • Sync web to iOS
   • Run init-template.sh when ready

🔧 Script:
   ./revert-template.sh
EOF
            ;;
        "show-config")
            cat <<'EOF'
📋 Show Current Configuration
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📝 What it does:
   • Displays all customizable parameters
   • Shows current values vs TacoTalk defaults
   • Indicates which values have been customized
   • Lists all files that contain these values

⏱️  Duration: ~2 seconds

🎯 Use when:
   • Want to see current template configuration
   • Checking if template has been customized
   • Before running init-template or revert
   • Debugging configuration issues
   • Documenting your app setup

📊 Shows:
   • App Identity (name, bundle ID, description)
   • Firebase Configuration (all credentials)
   • Developer Information (name, contact)
   • Navigation Configuration (tabs, icons, labels)
   • Version Information (iOS/Android)
   • OAuth Configuration

🎨 Output format:
   • Green ✓ = Using TacoTalk default
   • Blue (customized) = Has been changed
   • Shows customization count at top

💡 Example output:
   Template Status: Customized (8 of 25 parameters)

   📱 App Identity
     Display Name:         StarGazing (customized)
     Bundle ID:            com.astronomy.stargazing (customized)
     Package Name:         stargazing (customized)

   🔥 Firebase Configuration
     Project ID:           stargazing-app-2024 (customized)
     API Key:              AIzaSy... (customized)

🔧 Script:
   ./show-config.sh
EOF
            ;;
        "generate-app-icon")
            cat <<'EOF'
🎨 Generate App Icons
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📝 What it does:
   • Creates app icons for iOS and Android
   • Generates all required sizes automatically
   • Supports multiple icon generation methods

⏱️  Duration: ~30 seconds

🎯 4 Generation Methods:

   1️⃣  Emoji Icon (Quick & Fun)
      • Uses emoji as app icon (e.g., 🏠 for StepAhead)
      • Perfect for emoji-based branding
      • Auto-generates all sizes

   2️⃣  Gradient Icon (Colorful Placeholder)
      • Creates gradient with app initials
      • Customizable colors
      • Professional placeholder

   3️⃣  AI-Generated Icon
      • Opens browser to AI icon services
      • IconifyAI, Recraft, Dall-E, Midjourney
      • Download and process with option 4

   4️⃣  Use Existing Image
      • Provide 1024x1024 PNG file
      • Resizes to all required formats

⚠️  Prerequisites:
   • ImageMagick installed (brew install imagemagick)
   • For emoji icons: Apple Color Emoji font

📂 Generates:
   • iOS: All sizes (20-1024px) in Assets.xcassets
   • Android: mdpi, hdpi, xhdpi, xxhdpi, xxxhdpi
   • Root: icon.jpg (1024x1024)

💡 After generation:
   1. Run: npx cap sync ios
   2. Clean Xcode build (Product → Clean Build Folder)
   3. Rebuild and test

🔧 Script:
   ./deployment/generate-app-icon.sh
EOF
            ;;
        "increment-version")
            cat <<'EOF'
📦 Increment Version/Build Number
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📝 What it does:
   • Updates version numbers in all config files
   • Keeps iOS and Android versions in sync
   • Supports semantic versioning

⏱️  Duration: ~5 seconds

🎯 Options:
   1) Build number     (1.0.0 build 42 → 43)
   2) Patch version    (1.0.5 → 1.0.6)
   3) Minor version    (1.2.0 → 1.3.0)
   4) Major version    (2.0.0 → 3.0.0)

📂 Files updated:
   • package.json
   • iOS Info.plist (CFBundleVersion)
   • Android build.gradle (versionCode, versionName)

💡 Versioning strategy:
   • Build: Every TestFlight/beta release
   • Patch: Bug fixes
   • Minor: New features (backward compatible)
   • Major: Breaking changes or major updates

🔧 Script:
   ./deployment/increment-version.sh
EOF
            ;;
        "fix-nanopb")
            cat <<'EOF'
🔧 Fix nanopb Build Error
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📝 What it does:
   • Fixes Xcode build directory permission errors
   • Sets correct extended attributes
   • Resolves "not created by build system" errors

⏱️  Duration: ~10 seconds

🎯 Use when:
   • Getting Xcode build errors about directories
   • Error mentions "not created by build system"
   • nanopb or Firebase build fails

⚠️  Common error message:
   "Could not delete .../nanopb/build because
    it was not created by the build system"

🔧 What it fixes:
   • Sets com.apple.xcode.CreatedByBuildSystem
   • Runs on DerivedData directories
   • Clears problematic build folders

💡 Safe to run anytime - won't harm your project

🔧 Script:
   ./deployment/fix-nanopb.sh
EOF
            ;;
        "verify-oauth")
            cat <<'EOF'
🔍 Verify OAuth Configuration
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📝 What it does:
   • Checks OAuth client IDs in config files
   • Verifies URL schemes are correct
   • Ensures Firebase OAuth setup is complete

⏱️  Duration: ~5 seconds

🎯 Validates:
   • iOS Info.plist URL schemes
   • Google OAuth client IDs
   • Firebase configuration consistency
   • Reversed client ID format

⚠️  Checks for common issues:
   • Missing URL schemes
   • Incorrect client ID format
   • Mismatched configurations

💡 Run this before:
   • Implementing Google Sign-In
   • Testing OAuth flows
   • Deploying with social auth

🔧 Script:
   ./deployment/verify-oauth-config.sh
EOF
            ;;
        "check-google-oauth")
            cat <<'EOF'
🔑 Check Google OAuth Credentials
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📝 What it does:
   • Validates GoogleService-Info.plist
   • Checks OAuth client configuration
   • Verifies all required keys are present

⏱️  Duration: ~5 seconds

🎯 Validates:
   • GoogleService-Info.plist exists
   • CLIENT_ID present and correct format
   • REVERSED_CLIENT_ID matches
   • Bundle ID matches Firebase project

⚠️  Common issues detected:
   • Missing plist file
   • Wrong bundle ID
   • Invalid client ID format
   • Mismatched Firebase project

💡 Run after:
   • Downloading new GoogleService-Info.plist
   • Changing bundle ID
   • Setting up new Firebase project

🔧 Script:
   ./deployment/verify-google-plist.sh
EOF
            ;;
        "verify-setup")
            cat <<'EOF'
✅ Verify General Setup
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📝 What it does:
   • Comprehensive project health check
   • Verifies all configuration files
   • Checks dependencies and tools
   • Validates Firebase setup

⏱️  Duration: ~10-15 seconds

🎯 Checks:
   • Node.js and npm versions
   • Capacitor installation
   • iOS and Android projects exist
   • Firebase config files present
   • Bundle IDs consistent across platforms
   • Required tools (Xcode, Android Studio)

📋 Validates:
   ✓ package.json configuration
   ✓ capacitor.config.json
   ✓ Firebase .firebaserc
   ✓ iOS Info.plist
   ✓ Android build.gradle
   ✓ Web assets present

💡 Run this:
   • After init-template.sh
   • Before first build
   • When troubleshooting issues
   • After major config changes

🔧 Script:
   ./deployment/verify-setup.sh
EOF
            ;;
        "test-firebase")
            cat <<'EOF'
🔥 Test Firebase Connection
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📝 What it does:
   • Tests Firebase Authentication
   • Tests Firestore database connection
   • Creates a temporary test user
   • Verifies read/write operations
   • Automatically cleans up test data

⏱️  Duration: ~5-10 seconds

🎯 Test Steps:
   1. Create test user with Authentication
   2. Write test data to Firestore
   3. Read test data from Firestore
   4. Sign out and sign in again
   5. Delete test user and data

✅ Verifies:
   • Firebase project is accessible
   • API key is correct
   • Authentication is enabled
   • Firestore is configured
   • Read/write permissions work
   • Network connectivity to Firebase

💡 Run this:
   • After setting up Firebase config
   • Before deploying to production
   • When troubleshooting auth issues
   • To verify Firebase credentials

⚠️  Requirements:
   • Node.js installed
   • firebase npm package installed
   • Internet connection
   • Valid Firebase configuration

🔧 Script:
   ./deployment/test-firebase-connection.sh
EOF
            ;;
        "update-version-html")
            cat <<'EOF'
📝 Update App Version in HTML
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📝 What it does:
   • Updates version number displayed in app UI
   • Syncs version from package.json to HTML
   • Updates all HTML files (index, web, iOS)

⏱️  Duration: ~5 seconds

🎯 Use when:
   • After incrementing version
   • Want to show version in app footer/about
   • Syncing version across all files

📂 Files updated:
   • index.html
   • web/index.html
   • ios/App/App/public/index.html

💡 Reads version from:
   • package.json "version" field

🔧 Script:
   ./deployment/update-app-version.sh
EOF
            ;;
        "generate-beta-notes")
            cat <<'EOF'
📋 Generate Beta Release Notes
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📝 What it does:
   • Creates release notes for TestFlight
   • Generates changelog from git commits
   • Formats for App Store Connect

⏱️  Duration: ~10 seconds

🎯 Use when:
   • Preparing TestFlight release
   • Need to document changes for testers
   • Creating version history

📋 Includes:
   • Recent commit messages
   • Version number and build
   • Date and time
   • Formatted for beta testers

💡 Customize:
   • Edit template in script
   • Add what's new section
   • Include known issues

🔧 Script:
   ./deployment/generate-beta-notes.sh
EOF
            ;;
        "cleanup-xcode")
            cat <<'EOF'
🧹 Cleanup Xcode Archives & Temp Data
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📝 What it does:
   • Removes Xcode DerivedData
   • Cleans old archives
   • Frees up disk space
   • Clears build cache

⏱️  Duration: ~30 seconds

🎯 Use when:
   • Running low on disk space
   • Experiencing weird build issues
   • After major Xcode updates
   • Build errors that won't go away

💾 Typically frees: 5-20 GB

📂 Removes:
   • ~/Library/Developer/Xcode/DerivedData
   • ~/Library/Developer/Xcode/Archives (old)
   • Build cache
   • Module cache

⚠️  Safe to run - doesn't affect source code

💡 Tip: Run this if builds are failing randomly

🔧 Script:
   ./deployment/cleanup-xcode.sh
EOF
            ;;
        "pre-submission-test")
            cat <<'EOF'
🔬 Pre-Submission Test for App Store
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📝 What it does:
   • Runs comprehensive pre-flight checks
   • Validates App Store requirements
   • Checks for common rejection reasons
   • Validates assets and metadata

⏱️  Duration: ~1-2 minutes

🎯 Validates:
   • App icons (all sizes)
   • Launch screens
   • Privacy policy URL accessible
   • Support URL accessible
   • App Store description complete
   • Screenshots present (if required)
   • Age rating appropriate
   • Export compliance declared

⚠️  Checks for rejections:
   • Missing privacy policy
   • Broken support URLs
   • Incomplete metadata
   • Missing app icons
   • Invalid bundle ID

💡 Run before:
   • Every App Store submission
   • After major updates
   • First release

🔧 Script:
   ./deployment/pre-submission-test.sh
EOF
            ;;
        "setup-privacy-policy")
            cat <<'EOF'
📋 Setup Privacy Policy for App Store
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📝 What it does:
   • Updates privacy.html with StepAhead branding
   • Deploys privacy policy to Firebase Hosting
   • Adds privacy URL to Info.plist automatically
   • Provides URL for App Store Connect

⏱️  Duration: ~2-3 minutes

🎯 Steps performed:
   1. Updates privacy.html (removes template branding)
   2. Creates privacy-site directory
   3. Initializes Firebase Hosting
   4. Deploys privacy policy to Firebase
   5. Optionally adds URL to Info.plist

✅ Results in:
   • Privacy policy hosted at:
     https://stepahead-519b0.web.app/
   • URL automatically added to iOS app
   • Ready for App Store submission

⚠️  Requirements:
   • Firebase CLI installed (script will install if needed)
   • Firebase project configured
   • Internet connection

💡 Run this:
   • Before first App Store submission
   • When pre-submission test shows privacy URL missing
   • After updating privacy policy content

🔗 Privacy Policy URL will be:
   https://stepahead-519b0.web.app/index.html

🔧 Script:
   ./deployment/setup-privacy-policy.sh
EOF
            ;;
        "fix-firestore-rules")
            cat <<'EOF'
🔒 Fix Firestore Security Rules
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

❌ Problem: Users sign up but don't appear in Firestore

📝 What it does:
   • Opens Firebase Console to Firestore Rules
   • Provides production-ready security rules
   • Guides you through updating rules
   • Allows user creation during signup

⚠️  Common symptoms:
   • Users exist in Firebase Auth
   • Users DON'T exist in Firestore database
   • App appears to work but data isn't saved
   • Silent failures during signup

🔧 The fix:
   • Updates security rules to allow authenticated writes
   • Enables user document creation during signup
   • Maintains security (users can only access their own data)

⏱️  Duration: 2-3 minutes

💡 After fixing:
   • New signups will create Firestore documents
   • Existing auth users may need to re-signup
   • Test with: node deployment/check-firestore-users.js

🔧 Script:
   ./deployment/fix-firestore-rules.sh

📖 Full guide: docs/FIRESTORE_USER_NOT_CREATED.md
EOF
            ;;
        "reset-leaderboard")
            cat <<'EOF'
🗑️  Reset Leaderboard (⚠️  DANGER)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

⚠️  WARNING: DESTRUCTIVE OPERATION

📝 What it does:
   • Permanently deletes leaderboard data
   • Removes all user scores from Firestore
   • Cannot be undone

⏱️  Duration: ~10-30 seconds

🎯 Two options:
   1) Soft Delete - Marks as deleted, keeps data
   2) Hard Delete - PERMANENTLY removes data

⚠️  Use ONLY when:
   • Testing leaderboard functionality
   • Starting fresh in development
   • Clearing test data before production

❌ DO NOT use in production without backup!

💡 Best practices:
   • Backup Firestore first
   • Use soft delete for testing
   • Hard delete only when absolutely necessary
   • Document why you're deleting

🔧 Scripts:
   • Soft: ./deployment/soft-delete-leaderboard.sh
   • Hard: ./deployment/reset-leaderboard.sh
EOF
            ;;
        "exit")
            cat <<'EOF'
🚪 Exit
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

👋 Thanks for using the deployment menu!

💡 Quick tips:
   • Run ./run-me-first.sh anytime
   • Use ↑↓ arrows to navigate
   • Press Esc or Ctrl+C to exit
   • Classic menu: ./what-do-you-want-2-do.sh

📚 Documentation:
   • docs/ - Detailed guides
   • TEMPLATE_GUIDE.md - Template usage
   • README.md - Project overview

🔗 Useful links:
   • Firebase Console
   • App Store Connect
   • Google Play Console

Happy deploying! 🚀
EOF
            ;;
    esac
}

# Handle preview mode (called by fzf)
if [ "$1" = "--preview" ]; then
    get_preview "$2"
    exit 0
fi

# Create menu items with categories
create_menu_items() {
    cat <<'EOF'
ios-1|🔄 Sync web to iOS|sync-ios
ios-2|🚀 Launch in Simulator|launch-ios-simulator
ios-3|📦 Publish to TestFlight|testflight
ios-4|🏪 Publish to App Store|appstore
android-1|🤖 Sync web to Android|sync-android
android-2|📦 Publish to Play Store|playstore
setup-1|🎯 Initialize template|init-template
setup-2|🔄 Revert to TacoTalk|revert-template
setup-3|📋 Show current config|show-config
tools-1|🎨 Generate App Icons|generate-app-icon
tools-2|📦 Increment version/build|increment-version
tools-3|🔧 Fix nanopb build error|fix-nanopb
tools-4|🔍 Verify OAuth config|verify-oauth
tools-5|🔑 Check Google OAuth|check-google-oauth
tools-6|✅ Verify general setup|verify-setup
tools-7|🔥 Test Firebase connection|test-firebase
tools-8|📝 Update version in HTML|update-version-html
tools-9|📋 Generate beta notes|generate-beta-notes
tools-10|🧹 Cleanup Xcode data|cleanup-xcode
tools-11|🔬 Pre-submission test|pre-submission-test
tools-12|📋 Setup Privacy Policy|setup-privacy-policy
tools-13|🔒 Fix Firestore Rules|fix-firestore-rules
admin-1|🗑️  Reset Leaderboard ⚠️|reset-leaderboard
exit-1|🚪 Exit|exit
EOF
}

# Function to run selected action
run_action() {
    local action="$1"

    case "$action" in
        "sync-ios")
            run_script "sync-web-to-ios.sh"
            ;;
        "launch-ios-simulator")
            run_script "launch-ios-simulator.sh"
            ;;
        "testflight")
            run_script "publish-testflight.sh"
            ;;
        "appstore")
            run_script "publish-appstore.sh"
            ;;
        "sync-android")
            echo ""
            echo -e "${BLUE}▶ Syncing web to Android${NC}"
            echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
            echo ""
            npx cap sync android
            ;;
        "playstore")
            run_script "publish-playstore.sh"
            ;;
        "init-template")
            echo ""
            echo -e "${BLUE}▶ Running: init-template.sh${NC}"
            echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
            echo ""
            "$SCRIPT_DIR/init-template.sh"
            echo ""
            echo -e "${GREEN}✅ Completed${NC}"
            echo ""
            echo -ne "${YELLOW}Press Enter to continue...${NC}"
            read -r < /dev/tty
            ;;
        "revert-template")
            echo ""
            echo -e "${BLUE}▶ Running: revert-template.sh${NC}"
            echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
            echo ""
            "$SCRIPT_DIR/revert-template.sh"
            echo ""
            echo -e "${GREEN}✅ Completed${NC}"
            echo ""
            echo -ne "${YELLOW}Press Enter to continue...${NC}"
            read -r < /dev/tty
            ;;
        "show-config")
            echo ""
            echo -e "${BLUE}▶ Running: show-config.sh${NC}"
            echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
            echo ""
            "$SCRIPT_DIR/show-config.sh"
            echo ""
            echo -e "${GREEN}✅ Completed${NC}"
            echo ""
            echo -ne "${YELLOW}Press Enter to continue...${NC}"
            read -r < /dev/tty
            ;;
        "generate-app-icon")
            run_script "generate-app-icon.sh"
            ;;
        "increment-version")
            echo ""
            echo -e "${YELLOW}Increment which version?${NC}"
            echo "  1) Build number"
            echo "  2) Patch version (1.0.X)"
            echo "  3) Minor version (1.X.0)"
            echo "  4) Major version (X.0.0)"
            echo -ne "${YELLOW}Enter choice [1]:${NC} "
            read version_choice

            case $version_choice in
                1|"")
                    run_script "increment-version.sh" "build"
                    ;;
                2)
                    run_script "increment-version.sh" "patch"
                    ;;
                3)
                    run_script "increment-version.sh" "minor"
                    ;;
                4)
                    run_script "increment-version.sh" "major"
                    ;;
                *)
                    echo -e "${RED}❌ Invalid choice${NC}"
                    ;;
            esac
            ;;
        "fix-nanopb")
            run_script "fix-nanopb.sh"
            ;;
        "verify-oauth")
            run_script "verify-oauth-config.sh"
            ;;
        "check-google-oauth")
            run_script "verify-google-plist.sh"
            ;;
        "verify-setup")
            run_script "verify-setup.sh"
            ;;
        "test-firebase")
            run_script "test-firebase-connection.sh"
            ;;
        "update-version-html")
            run_script "update-app-version.sh"
            ;;
        "generate-beta-notes")
            run_script "generate-beta-notes.sh"
            ;;
        "cleanup-xcode")
            run_script "cleanup-xcode.sh"
            ;;
        "pre-submission-test")
            run_script "pre-submission-test.sh"
            ;;
        "setup-privacy-policy")
            run_script "setup-privacy-policy.sh"
            ;;
        "fix-firestore-rules")
            run_script "fix-firestore-rules.sh"
            ;;
        "reset-leaderboard")
            echo ""
            echo -e "${YELLOW}Choose reset method:${NC}"
            echo "  1) Soft Delete (marks as deleted, keeps data)"
            echo "  2) Hard Delete (permanently removes data)"
            echo -ne "${YELLOW}Enter choice [1-2]:${NC} "
            read method
            if [ "$method" = "1" ]; then
                run_script "soft-delete-leaderboard.sh"
            elif [ "$method" = "2" ]; then
                echo ""
                echo -e "${RED}⚠️  WARNING: Hard Delete${NC}"
                echo -e "${RED}   This will PERMANENTLY DELETE leaderboard entries!${NC}"
                echo ""
                echo -ne "${YELLOW}Continue? (y/N):${NC} "
                read confirm
                if [ "$confirm" = "y" ] || [ "$confirm" = "Y" ]; then
                    run_script "reset-leaderboard.sh"
                else
                    echo -e "${BLUE}ℹ️  Cancelled${NC}"
                fi
            else
                echo -e "${BLUE}ℹ️  Cancelled${NC}"
            fi
            ;;
        "exit")
            echo ""
            echo -e "${BLUE}👋 Goodbye!${NC}"
            echo ""
            exit 0
            ;;
    esac
}

# Function to run a deployment script
run_script() {
    local script_name=$1
    shift
    local script_path="$DEPLOYMENT_DIR/$script_name"

    if [ -f "$script_path" ]; then
        echo ""
        echo -e "${BLUE}▶ Running: $script_name${NC}"
        echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
        echo ""
        bash "$script_path" "$@"

        echo ""
        echo -e "${GREEN}✅ Completed${NC}"
        echo ""
        echo -ne "${YELLOW}Press Enter to continue...${NC}"
        read
    else
        echo -e "${RED}❌ Error: Script not found: $script_path${NC}"
        echo ""
        echo -ne "${YELLOW}Press Enter to continue...${NC}"
        read
    fi
}

# Main loop
main() {
    while true; do
        show_header

        # Use fzf to select an option with preview
        selected=$(create_menu_items | fzf \
            --height=100% \
            --layout=reverse \
            --border=horizontal \
            --prompt="❯ " \
            --pointer="▶" \
            --marker="✓" \
            --header="🚀 App Deployment Menu │ ↑↓ Navigate • Enter Select • Esc Exit • Type to filter" \
            --preview="$0 --preview {3}" \
            --preview-window=right:60%:wrap \
            --color=fg:#d0d0d0,bg:#121212,hl:#5f87af \
            --color=fg+:#d0d0d0,bg+:#262626,hl+:#5fd7ff \
            --color=info:#afaf87,prompt:#d7005f,pointer:#af5fff \
            --color=marker:#87ff00,spinner:#af5fff,header:#87afaf \
            --delimiter="|" \
            --with-nth=2 \
            --bind="ctrl-c:abort,esc:abort")

        # Exit if user cancelled (Esc or Ctrl+C)
        if [ -z "$selected" ]; then
            echo ""
            echo -e "${BLUE}👋 Goodbye!${NC}"
            echo ""
            exit 0
        fi

        # Extract the action key (3rd field)
        action=$(echo "$selected" | cut -d'|' -f3)

        # Clear screen and run action
        clear
        run_action "$action"
    done
}

# Run main function
main
