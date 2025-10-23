#!/bin/bash

# Verify iOS Deployment Setup
# Checks if everything is configured correctly before publishing

echo "🔍 Verifying iOS Deployment Setup..."
echo ""

ERRORS=0
WARNINGS=0

# Check 1: Xcode installation
echo "✓ Checking Xcode installation..."
if ! command -v xcodebuild &> /dev/null; then
    echo "  ❌ Xcode not found. Install from App Store."
    ((ERRORS++))
else
    XCODE_VERSION=$(xcodebuild -version | head -1)
    echo "  ✓ Found: $XCODE_VERSION"
fi

# Check 2: Node/npm for Capacitor
echo ""
echo "✓ Checking Node.js and npm..."
if ! command -v node &> /dev/null; then
    echo "  ❌ Node.js not found."
    ((ERRORS++))
else
    NODE_VERSION=$(node --version)
    echo "  ✓ Node.js: $NODE_VERSION"
fi

if ! command -v npm &> /dev/null; then
    echo "  ❌ npm not found."
    ((ERRORS++))
else
    NPM_VERSION=$(npm --version)
    echo "  ✓ npm: $NPM_VERSION"
fi

# Check 3: Project files
echo ""
echo "✓ Checking project files..."
if [ ! -f "index.html" ]; then
    echo "  ❌ index.html not found"
    ((ERRORS++))
else
    echo "  ✓ index.html found"
fi

if [ ! -d "ios/App" ]; then
    echo "  ❌ iOS project not found at ios/App"
    ((ERRORS++))
else
    echo "  ✓ iOS project found"
fi

# Check 4: Bundle ID configuration
echo ""
echo "✓ Checking Bundle ID..."
BUNDLE_ID=$(grep -m 1 "PRODUCT_BUNDLE_IDENTIFIER" ios/App/App.xcodeproj/project.pbxproj | sed 's/.*= \(.*\);/\1/')
if [ -z "$BUNDLE_ID" ]; then
    echo "  ❌ Bundle ID not found in project"
    ((ERRORS++))
else
    echo "  ✓ Bundle ID: $BUNDLE_ID"
fi

# Check 5: Team ID in export options
echo ""
echo "✓ Checking Team ID configuration..."
TEAM_ID=$(grep -A 1 "<key>teamID</key>" ios/App/exportOptions.plist | grep "<string>" | sed 's/.*<string>\(.*\)<\/string>/\1/')
if [ "$TEAM_ID" == "YOUR_TEAM_ID" ] || [ -z "$TEAM_ID" ]; then
    echo "  ⚠️  Team ID not set in exportOptions.plist"
    echo "     Current: $TEAM_ID"
    echo "     Update with your Apple Developer Team ID"
    ((WARNINGS++))
else
    echo "  ✓ Team ID: $TEAM_ID"
fi

# Check 6: Apple Developer account
echo ""
echo "✓ Checking Apple Developer account in Xcode..."
ACCOUNT_COUNT=$(security find-identity -p codesigning -v 2>/dev/null | grep -c "Developer")
if [ "$ACCOUNT_COUNT" -eq 0 ]; then
    echo "  ⚠️  No Developer certificates found"
    echo "     Sign in to Xcode → Settings → Accounts"
    echo " Note: The warning about certificates won't prevent you from publishing - it's just informational. Xcode will create the certificates \
            automatically when you first try to build/archive. But it's better to create them now so everything is ready. \
            After you enable automatic signing in Xcode, let me know and we can verify again! " 
    ((WARNINGS++))
else
    echo "  ✓ Found $ACCOUNT_COUNT Developer certificate(s)"
fi

# Check 7: Capacitor configuration
echo ""
echo "✓ Checking Capacitor configuration..."
if [ ! -f "capacitor.config.json" ]; then
    echo "  ❌ capacitor.config.json not found"
    ((ERRORS++))
else
    echo "  ✓ Capacitor configuration found"
    CAP_APP_ID=$(grep -o '"appId": "[^"]*"' capacitor.config.json | cut -d'"' -f4)
    echo "  ✓ Capacitor App ID: $CAP_APP_ID"
fi

# Check 8: Export scripts exist
echo ""
echo "✓ Checking deployment scripts..."
# Get script directory (in case running from deployment folder)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

for script in sync-web-to-ios.sh publish-testflight.sh publish-appstore.sh increment-version.sh; do
    if [ -f "$SCRIPT_DIR/$script" ]; then
        # Script in same directory (deployment folder)
        SCRIPT_PATH="$SCRIPT_DIR/$script"
    elif [ -f "deployment/$script" ]; then
        # Script in deployment subdirectory (running from root)
        SCRIPT_PATH="deployment/$script"
    else
        echo "  ❌ $script not found"
        ((ERRORS++))
        continue
    fi

    if [ ! -x "$SCRIPT_PATH" ]; then
        echo "  ⚠️  $script not executable (run: chmod +x $SCRIPT_PATH)"
        ((WARNINGS++))
    else
        echo "  ✓ $script ready"
    fi
done

# Summary
echo ""
echo "=========================================="
if [ $ERRORS -eq 0 ] && [ $WARNINGS -eq 0 ]; then
    echo "✅ All checks passed! Ready to deploy."
    echo ""
    echo "Next steps:"
    echo "1. For simulator testing: ./sync-web-to-ios.sh"
    echo "2. For TestFlight: ./publish-testflight.sh"
    echo "3. For App Store: ./publish-appstore.sh"
elif [ $ERRORS -eq 0 ]; then
    echo "⚠️  Setup complete with $WARNINGS warning(s)"
    echo "   Review warnings above before deploying"
    exit 0
else
    echo "❌ Setup incomplete: $ERRORS error(s), $WARNINGS warning(s)"
    echo "   Fix errors above before deploying"
    exit 1
fi
echo "=========================================="
