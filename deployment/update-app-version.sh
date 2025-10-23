#!/bin/bash

# Update App Version in HTML
# This script reads version info from Info.plist and updates index.html

set -e

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# Navigate to project root
cd "$SCRIPT_DIR/.." || exit 1

PLIST_PATH="ios/App/App/Info.plist"
HTML_PATH="index.html"

# Get version from Info.plist
VERSION=$(/usr/libexec/PlistBuddy -c "Print :CFBundleShortVersionString" "$PLIST_PATH" 2>/dev/null || echo "1.0")

# Get build number from git commit count (increments with every commit)
# This gives us an auto-incrementing build number based on repository history
BUILD=$(git rev-list --count HEAD 2>/dev/null || echo "1")

# Get git commit hash (first 6 characters)
COMMIT=$(git rev-parse --short=6 HEAD 2>/dev/null || echo "000000")

# Get current date and time in format: YYYY-MM-DD-HH-MM
BUILD_DATE=$(date '+%Y-%m-%d-%H-%M')

echo "📦 Updating version in index.html..."
echo "  Version: $VERSION"
echo "  Build: $BUILD (from commit count)"
echo "  Commit: $COMMIT"
echo "  Date: $BUILD_DATE"

# Update the version constants in index.html
sed -i '' "s/const APP_VERSION = '.*';  \/\/ Marketing version/const APP_VERSION = '$VERSION';  \/\/ Marketing version/" "$HTML_PATH"
sed -i '' "s/const APP_BUILD = '.*';       \/\/ Build number/const APP_BUILD = '$BUILD';       \/\/ Build number/" "$HTML_PATH"
sed -i '' "s/const APP_COMMIT = '.*';  \/\/ Git commit hash (first 6 chars)/const APP_COMMIT = '$COMMIT';  \/\/ Git commit hash (first 6 chars)/" "$HTML_PATH"
sed -i '' "s/const BUILD_DATE = '.*';  \/\/ Auto-generated during build/const BUILD_DATE = '$BUILD_DATE';  \/\/ Auto-generated during build/" "$HTML_PATH"

echo "✅ Version updated successfully!"
echo ""
echo "Updated values in index.html:"
echo "  APP_VERSION = '$VERSION'"
echo "  APP_BUILD = '$BUILD'"
echo "  APP_COMMIT = '$COMMIT'"
echo "  BUILD_DATE = '$BUILD_DATE'"
