#!/bin/bash

# Deploy privacy policy to Firebase Hosting
# Run this script manually when you need to update the privacy policy

set -e

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${CYAN}│${NC}     ${BLUE}Deploy Privacy Policy to Firebase Hosting${NC}     ${CYAN}│${NC}"
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

# Get project directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

cd "$PROJECT_DIR"

echo -e "${YELLOW}Step 1: Preparing files...${NC}"
mkdir -p public
cp privacy.html public/privacy.html
echo -e "${GREEN}✅ Files ready${NC}"
echo ""

echo -e "${YELLOW}Step 2: Deploying to Firebase Hosting...${NC}"
echo ""
echo -e "${BLUE}Please run this command manually:${NC}"
echo ""
echo -e "  ${CYAN}firebase login${NC}"
echo -e "  ${CYAN}firebase deploy --only hosting${NC}"
echo ""
echo -e "${YELLOW}Your privacy policy will be available at:${NC}"
echo -e "  ${GREEN}https://speechtherapy-fa851.web.app/privacy.html${NC}"
echo ""
echo -e "${BLUE}OR use the Firebase subdomain:${NC}"
echo -e "  ${GREEN}https://speechtherapy-fa851.firebaseapp.com/privacy.html${NC}"
echo ""
