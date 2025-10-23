#!/bin/bash

# ============================================================================
# Setup Privacy Policy for App Store Submission
# ============================================================================
# This script:
# 1. Updates privacy.html with StepAhead branding
# 2. Sets up Firebase Hosting
# 3. Deploys privacy policy
# 4. Adds URL to Info.plist
# ============================================================================

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

echo ""
echo -e "${BLUE}📋 Privacy Policy Setup for App Store${NC}"
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

# Check for conflicting Firebase environment variables
if [ -n "$FIREBASE_TOKEN" ] || [ -n "$FIREBASE_SERVICE_ACCOUNT_FILE" ]; then
    echo -e "${YELLOW}⚠️  Detected Firebase environment variables from another project${NC}"
    echo ""

    if [ -n "$FIREBASE_TOKEN" ]; then
        echo -e "  ${CYAN}FIREBASE_TOKEN is set${NC}"
    fi
    if [ -n "$FIREBASE_APP_ID" ]; then
        echo -e "  ${CYAN}FIREBASE_APP_ID: $FIREBASE_APP_ID${NC}"
    fi
    if [ -n "$FIREBASE_SERVICE_ACCOUNT_FILE" ]; then
        echo -e "  ${CYAN}FIREBASE_SERVICE_ACCOUNT_FILE: $FIREBASE_SERVICE_ACCOUNT_FILE${NC}"
    fi

    echo ""
    echo -e "${YELLOW}These environment variables will be temporarily unset for StepAhead.${NC}"
    echo -e "${CYAN}(They will be restored when you close this terminal)${NC}"
    echo ""

    # Unset the conflicting variables
    unset FIREBASE_TOKEN
    unset FIREBASE_APP_ID
    unset FIREBASE_SERVICE_ACCOUNT_FILE

    echo -e "${GREEN}✅ Firebase environment variables cleared for this session${NC}"
    echo ""
fi

# Step 1: Update privacy.html with StepAhead branding
echo -e "${CYAN}Step 1: Updating privacy.html with StepAhead branding...${NC}"

cd "$PROJECT_ROOT"

if [ -f "privacy.html" ]; then
    # Backup original
    cp privacy.html privacy.html.backup

    # Replace iSpeakClear with StepAhead
    sed -i '' 's/iSpeakClear/StepAhead/g' privacy.html
    sed -i '' 's/Speech Reading Trainer/Step-by-Step Task Guide/g' privacy.html
    sed -i '' 's/speech reading/task management/g' privacy.html

    echo -e "${GREEN}✅ Privacy policy updated${NC}"
else
    echo -e "${RED}❌ privacy.html not found${NC}"
    exit 1
fi

# Step 2: Create privacy-site directory if needed
echo ""
echo -e "${CYAN}Step 2: Setting up privacy-site directory...${NC}"

if [ ! -d "privacy-site" ]; then
    mkdir -p privacy-site
fi

# Copy privacy.html to privacy-site
cp privacy.html privacy-site/index.html
echo -e "${GREEN}✅ Privacy site directory ready${NC}"

# Step 3: Check Firebase CLI
echo ""
echo -e "${CYAN}Step 3: Checking Firebase CLI...${NC}"

if ! command -v firebase &> /dev/null; then
    echo -e "${YELLOW}Firebase CLI not found. Installing...${NC}"
    npm install -g firebase-tools
fi

echo -e "${GREEN}✅ Firebase CLI ready${NC}"

# Step 4: Initialize Firebase Hosting
echo ""
echo -e "${CYAN}Step 4: Setting up Firebase Hosting...${NC}"

if [ ! -f "firebase.json" ]; then
    echo -e "${YELLOW}Creating firebase.json...${NC}"
    cat > firebase.json << 'EOF'
{
  "hosting": {
    "public": "privacy-site",
    "ignore": [
      "firebase.json",
      "**/.*",
      "**/node_modules/**"
    ]
  }
}
EOF
    echo -e "${GREEN}✅ firebase.json created${NC}"
else
    echo -e "${GREEN}✅ firebase.json already exists${NC}"
fi

# Step 5: Login to Firebase
echo ""
echo -e "${CYAN}Step 5: Logging in to Firebase...${NC}"

# Check if already logged in
if ! firebase projects:list &>/dev/null; then
    echo -e "${YELLOW}You need to login to Firebase...${NC}"
    echo ""
    firebase login
    echo ""
fi

# Verify we can access the project
if ! firebase projects:list | grep -q "stepahead-519b0"; then
    echo -e "${RED}❌ Cannot access project 'stepahead-519b0'${NC}"
    echo ""
    echo -e "${YELLOW}Your current Firebase account doesn't have access to this project.${NC}"
    echo ""
    echo -e "${CYAN}Current Firebase projects you have access to:${NC}"
    firebase projects:list
    echo ""
    echo -e "${YELLOW}To fix this:${NC}"
    echo -e "  1. Logout from current account: ${GREEN}firebase logout${NC}"
    echo -e "  2. Login with the account that owns stepahead-519b0: ${GREEN}firebase login${NC}"
    echo -e "  3. Run this script again"
    echo ""
    echo -e "${CYAN}Or manually add hosting to Firebase Console:${NC}"
    echo -e "  https://console.firebase.google.com/project/stepahead-519b0/hosting${NC}"
    echo ""

    # Ask if they want to try logging in now
    echo -e "${YELLOW}Would you like to logout and login with a different account now? (y/n)${NC}"
    read -r response

    if [[ "$response" =~ ^[Yy]$ ]]; then
        echo ""
        echo -e "${CYAN}Logging out...${NC}"
        firebase logout
        echo ""
        echo -e "${CYAN}Please login with the account that owns stepahead-519b0...${NC}"
        firebase login
        echo ""

        # Check again
        if firebase projects:list | grep -q "stepahead-519b0"; then
            echo -e "${GREEN}✅ Successfully logged in with correct account!${NC}"
        else
            echo -e "${RED}❌ Still cannot access stepahead-519b0${NC}"
            echo -e "${YELLOW}Please check that this account owns the Firebase project.${NC}"
            exit 1
        fi
    else
        echo ""
        echo -e "${YELLOW}Script cancelled. Please login with the correct account and try again.${NC}"
        exit 1
    fi
fi

echo -e "${GREEN}✅ Firebase authentication successful${NC}"

# Step 6: Set the active project
echo ""
echo -e "${CYAN}Step 6: Setting Firebase project...${NC}"
firebase use stepahead-519b0
echo -e "${GREEN}✅ Using project: stepahead-519b0${NC}"

# Step 7: Deploy to Firebase Hosting
echo ""
echo -e "${CYAN}Step 7: Deploying privacy policy to Firebase...${NC}"
echo ""

firebase deploy --only hosting

PRIVACY_URL="https://stepahead-519b0.web.app/index.html"

echo ""
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}✅ Privacy policy deployed successfully!${NC}"
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo -e "${CYAN}Privacy Policy URL:${NC}"
echo -e "${YELLOW}$PRIVACY_URL${NC}"
echo ""
echo -e "${CYAN}Next Steps:${NC}"
echo ""
echo -e "1. ${GREEN}Verify privacy policy:${NC}"
echo -e "   Open: ${YELLOW}$PRIVACY_URL${NC}"
echo ""
echo -e "2. ${GREEN}Add to Info.plist:${NC}"
echo -e "   Add this to ios/App/App/Info.plist:"
echo -e "   ${YELLOW}<key>NSPrivacyPolicyURL</key>${NC}"
echo -e "   ${YELLOW}<string>$PRIVACY_URL</string>${NC}"
echo ""
echo -e "3. ${GREEN}Add to App Store Connect:${NC}"
echo -e "   When submitting app, add Privacy Policy URL in App Information"
echo ""
echo -e "${CYAN}Would you like to automatically add the URL to Info.plist? (y/n)${NC}"
read -r response

if [[ "$response" =~ ^[Yy]$ ]]; then
    INFO_PLIST="$PROJECT_ROOT/ios/App/App/Info.plist"

    if [ -f "$INFO_PLIST" ]; then
        # Check if already exists
        if grep -q "NSPrivacyPolicyURL" "$INFO_PLIST"; then
            echo -e "${YELLOW}NSPrivacyPolicyURL already exists in Info.plist${NC}"
        else
            # Add before closing </dict>
            sed -i '' "/<\/dict>/i\\
\	<key>NSPrivacyPolicyURL</key>\\
\	<string>$PRIVACY_URL</string>
" "$INFO_PLIST"
            echo -e "${GREEN}✅ Added privacy URL to Info.plist${NC}"
        fi
    else
        echo -e "${RED}❌ Info.plist not found at: $INFO_PLIST${NC}"
    fi
fi

echo ""
echo -e "${GREEN}✅ Setup complete!${NC}"
echo ""
