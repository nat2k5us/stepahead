# Firebase CLI Authentication Fix

## Current Situation

Your Firebase connection test (`test-firebase-connection.sh`) works fine because it uses the **Firebase SDK** (client-side authentication) which authenticates using the API key in your code.

However, the privacy policy deployment fails because it uses the **Firebase CLI** (server-side tool) which requires you to be logged in with the correct Google account.

## The Problem

Your Firebase CLI is currently logged in with a Google account that has access to:
- MobileTrading projects

But NOT to:
- stepahead-519b0 (your StepAhead project)

## The Solution

You need to logout and re-login with the Google account that owns the `stepahead-519b0` Firebase project.

### Option 1: Automated (Recommended)

Run the privacy policy setup script - it will detect the issue and guide you:

```bash
./deployment/setup-privacy-policy.sh
```

When it detects the account mismatch, it will:
1. Show you which projects your current account can access
2. Ask if you want to logout and re-login
3. Guide you through the authentication process

### Option 2: Manual

If you prefer to fix it manually:

```bash
# 1. Logout from current Firebase account
firebase logout

# 2. Login with the account that owns stepahead-519b0
firebase login
# This will open your browser - login with the CORRECT Google account

# 3. Verify you can now access the project
firebase projects:list | grep stepahead-519b0

# 4. If you see stepahead-519b0 listed, you're good to go!
# Run the privacy policy setup again:
./deployment/setup-privacy-policy.sh
```

## How to Know Which Account to Use

The correct Google account is the one that:
- Created the Firebase project `stepahead-519b0`
- Has Owner or Editor permissions on that project
- You can verify this in Firebase Console: https://console.firebase.google.com/project/stepahead-519b0/settings/iam

## Why This Happens

Firebase has two different authentication methods:

| Type | Used By | Authentication Method |
|------|---------|----------------------|
| **SDK** | Your app code, connection tests | API key (in firebase config) |
| **CLI** | Deployment scripts, hosting | Google account login |

This is why your connection test works (uses SDK/API key) but deployment fails (uses CLI/Google account).

## After Fixing Authentication

Once you're logged in with the correct account, the privacy policy setup will:
1. ✅ Deploy privacy.html to Firebase Hosting
2. ✅ Generate the public URL: https://stepahead-519b0.web.app/index.html
3. ✅ Automatically add it to ios/App/App/Info.plist
4. ✅ Provide you the URL to add to App Store Connect

## Need Help?

If you're not sure which Google account owns the project:
1. Try logging in with each Google account you use for development
2. Check Firebase Console directly: https://console.firebase.google.com
3. Look for the account that shows `stepahead-519b0` in the project list

## Next Steps

1. Run `./deployment/setup-privacy-policy.sh`
2. When prompted, choose to re-login with the correct account
3. Complete the privacy policy deployment
4. Verify the URL is accessible
5. You're ready for App Store submission!
