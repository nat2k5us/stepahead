#!/bin/bash

# StepAhead Setup Script
# This script guides you through setting up the StepAhead app

set -e

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}   StepAhead App Setup${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

echo -e "${GREEN}Step 1: Configuration${NC}"
echo "The template values have been applied!"
echo "✅ App Name: StepAhead"
echo "✅ Bundle ID: com.stepahead.app"
echo "✅ Firebase Project: stepahead"
echo ""

echo -e "${GREEN}Step 2: Integration Instructions${NC}"
echo "You need to manually integrate the StepAhead content into index.html"
echo ""
echo -e "${YELLOW}📖 Please read and follow: INTEGRATION_STEPS.md${NC}"
echo ""
echo "This guide will show you how to:"
echo "  1. Add StepAhead CSS styles"
echo "  2. Add task data from stepahead.html"
echo "  3. Add JavaScript functions for task navigation"
echo "  4. Replace the home tab content"
echo ""

read -p "Have you completed the integration steps from INTEGRATION_STEPS.md? (y/N) " -n 1 -r
echo ""
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
    echo ""
    echo -e "${YELLOW}⚠️  Please complete the integration first!${NC}"
    echo ""
    echo "Open INTEGRATION_STEPS.md and follow the instructions."
    echo "Then run this script again."
    exit 1
fi

echo ""
echo -e "${GREEN}Step 3: Install Dependencies${NC}"
if [ ! -d "node_modules" ]; then
    echo "Installing npm packages..."
    npm install
    echo "✅ Dependencies installed"
else
    echo "✅ Dependencies already installed"
fi

echo ""
echo -e "${GREEN}Step 4: Sync Web Content to iOS${NC}"
if [ -d "ios/App/App/public" ]; then
    echo "Copying web files to iOS..."
    mkdir -p ios/App/App/public
    cp index.html ios/App/App/public/
    echo "✅ Web content synced to iOS"
else
    echo "⚠️  iOS directory not found. Skipping sync."
fi

echo ""
echo -e "${GREEN}Step 5: Capacitor Sync${NC}"
echo "Syncing Capacitor..."
npx cap sync ios
echo "✅ Capacitor synced"

echo ""
echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}   Setup Complete!${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""
echo -e "${GREEN}Next steps:${NC}"
echo ""
echo "1. Test in web browser:"
echo "   python3 -m http.server 8000"
echo "   Open http://localhost:8000"
echo ""
echo "2. Test on iOS:"
echo "   npx cap open ios"
echo "   Build and run in Xcode"
echo ""
echo "3. Login with test credentials:"
echo "   Email: dev@master.local"
echo "   Password: master123"
echo ""
echo -e "${YELLOW}📚 Documentation:${NC}"
echo "   - INTEGRATION_STEPS.md - Integration guide"
echo "   - README_STEPAHEAD.md  - Project overview"
echo ""
echo "Happy building! 🚀"
