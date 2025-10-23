#!/bin/bash

# Beta App Distribution Summary Generator
# Generates release notes from git commit history for TestFlight/beta testers

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${CYAN}│${NC}     ${BLUE}Beta App Distribution Summary Generator${NC}      ${CYAN}│${NC}"
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

# Get project directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
cd "$PROJECT_DIR"

# Check if we're in a git repo
if ! git rev-parse --git-dir > /dev/null 2>&1; then
    echo -e "${RED}❌ Not a git repository${NC}"
    exit 1
fi

# Get app version from index.html
APP_VERSION=$(grep "const APP_VERSION = " index.html | sed "s/.*'\(.*\)'.*/\1/" | head -1)
APP_BUILD=$(grep "const APP_BUILD = " index.html | sed "s/.*'\(.*\)'.*/\1/" | head -1)

# Get the latest commit hash and date
LATEST_COMMIT=$(git rev-parse --short HEAD)
COMMIT_DATE=$(git log -1 --format=%cd --date=short)

# Ask how many commits to include
echo -e "${YELLOW}How many recent commits to include?${NC}"
echo ""
echo "  1) Last 1 commit (current release only)"
echo "  2) Last 5 commits"
echo "  3) Last 10 commits"
echo "  4) Last 20 commits"
echo "  5) Custom number"
echo ""
read -p "Enter choice [1-5]: " choice

case $choice in
    1) COMMIT_COUNT=1 ;;
    2) COMMIT_COUNT=5 ;;
    3) COMMIT_COUNT=10 ;;
    4) COMMIT_COUNT=20 ;;
    5)
        read -p "Enter number of commits: " COMMIT_COUNT
        ;;
    *)
        echo -e "${RED}❌ Invalid choice${NC}"
        exit 1
        ;;
esac

echo ""
echo -e "${YELLOW}📝 Generating beta notes from last ${COMMIT_COUNT} commit(s)...${NC}"
echo ""

# Output file
OUTPUT_FILE="$PROJECT_DIR/BETA_NOTES.md"

# Generate the notes
cat > "$OUTPUT_FILE" << EOF
# Speech Therapy App - Beta Release

**Version:** $APP_VERSION (Build $APP_BUILD)
**Release Date:** $COMMIT_DATE
**Build:** $LATEST_COMMIT

---

## What's New

EOF

# Get commit messages and format them
git log -${COMMIT_COUNT} --pretty=format:"%s" | while IFS= read -r commit_msg; do
    # Skip merge commits and automated commits
    if [[ "$commit_msg" =~ ^Merge|^🤖\ Generated\ with ]]; then
        continue
    fi

    # Clean up commit message
    msg=$(echo "$commit_msg" | sed 's/^Add /✨ /; s/^Fix /🐛 /; s/^Update /🔄 /; s/^Remove /🗑️ /; s/^Improve /⚡ /; s/^Refactor /♻️ /')

    # Only add if it doesn't already start with an emoji
    if [[ ! "$msg" =~ ^[[:space:]]*[🎨🐛⚡🔥✨♻️🚀🎯📝🔧🌐🗑️🔄] ]]; then
        msg="• $msg"
    fi

    echo "$msg" >> "$OUTPUT_FILE"
done

# Add footer
cat >> "$OUTPUT_FILE" << EOF

---

## Testing Focus

Please test the following areas:
- 📖 Reading stories with speech recognition
- 🏆 Leaderboard functionality
- 📊 Score tracking and accuracy metrics
- 🎤 Speech recognition on different devices
- 🔊 Text-to-speech playback

## Feedback

If you encounter any issues or have suggestions, please share:
- What you were doing when the issue occurred
- Expected vs actual behavior
- Screenshots if applicable
- Device model and iOS version

---

**Thank you for beta testing!** 🙏

Your feedback helps make this app better for everyone.

EOF

# Display the generated notes
echo -e "${GREEN}✅ Beta notes generated!${NC}"
echo ""
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
cat "$OUTPUT_FILE"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo -e "${CYAN}📄 Notes saved to: ${OUTPUT_FILE}${NC}"
echo ""
echo -e "${YELLOW}What do you want to do?${NC}"
echo ""
echo "  1) Copy to clipboard"
echo "  2) Open in editor"
echo "  3) Email format (plain text)"
echo "  4) Done"
echo ""
read -p "Enter choice [1-4]: " action_choice

case $action_choice in
    1)
        if command -v pbcopy &> /dev/null; then
            cat "$OUTPUT_FILE" | pbcopy
            echo -e "${GREEN}✅ Copied to clipboard!${NC}"
        else
            echo -e "${RED}❌ pbcopy not available${NC}"
        fi
        ;;
    2)
        if command -v open &> /dev/null; then
            open "$OUTPUT_FILE"
            echo -e "${GREEN}✅ Opened in default editor${NC}"
        else
            echo -e "${RED}❌ Cannot open file${NC}"
        fi
        ;;
    3)
        # Generate plain text version for email
        EMAIL_FILE="$PROJECT_DIR/BETA_NOTES_EMAIL.txt"
        cat > "$EMAIL_FILE" << EOF
Subject: Speech Therapy App - Beta Release $APP_VERSION (Build $APP_BUILD)

Hi Beta Testers!

A new beta version is now available on TestFlight.

VERSION: $APP_VERSION (Build $APP_BUILD)
RELEASE DATE: $COMMIT_DATE

WHAT'S NEW:
$(git log -${COMMIT_COUNT} --pretty=format:"- %s" | grep -v "^- Merge" | grep -v "🤖 Generated")

TESTING FOCUS:
- Reading stories with speech recognition
- Leaderboard functionality
- Score tracking and accuracy metrics
- Speech recognition on different devices
- Text-to-speech playback

FEEDBACK:
Please share any issues or suggestions you encounter while testing.

Thank you for helping make this app better!

Best regards,
Speech Therapy Team
EOF
        echo ""
        echo -e "${GREEN}✅ Email version generated!${NC}"
        cat "$EMAIL_FILE"
        echo ""
        echo -e "${CYAN}📄 Email saved to: ${EMAIL_FILE}${NC}"

        if command -v pbcopy &> /dev/null; then
            cat "$EMAIL_FILE" | pbcopy
            echo -e "${GREEN}✅ Copied to clipboard!${NC}"
        fi
        ;;
    4)
        echo -e "${BLUE}👋 Done!${NC}"
        ;;
    *)
        echo -e "${BLUE}👋 Done!${NC}"
        ;;
esac

echo ""
