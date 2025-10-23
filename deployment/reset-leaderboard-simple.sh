#!/bin/bash

# Simple Leaderboard Reset Script
# Uses Firebase CLI firestore:delete command
# Options: DAILY, WEEKLY, ALL, or EVERYTHING

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${YELLOW}========================================${NC}"
echo -e "${YELLOW}   Leaderboard Reset Script${NC}"
echo -e "${YELLOW}========================================${NC}"
echo ""

PROJECT_ID="speechtherapy-fa851"

# Check firebase CLI
if ! command -v firebase &> /dev/null; then
    echo -e "${RED}❌ Firebase CLI not found!${NC}"
    exit 1
fi

# Login check
echo "Checking authentication..."
if ! firebase projects:list &> /dev/null; then
    firebase login
fi
echo -e "${GREEN}✅ Authenticated${NC}"
echo ""

# Menu
echo -e "${BLUE}What do you want to reset?${NC}"
echo ""
echo "  1) 💀 EVERYTHING - Delete ALL leaderboard entries (DANGEROUS)"
echo "  2) ❌ Cancel"
echo ""
read -p "Enter choice [1-2]: " choice

if [ "$choice" != "1" ]; then
    echo -e "${YELLOW}❌ Cancelled${NC}"
    exit 0
fi

echo ""
echo -e "${RED}⚠️  WARNING: This will DELETE ALL leaderboard entries!${NC}"
echo -e "${RED}NO PROTECTION - EVERYTHING WILL BE DELETED!${NC}"
echo ""
read -p "Type 'DELETE_EVERYTHING' to confirm: " confirmation

if [ "$confirmation" != "DELETE_EVERYTHING" ]; then
    echo -e "${YELLOW}❌ Cancelled${NC}"
    exit 0
fi

echo ""
echo -e "${YELLOW}Deleting all documents from reading_sessions collection...${NC}"
echo ""

# Use Firebase CLI to delete the collection
firebase firestore:delete reading_sessions --project "$PROJECT_ID" --recursive --force

echo ""
echo -e "${GREEN}✅ Leaderboard reset complete!${NC}"
echo ""
