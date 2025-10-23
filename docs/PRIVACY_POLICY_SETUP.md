# Privacy Policy Setup - Quick Start Guide

## Overview

Your pre-submission test found that a privacy policy URL is missing - this is **REQUIRED** for App Store submission and will cause automatic rejection without it.

## Quick Fix (Automated)

Run this single command to automatically set everything up:

```bash
./deployment/setup-privacy-policy.sh
```

This script will:
- ✅ Update privacy.html with StepAhead branding
- ✅ Deploy privacy policy to Firebase Hosting
- ✅ Add privacy URL to Info.plist
- ✅ Give you the URL for App Store Connect

**Time required:** 2-3 minutes

## Manual Access

You can also run it from the menu:

```bash
./run-me-first.sh
```

Then select: **Tools → 📋 Setup Privacy Policy**

## What Happens

### 1. Privacy Policy Branding
- Removes all "iSpeakClear" references
- Updates with "StepAhead" branding
- Changes app description to match StepAhead

### 2. Firebase Hosting Deployment
Your privacy policy will be hosted at:
```
https://stepahead-519b0.web.app/index.html
```

### 3. iOS Integration
The script automatically adds this to `ios/App/App/Info.plist`:
```xml
<key>NSPrivacyPolicyURL</key>
<string>https://stepahead-519b0.web.app/index.html</string>
```

### 4. App Store Connect
When submitting your app, add this URL in the App Information section:
- **Privacy Policy URL:** `https://stepahead-519b0.web.app/index.html`

## Verification

After running the script:

1. **Visit the URL** to verify it loads:
   ```
   https://stepahead-519b0.web.app/index.html
   ```

2. **Check Info.plist** contains NSPrivacyPolicyURL:
   ```bash
   grep -A 1 "NSPrivacyPolicyURL" ios/App/App/Info.plist
   ```

3. **Run pre-submission test** to verify fix:
   ```bash
   ./deployment/pre-submission-test.sh
   ```

## Troubleshooting

### Firebase CLI Not Installed
The script will automatically install Firebase CLI if needed. If you see errors:
```bash
npm install -g firebase-tools
firebase login
```

### Privacy Policy Not Loading
1. Check Firebase Console: https://console.firebase.google.com/project/stepahead-519b0/hosting
2. Verify deployment succeeded
3. Try redeploying:
   ```bash
   cd /Users/natrajbontha/dev/apps/stepahead
   firebase deploy --only hosting
   ```

### URL Already Exists in Info.plist
The script will detect this and skip adding it. If you need to update it:
```bash
# Edit manually
open ios/App/App/Info.plist
```

## Files Modified

- ✅ `privacy.html` - Updated branding
- ✅ `privacy-site/index.html` - Copy for hosting
- ✅ `firebase.json` - Hosting configuration (created if needed)
- ✅ `ios/App/App/Info.plist` - Privacy URL added

## Next Steps

After running the privacy policy setup:

1. ✅ Privacy policy is deployed and accessible
2. ✅ iOS app has privacy URL configured
3. ✅ Ready to add URL to App Store Connect
4. ✅ Pre-submission test will pass privacy check

## Important Notes

- **Required for App Store:** Without this, your app will be automatically rejected
- **Public URL:** The privacy policy will be publicly accessible at the Firebase URL
- **Updates:** To update privacy policy content, edit `privacy.html` and re-run the script
- **Production Ready:** The deployed privacy policy is production-ready with StepAhead branding

## Related Documentation

- Full App Store fixes guide: `docs/APP_STORE_FIXES.md`
- Pre-submission test results: Run `./deployment/pre-submission-test.sh`
- Firebase setup: `docs/FIREBASE_SETUP.md`
