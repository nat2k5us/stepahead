#!/bin/bash

# Pre-Submission Test Script for App Store
# Run this before submitting to catch common rejection issues

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

# Get project directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
cd "$PROJECT_DIR"

# Counters
CRITICAL_ISSUES=0
HIGH_RISK_ISSUES=0
MEDIUM_RISK_ISSUES=0
WARNINGS=0

echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${CYAN}│${NC}        ${BLUE}App Store Pre-Submission Test${NC}              ${CYAN}│${NC}"
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo -e "${YELLOW}Checking for common rejection issues...${NC}"
echo ""

# ==============================================================================
# CRITICAL ISSUES (Automatic Rejection)
# ==============================================================================

echo -e "${RED}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${RED}  CRITICAL ISSUES (Will Cause Rejection)${NC}"
echo -e "${RED}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

# Test 1: App Display Name Consistency
echo -e "${CYAN}[1/15]${NC} Checking app display name consistency..."
PLIST_NAME=$(grep -A 1 "CFBundleDisplayName" ios/App/App/Info.plist | grep "<string>" | sed 's/.*<string>\(.*\)<\/string>.*/\1/' | xargs)
HTML_TITLE=$(grep -o "<title>.*</title>" index.html | sed 's/<title>\(.*\)<\/title>/\1/')

if [ "$PLIST_NAME" != "$HTML_TITLE" ]; then
    echo -e "${RED}   ✗ CRITICAL: Display name mismatch${NC}"
    echo -e "     Info.plist: ${YELLOW}$PLIST_NAME${NC}"
    echo -e "     index.html: ${YELLOW}$HTML_TITLE${NC}"
    echo -e "     ${BLUE}Fix: Update Info.plist CFBundleDisplayName to match${NC}"
    CRITICAL_ISSUES=$((CRITICAL_ISSUES + 1))
else
    echo -e "${GREEN}   ✓ Display name consistent: $PLIST_NAME${NC}"
fi
echo ""

# Test 2: Premium/IAP Implementation
echo -e "${CYAN}[2/15]${NC} Checking for incomplete IAP implementation..."
PREMIUM_BADGES=$(grep -c "premium-badge" index.html || true)
PREMIUM_ALERTS=$(grep -c "requires a premium subscription" index.html || true)
IAP_IMPLEMENTATION=$(grep -c "StoreKit\|SKProduct\|purchaseProduct" index.html || true)

if [ $PREMIUM_BADGES -gt 0 ] || [ $PREMIUM_ALERTS -gt 0 ]; then
    if [ $IAP_IMPLEMENTATION -eq 0 ]; then
        echo -e "${RED}   ✗ CRITICAL: Premium UI shown but no IAP implementation${NC}"
        echo -e "     Found $PREMIUM_BADGES premium badges"
        echo -e "     Found $PREMIUM_ALERTS premium alerts"
        echo -e "     ${BLUE}Fix: Remove all premium UI or implement StoreKit IAP${NC}"
        CRITICAL_ISSUES=$((CRITICAL_ISSUES + 1))
    else
        echo -e "${GREEN}   ✓ IAP implementation found${NC}"
    fi
else
    echo -e "${GREEN}   ✓ No premium features (or properly implemented)${NC}"
fi
echo ""

# Test 3: Social Login OAuth Configuration
echo -e "${CYAN}[3/15]${NC} Checking social login OAuth configuration..."
SOCIAL_BUTTONS=$(grep -c "LinkedIn\|Facebook\|Twitter" index.html | head -1 || true)
URL_SCHEMES=$(grep -c "CFBundleURLSchemes" ios/App/App/Info.plist || true)

if [ $SOCIAL_BUTTONS -gt 0 ]; then
    if [ $URL_SCHEMES -eq 0 ]; then
        echo -e "${RED}   ✗ CRITICAL: Social login buttons present but no OAuth URL schemes${NC}"
        echo -e "     ${BLUE}Fix: Add URL schemes to Info.plist or remove social login${NC}"
        CRITICAL_ISSUES=$((CRITICAL_ISSUES + 1))
    else
        echo -e "${YELLOW}   ⚠ Social login found - verify OAuth is fully configured${NC}"
        WARNINGS=$((WARNINGS + 1))
    fi
else
    echo -e "${GREEN}   ✓ No social login (or properly configured)${NC}"
fi
echo ""

# ==============================================================================
# HIGH RISK ISSUES
# ==============================================================================

echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${YELLOW}  HIGH RISK ISSUES (Likely Rejection)${NC}"
echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

# Test 4: Native vs Web App Check
echo -e "${CYAN}[4/15]${NC} Checking for native functionality (4.2 guideline)..."
USES_WEB_SDK=$(grep -c "gstatic.com/firebasejs" index.html || true)
USES_NATIVE_SDK=$(grep -c "import Firebase" ios/App/App/*.swift 2>/dev/null || true)
HAS_CAPACITOR=$(grep -c "capacitor" index.html || true)

if [ $USES_WEB_SDK -gt 0 ] && [ $USES_NATIVE_SDK -eq 0 ]; then
    echo -e "${YELLOW}   ⚠ HIGH RISK: Using web SDKs primarily (4.2 minimum functionality)${NC}"
    echo -e "     App may be seen as 'just a web view'${NC}"
    echo -e "     ${BLUE}Mitigation: Emphasize native features (speech recognition)${NC}"
    HIGH_RISK_ISSUES=$((HIGH_RISK_ISSUES + 1))
else
    echo -e "${GREEN}   ✓ Native functionality detected${NC}"
fi
echo ""

# Test 5: Privacy Policy
echo -e "${CYAN}[5/15]${NC} Checking for privacy policy..."

# Check Info.plist for NSPrivacyPolicyURL
INFO_PLIST="ios/App/App/Info.plist"
if [ -f "$INFO_PLIST" ]; then
    PRIVACY_URL=$(grep -A 1 "NSPrivacyPolicyURL" "$INFO_PLIST" | grep -o "https://[^<]*" || true)

    if [ -n "$PRIVACY_URL" ]; then
        echo -e "${GREEN}   ✓ Privacy policy URL configured: $PRIVACY_URL${NC}"

        # Verify it's accessible
        if curl -s -I "$PRIVACY_URL" | grep -q "HTTP.*200\|HTTP.*301\|HTTP.*302"; then
            echo -e "${GREEN}   ✓ Privacy policy URL is accessible${NC}"
        else
            echo -e "${YELLOW}   ⚠ Privacy URL configured but not accessible${NC}"
            echo -e "     ${BLUE}Verify: $PRIVACY_URL${NC}"
            HIGH_RISK_ISSUES=$((HIGH_RISK_ISSUES + 1))
        fi
    else
        echo -e "${YELLOW}   ⚠ HIGH RISK: No privacy policy URL found in Info.plist${NC}"
        echo -e "     ${BLUE}Required: Add privacy policy URL to iOS configuration${NC}"
        echo -e "     ${GREEN}Quick Fix: Run ./deployment/setup-privacy-policy.sh${NC}"
        HIGH_RISK_ISSUES=$((HIGH_RISK_ISSUES + 1))
    fi
else
    echo -e "${YELLOW}   ⚠ Info.plist not found at: $INFO_PLIST${NC}"
    HIGH_RISK_ISSUES=$((HIGH_RISK_ISSUES + 1))
fi
echo ""

# Test 6: Permission Descriptions
echo -e "${CYAN}[6/15]${NC} Checking permission descriptions..."
MIC_DESC=$(grep -A 1 "NSMicrophoneUsageDescription" ios/App/App/Info.plist | grep "<string>" || true)
SPEECH_DESC=$(grep -A 1 "NSSpeechRecognitionUsageDescription" ios/App/App/Info.plist | grep "<string>" || true)

if [ -z "$MIC_DESC" ] || [ -z "$SPEECH_DESC" ]; then
    echo -e "${YELLOW}   ⚠ HIGH RISK: Missing permission descriptions${NC}"
    HIGH_RISK_ISSUES=$((HIGH_RISK_ISSUES + 1))
else
    echo -e "${GREEN}   ✓ Microphone permission: $(echo $MIC_DESC | sed 's/.*<string>\(.*\)<\/string>.*/\1/' | cut -c1-50)...${NC}"
    echo -e "${GREEN}   ✓ Speech recognition permission found${NC}"
fi
echo ""

# Test 7: API Key Exposure
echo -e "${CYAN}[7/15]${NC} Checking for exposed API keys..."
API_KEYS=$(grep -o "apiKey:.*['\"]" index.html | wc -l || true)

if [ $API_KEYS -gt 0 ]; then
    echo -e "${GREEN}   ✓ Firebase API key found (this is NORMAL and safe)${NC}"
    echo -e "${BLUE}     ℹ️  Firebase API keys are meant to be public by design${NC}"
    echo -e "${BLUE}     ℹ️  Security comes from Firestore Rules, not hidden keys${NC}"
    echo -e "${BLUE}     ℹ️  Optional: Add Firebase App Check for extra protection${NC}"
else
    echo -e "${GREEN}   ✓ No API keys detected${NC}"
fi
echo ""

# ==============================================================================
# MEDIUM RISK ISSUES
# ==============================================================================

echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}  MEDIUM RISK ISSUES${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

# Test 8: Screenshots
echo -e "${CYAN}[8/15]${NC} Checking for App Store screenshots..."
SCREENSHOT_COUNT=$(ls -1 screenshots/ios/*.png 2>/dev/null | wc -l || echo "0")

if [ $SCREENSHOT_COUNT -lt 3 ]; then
    echo -e "${YELLOW}   ⚠ Need at least 3 screenshots (found: $SCREENSHOT_COUNT)${NC}"
    MEDIUM_RISK_ISSUES=$((MEDIUM_RISK_ISSUES + 1))
elif [ $SCREENSHOT_COUNT -lt 5 ]; then
    echo -e "${YELLOW}   ⚠ Recommended 5+ screenshots (found: $SCREENSHOT_COUNT)${NC}"
    WARNINGS=$((WARNINGS + 1))
else
    echo -e "${GREEN}   ✓ $SCREENSHOT_COUNT screenshots ready${NC}"
fi
echo ""

# Test 9: App Description
echo -e "${CYAN}[9/15]${NC} Checking app description..."
README_LENGTH=$(wc -c < README.md 2>/dev/null || echo "0")

if [ $README_LENGTH -lt 170 ]; then
    echo -e "${YELLOW}   ⚠ App Store requires minimum 170 character description${NC}"
    echo -e "     Current README: $README_LENGTH characters"
    MEDIUM_RISK_ISSUES=$((MEDIUM_RISK_ISSUES + 1))
else
    echo -e "${GREEN}   ✓ Description appears adequate ($README_LENGTH characters)${NC}"
fi
echo ""

# Test 10: Bundle Identifier
echo -e "${CYAN}[10/15]${NC} Checking bundle identifier..."
BUNDLE_ID=$(grep -A 1 "CFBundleIdentifier" ios/App/App/Info.plist | grep "<string>" | sed 's/.*<string>\(.*\)<\/string>.*/\1/')

if [[ "$BUNDLE_ID" == *"PRODUCT_BUNDLE_IDENTIFIER"* ]]; then
    echo -e "${YELLOW}   ⚠ Bundle ID uses variable: $BUNDLE_ID${NC}"
    echo -e "     ${BLUE}Verify this resolves correctly in Xcode${NC}"
    WARNINGS=$((WARNINGS + 1))
else
    echo -e "${GREEN}   ✓ Bundle ID: $BUNDLE_ID${NC}"
fi
echo ""

# Test 11: Test Data in Production
echo -e "${CYAN}[11/15]${NC} Checking for test data..."
TEST_USERS=$(grep -c "nat2k5us\|test@\|demo@" index.html || true)

if [ $TEST_USERS -gt 0 ]; then
    echo -e "${YELLOW}   ⚠ Test data or usernames found in code${NC}"
    echo -e "     ${BLUE}Consider adding disclaimer or using production data${NC}"
    WARNINGS=$((WARNINGS + 1))
else
    echo -e "${GREEN}   ✓ No obvious test data${NC}"
fi
echo ""

# Test 12: Build Configuration
echo -e "${CYAN}[12/15]${NC} Checking build configuration..."
VERSION=$(grep -A 1 "CFBundleShortVersionString" ios/App/App/Info.plist | grep "<string>" | sed 's/.*<string>\(.*\)<\/string>.*/\1/')
BUILD=$(grep -A 1 "CFBundleVersion" ios/App/App/Info.plist | grep "<string>" | sed 's/.*<string>\(.*\)<\/string>.*/\1/')

if [ -z "$VERSION" ] || [ -z "$BUILD" ]; then
    echo -e "${YELLOW}   ⚠ Could not read version/build numbers${NC}"
    MEDIUM_RISK_ISSUES=$((MEDIUM_RISK_ISSUES + 1))
else
    echo -e "${GREEN}   ✓ Version: $VERSION, Build: $BUILD${NC}"
fi
echo ""

# Test 13: Content Rating Preparation
echo -e "${CYAN}[13/15]${NC} Checking content considerations..."
LEADERBOARD=$(grep -c "leaderboard" index.html || true)
USER_CONTENT=$(grep -c "custom.*stor" index.html || true)

if [ $LEADERBOARD -gt 0 ] || [ $USER_CONTENT -gt 0 ]; then
    echo -e "${YELLOW}   ⚠ App has user-generated content or social features${NC}"
    echo -e "     ${BLUE}Remember to set appropriate age rating (4+, 9+, 12+, 17+)${NC}"
    WARNINGS=$((WARNINGS + 1))
else
    echo -e "${GREEN}   ✓ No user-generated content detected${NC}"
fi
echo ""

# Test 14: Export Compliance
echo -e "${CYAN}[14/15]${NC} Checking export compliance requirements..."
USES_ENCRYPTION=$(grep -c "https:\|encrypt\|ssl" index.html || true)

if [ $USES_ENCRYPTION -gt 0 ]; then
    echo -e "${YELLOW}   ⚠ App uses HTTPS/encryption${NC}"
    echo -e "     ${BLUE}You'll need to answer export compliance questions${NC}"
    echo -e "     ${BLUE}Usually: No encryption beyond HTTPS = No special exemption needed${NC}"
    WARNINGS=$((WARNINGS + 1))
fi
echo ""

# Test 15: Branding Consistency
echo -e "${CYAN}[15/15]${NC} Checking branding consistency in screenshots..."
if [ $SCREENSHOT_COUNT -gt 0 ]; then
    # Check if screenshots are recent (modified in last 7 days)
    RECENT_SCREENSHOTS=$(find screenshots/ios -name "*.png" -mtime -7 2>/dev/null | wc -l || echo "0")

    if [ $RECENT_SCREENSHOTS -lt $SCREENSHOT_COUNT ]; then
        echo -e "${YELLOW}   ⚠ Screenshots may be outdated (showing old branding)${NC}"
        echo -e "     ${BLUE}Verify screenshots show current app name: $HTML_TITLE${NC}"
        WARNINGS=$((WARNINGS + 1))
    else
        echo -e "${GREEN}   ✓ Screenshots recently updated${NC}"
    fi
else
    echo -e "${YELLOW}   ⚠ No screenshots to verify${NC}"
fi
echo ""

# ==============================================================================
# SUMMARY
# ==============================================================================

echo ""
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${CYAN}│${NC}                  ${BLUE}TEST SUMMARY${NC}                        ${CYAN}│${NC}"
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

if [ $CRITICAL_ISSUES -eq 0 ] && [ $HIGH_RISK_ISSUES -eq 0 ] && [ $MEDIUM_RISK_ISSUES -eq 0 ]; then
    echo -e "${GREEN}✓ READY FOR SUBMISSION${NC}"
    echo -e "  No critical or high-risk issues found!"
    echo ""
    echo -e "  Warnings: $WARNINGS (these are recommendations)"
    echo ""
    echo -e "  ${BLUE}Approval Probability: 85-90%${NC}"
    echo ""
    echo -e "  Next steps:"
    echo -e "  1. Review warnings above"
    echo -e "  2. Prepare App Store metadata"
    echo -e "  3. Run: ./deployment/publish-testflight.sh"
    echo ""
    exit 0
elif [ $CRITICAL_ISSUES -gt 0 ]; then
    echo -e "${RED}✗ NOT READY - CRITICAL ISSUES FOUND${NC}"
    echo ""
    echo -e "  ${RED}Critical Issues: $CRITICAL_ISSUES${NC} (automatic rejection)"
    echo -e "  ${YELLOW}High Risk Issues: $HIGH_RISK_ISSUES${NC}"
    echo -e "  ${BLUE}Medium Risk Issues: $MEDIUM_RISK_ISSUES${NC}"
    echo -e "  Warnings: $WARNINGS"
    echo ""
    echo -e "  ${BLUE}Approval Probability: 10-20%${NC} (if submitted now)"
    echo ""
    echo -e "  ${RED}⚠ FIX CRITICAL ISSUES BEFORE SUBMISSION${NC}"
    echo ""
    echo -e "  ${CYAN}Quick Fixes Available:${NC}"
    echo -e "  • Privacy Policy: ${GREEN}./deployment/setup-privacy-policy.sh${NC}"
    echo -e "  • All fixes: ${GREEN}./deployment/fix-submission-issues.sh${NC}"
    echo -e "  • Full guide: ${GREEN}docs/APP_STORE_FIXES.md${NC}"
    echo ""
    exit 1
elif [ $HIGH_RISK_ISSUES -gt 0 ]; then
    echo -e "${YELLOW}⚠ SUBMISSION RISKY - HIGH RISK ISSUES FOUND${NC}"
    echo ""
    echo -e "  Critical Issues: $CRITICAL_ISSUES"
    echo -e "  ${YELLOW}High Risk Issues: $HIGH_RISK_ISSUES${NC} (likely rejection)"
    echo -e "  ${BLUE}Medium Risk Issues: $MEDIUM_RISK_ISSUES${NC}"
    echo -e "  Warnings: $WARNINGS"
    echo ""
    echo -e "  ${BLUE}Approval Probability: 40-60%${NC}"
    echo ""
    echo -e "  ${YELLOW}Recommended: Fix high-risk issues before submission${NC}"
    echo ""
    echo -e "  ${CYAN}Quick Fixes Available:${NC}"
    echo -e "  • Privacy Policy: ${GREEN}./deployment/setup-privacy-policy.sh${NC}"
    echo -e "  • Full guide: ${GREEN}docs/APP_STORE_FIXES.md${NC}"
    echo ""
    exit 1
else
    echo -e "${BLUE}⚠ PROCEED WITH CAUTION${NC}"
    echo ""
    echo -e "  Critical Issues: $CRITICAL_ISSUES"
    echo -e "  High Risk Issues: $HIGH_RISK_ISSUES"
    echo -e "  ${BLUE}Medium Risk Issues: $MEDIUM_RISK_ISSUES${NC}"
    echo -e "  Warnings: $WARNINGS"
    echo ""
    echo -e "  ${BLUE}Approval Probability: 65-75%${NC}"
    echo ""
    echo -e "  You can submit, but addressing medium-risk issues"
    echo -e "  will improve your chances."
    echo ""
    exit 0
fi
