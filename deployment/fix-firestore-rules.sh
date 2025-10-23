#!/bin/bash

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

echo ""
echo -e "${BLUE}🔒 Firestore Security Rules - Fix User Creation Issue${NC}"
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

echo -e "${YELLOW}Problem:${NC} Users are created in Firebase Auth but NOT in Firestore"
echo -e "${CYAN}Cause:${NC} Firestore Security Rules are blocking writes"
echo ""

echo -e "${CYAN}Opening Firebase Console to fix rules...${NC}"
echo ""

# Open Firebase Console rules page
open "https://console.firebase.google.com/project/stepahead-519b0/firestore/rules"

echo -e "${GREEN}📋 Copy these production-ready rules:${NC}"
echo ""
cat << 'RULES'
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Allow users to create and read/write their own user document
    match /users/{userId} {
      // Allow user creation during signup
      allow create: if request.auth != null && request.auth.uid == userId;
      
      // Allow users to read/write their own data
      allow read, update, delete: if request.auth != null && request.auth.uid == userId;
    }
    
    // Tasks belong to users
    match /tasks/{taskId} {
      // Anyone authenticated can create a task
      allow create: if request.auth != null;
      
      // Only the owner can read/update/delete their tasks
      allow read, update, delete: if request.auth != null
                                  && resource.data.userId == request.auth.uid;
    }
  }
}
RULES

echo ""
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}Steps to fix:${NC}"
echo ""
echo -e "  1. Firebase Console should now be open in your browser"
echo -e "  2. ${YELLOW}Replace${NC} the existing rules with the rules shown above"
echo -e "  3. Click ${GREEN}\"Publish\"${NC} button to save"
echo -e "  4. ${CYAN}Test${NC} by signing up a new user in your app"
echo ""
echo -e "${CYAN}To verify the fix worked:${NC}"
echo -e "  ${GREEN}node deployment/check-firestore-users.js${NC}"
echo ""
echo -e "${BLUE}See full guide:${NC} docs/FIRESTORE_USER_NOT_CREATED.md"
echo ""
