#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}Fix Firestore Task History Rules${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

# Check if Firebase CLI is installed
if ! command -v firebase &> /dev/null; then
    echo -e "${RED}❌ Firebase CLI not found${NC}"
    echo -e "${YELLOW}Please install it with: npm install -g firebase-tools${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Firebase CLI found${NC}"
echo ""

# Check if logged in
echo -e "${BLUE}Checking Firebase login...${NC}"
if ! firebase projects:list &> /dev/null; then
    echo -e "${YELLOW}⚠️  Not logged in to Firebase${NC}"
    echo -e "${BLUE}Logging in...${NC}"
    firebase login
fi

echo -e "${GREEN}✅ Logged in to Firebase${NC}"
echo ""

# Create firestore.rules file with correct rules
echo -e "${BLUE}Creating firestore.rules with task history permissions...${NC}"

cat > firestore.rules << 'EOF'
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {

    // Users collection - users can read/write their own data
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;

      // Task history subcollection - users can read/write their own history
      match /taskHistory/{historyId} {
        allow read, write: if request.auth != null && request.auth.uid == userId;
      }
    }

    // Default deny all other access
    match /{document=**} {
      allow read, write: if false;
    }
  }
}
EOF

echo -e "${GREEN}✅ Created firestore.rules${NC}"
echo ""

# Show the rules
echo -e "${BLUE}New Firestore Rules:${NC}"
echo -e "${YELLOW}───────────────────────────────────────${NC}"
cat firestore.rules
echo -e "${YELLOW}───────────────────────────────────────${NC}"
echo ""

# Ask for confirmation
echo -e "${YELLOW}⚠️  This will update your Firestore security rules${NC}"
echo -e "${YELLOW}Current rules will be replaced${NC}"
echo ""
read -p "Continue? (y/N): " -n 1 -r
echo ""

if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo -e "${YELLOW}Cancelled${NC}"
    exit 0
fi

# Deploy rules
echo ""
echo -e "${BLUE}Deploying Firestore rules...${NC}"

if firebase deploy --only firestore:rules; then
    echo ""
    echo -e "${GREEN}✅ Firestore rules deployed successfully!${NC}"
    echo ""
    echo -e "${BLUE}What was fixed:${NC}"
    echo -e "  ${GREEN}✓${NC} Users can read their own profile"
    echo -e "  ${GREEN}✓${NC} Users can write their own profile"
    echo -e "  ${GREEN}✓${NC} Users can read their own task history"
    echo -e "  ${GREEN}✓${NC} Users can write their own task history"
    echo ""
    echo -e "${BLUE}The history tab should now work!${NC}"
    echo ""
else
    echo ""
    echo -e "${RED}❌ Failed to deploy rules${NC}"
    echo ""
    echo -e "${YELLOW}Manual Steps:${NC}"
    echo -e "1. Go to: https://console.firebase.google.com/project/stepahead-519b0/firestore/rules"
    echo -e "2. Replace the rules with the content from firestore.rules"
    echo -e "3. Click 'Publish'"
    echo ""
    exit 1
fi

echo -e "${BLUE}========================================${NC}"
echo -e "${GREEN}✅ Done!${NC}"
echo -e "${BLUE}========================================${NC}"
