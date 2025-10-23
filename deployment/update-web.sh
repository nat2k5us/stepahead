#!/bin/bash

# Update Web Version Script
# This script updates version info and syncs to web folder

set -e

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# Navigate to project root
cd "$SCRIPT_DIR/.." || exit 1

echo "🌐 Updating web version..."
echo ""

# Step 1: Update version info
echo "📦 Step 1/2: Updating version info..."
"$SCRIPT_DIR/update-app-version.sh"

# Step 2: Copy to web folder
echo ""
echo "📋 Step 2/2: Copying to web folder..."
cp index.html web/index.html
echo "✅ Copied index.html to web/index.html"

echo ""
echo "✅ Web version updated successfully!"
echo ""
echo "Next steps:"
echo "1. Review changes: git diff"
echo "2. Commit: git add index.html web/index.html && git commit -m 'Your message'"
echo "3. Push: git push origin main"
