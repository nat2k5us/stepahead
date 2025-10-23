#!/bin/bash

# Automatic Version Management Script
# Handles both Marketing Version (1.0.0) and Build Number (1, 2, 3...)

set -e

PLIST_PATH="ios/App/App/Info.plist"
PROJECT_PATH="ios/App/App.xcodeproj/project.pbxproj"

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo "📦 Version Management"
echo "===================="

# Get current versions from project file (source of truth)
CURRENT_VERSION=$(grep -m 1 "MARKETING_VERSION = " "$PROJECT_PATH" | sed 's/.*MARKETING_VERSION = \(.*\);/\1/' | tr -d ' ')
CURRENT_BUILD=$(grep -m 1 "CURRENT_PROJECT_VERSION = " "$PROJECT_PATH" | sed 's/.*CURRENT_PROJECT_VERSION = \(.*\);/\1/' | tr -d ' ')

# Fallback to defaults if not found
CURRENT_VERSION=${CURRENT_VERSION:-"1.0"}
CURRENT_BUILD=${CURRENT_BUILD:-"1"}

echo -e "${BLUE}Current Version:${NC} $CURRENT_VERSION"
echo -e "${BLUE}Current Build:${NC} $CURRENT_BUILD"
echo ""

# Parse command line arguments
ACTION=${1:-"build"}  # Default to incrementing build number

case $ACTION in
  "major")
    echo "🔼 Incrementing MAJOR version (X.0.0)"
    IFS='.' read -r -a VERSION_PARTS <<< "$CURRENT_VERSION"
    MAJOR=$((${VERSION_PARTS[0]} + 1))
    NEW_VERSION="${MAJOR}.0.0"
    NEW_BUILD="1"
    ;;

  "minor")
    echo "🔼 Incrementing MINOR version (x.X.0)"
    IFS='.' read -r -a VERSION_PARTS <<< "$CURRENT_VERSION"
    MAJOR=${VERSION_PARTS[0]}
    MINOR=$((${VERSION_PARTS[1]} + 1))
    NEW_VERSION="${MAJOR}.${MINOR}.0"
    NEW_BUILD="1"
    ;;

  "patch")
    echo "🔼 Incrementing PATCH version (x.x.X)"
    IFS='.' read -r -a VERSION_PARTS <<< "$CURRENT_VERSION"
    MAJOR=${VERSION_PARTS[0]}
    MINOR=${VERSION_PARTS[1]}
    PATCH=$((${VERSION_PARTS[2]} + 1))
    NEW_VERSION="${MAJOR}.${MINOR}.${PATCH}"
    NEW_BUILD="1"
    ;;

  "build")
    echo "🔼 Incrementing BUILD number"
    NEW_VERSION="$CURRENT_VERSION"
    NEW_BUILD=$((CURRENT_BUILD + 1))
    ;;

  "set")
    # Manual version setting
    NEW_VERSION=${2:-$CURRENT_VERSION}
    NEW_BUILD=${3:-$((CURRENT_BUILD + 1))}
    echo "📝 Setting version manually"
    ;;

  *)
    echo "❌ Unknown action: $ACTION"
    echo ""
    echo "Usage: $0 [ACTION] [VERSION] [BUILD]"
    echo ""
    echo "Actions:"
    echo "  build         Increment build number (default)"
    echo "  patch         Increment patch version (1.0.X)"
    echo "  minor         Increment minor version (1.X.0)"
    echo "  major         Increment major version (X.0.0)"
    echo "  set V B       Set version to V and build to B"
    echo ""
    echo "Examples:"
    echo "  $0                    # Increment build: 1.0.0 (5) -> 1.0.0 (6)"
    echo "  $0 patch              # Increment patch: 1.0.0 -> 1.0.1 (1)"
    echo "  $0 minor              # Increment minor: 1.0.5 -> 1.1.0 (1)"
    echo "  $0 major              # Increment major: 1.2.3 -> 2.0.0 (1)"
    echo "  $0 set 2.0.0 1        # Set to 2.0.0 (1)"
    exit 1
    ;;
esac

echo ""
echo -e "${GREEN}New Version:${NC} $NEW_VERSION"
echo -e "${GREEN}New Build:${NC} $NEW_BUILD"
echo ""

# Update Info.plist
echo "📝 Updating Info.plist..."
/usr/libexec/PlistBuddy -c "Set :CFBundleShortVersionString $NEW_VERSION" "$PLIST_PATH"
/usr/libexec/PlistBuddy -c "Set :CFBundleVersion $NEW_BUILD" "$PLIST_PATH"

# Update project.pbxproj (both Debug and Release configurations)
echo "📝 Updating project.pbxproj..."
sed -i '' "s/MARKETING_VERSION = [^;]*/MARKETING_VERSION = $NEW_VERSION/g" "$PROJECT_PATH"
sed -i '' "s/CURRENT_PROJECT_VERSION = [^;]*/CURRENT_PROJECT_VERSION = $NEW_BUILD/g" "$PROJECT_PATH"

echo ""
echo "✅ Version updated successfully!"
echo ""
echo "Summary:"
echo "  Version: $CURRENT_VERSION → $NEW_VERSION"
echo "  Build:   $CURRENT_BUILD → $NEW_BUILD"
echo ""

# Ask if user wants to create a git tag
if [ "$ACTION" != "build" ]; then
    read -p "Create git tag v$NEW_VERSION? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        git tag -a "v$NEW_VERSION" -m "Release version $NEW_VERSION (Build $NEW_BUILD)"
        echo "✅ Created git tag: v$NEW_VERSION"
        echo ""
        echo "To push tag to remote:"
        echo "  git push origin v$NEW_VERSION"
    fi
fi

echo "Next steps:"
if [ "$ACTION" == "build" ]; then
    echo "  ./publish-testflight.sh    # Publish to TestFlight"
else
    echo "  git add ios/App/App/Info.plist ios/App/App.xcodeproj/project.pbxproj"
    echo "  git commit -m \"Bump version to $NEW_VERSION ($NEW_BUILD)\""
    echo "  ./publish-testflight.sh    # or ./publish-appstore.sh"
fi
