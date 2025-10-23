# How to Check Firebase Project Ownership

## Current Situation

Your Firebase CLI is logged in with an account that has access to:
- ✅ mobiletrading-android-eng
- ✅ mobiletrading-ios-eng
- ✅ tradestation-android

But NOT:
- ❌ stepahead-519b0

## Method 1: Check Firebase Console (Easiest)

1. **Open Firebase Console in your browser:**
   ```
   https://console.firebase.google.com
   ```

2. **Look for `stepahead-519b0` in the project list**
   - If you see it → You're logged in with the correct account!
   - If you don't see it → You need to login with a different Google account

3. **Try switching Google accounts in your browser:**
   - Click your profile picture (top right)
   - Click "Sign out" or "Switch account"
   - Try logging in with other Google accounts you use

4. **Once you find the account that shows `stepahead-519b0`:**
   - That's the account you need to use for Firebase CLI
   - Note which email address it is

## Method 2: Check Project Settings Directly

If you have any old browser tabs or bookmarks with the Firebase Console open:

1. **Try to access the project directly:**
   ```
   https://console.firebase.google.com/project/stepahead-519b0
   ```

2. **What happens:**
   - **Can access it** → Note which Google account you're logged in with (top right)
   - **"Access denied" or "Project not found"** → You're logged in with the wrong account
   - **Redirects to login** → Try different Google accounts

3. **Check IAM permissions:**
   ```
   https://console.firebase.google.com/project/stepahead-519b0/settings/iam
   ```
   - This shows all accounts with access
   - Look for your email addresses

## Method 3: Check Your Email

Search your email for:
- **Subject:** "You've been invited to join a Firebase project"
- **From:** firebase-noreply@google.com
- **Keywords:** "stepahead-519b0"

The invitation email will show:
- Which Google account received the invite
- What permissions you have

## Method 4: Check Google Cloud Console

Firebase projects are also Google Cloud projects:

1. **Open Google Cloud Console:**
   ```
   https://console.cloud.google.com
   ```

2. **Click the project dropdown** (top left, next to "Google Cloud")

3. **Look for `stepahead-519b0`** in the project list

4. **Try switching Google accounts** if you don't see it

## Common Scenarios

### Scenario A: You Created the Firebase Project
- Use the same Google account you used when you created it
- This is likely a personal Gmail account or work Google Workspace account

### Scenario B: Someone Shared the Project With You
- Check your email for Firebase invitation
- Use the Google account that received the invitation
- You might have multiple Google accounts - try them all

### Scenario C: You Used iSpeakClear Template
- The project might still be associated with the iSpeakClear Firebase account
- You may need to create a NEW Firebase project for StepAhead
- See "Creating New Firebase Project" section below

## Finding Which Google Account You Used

Run this to see which account is currently logged in:

```bash
# Check current Firebase CLI account
firebase login:list
```

To try a different account:

```bash
# Logout completely
firebase logout

# Login with a different Google account
firebase login
# This opens browser - try a different Google account
```

## Creating New Firebase Project (If Needed)

If you can't find the `stepahead-519b0` project, you might need to create a new one:

1. **Go to Firebase Console:**
   ```
   https://console.firebase.google.com
   ```

2. **Click "Add project"**

3. **Create project with name:** `StepAhead`
   - Firebase will generate a project ID (might be different from stepahead-519b0)

4. **Update your app configuration:**
   ```bash
   # You'll need to update these files with the new project ID:
   # - .firebaserc
   # - web/firebase-config.js (or wherever your Firebase config is)
   ```

## After Finding the Correct Account

Once you identify which Google account has access:

1. **Logout from Firebase CLI:**
   ```bash
   firebase logout
   ```

2. **Login with the correct account:**
   ```bash
   firebase login
   # Use the Google account that owns stepahead-519b0
   ```

3. **Verify access:**
   ```bash
   firebase projects:list | grep stepahead-519b0
   ```

4. **Run privacy policy setup:**
   ```bash
   ./deployment/setup-privacy-policy.sh
   ```

## Still Can't Find It?

If you've tried all Google accounts and still can't access `stepahead-519b0`:

### Option 1: Check if Project Exists
The project `stepahead-519b0` might not exist yet. Check your Firebase config:

```bash
# Look at your current Firebase configuration
cat .firebaserc
cat web/firebase-config.js
```

If these files reference `stepahead-519b0` but you can't access it, the project may have been:
- Deleted
- Created under a different account you don't have access to
- Never created (just referenced in config files)

### Option 2: Create Fresh Firebase Project
You may need to create a new Firebase project and update all references:

1. Create new project in Firebase Console
2. Update `.firebaserc` with new project ID
3. Update Firebase config in your app code
4. Re-run Firebase initialization

### Option 3: Contact Original Developer
If this was set up by someone else:
- Ask them which Google account owns the Firebase project
- Request they add your Google account as Owner/Editor
- Get them to send you an invitation to the project

## Quick Checklist

- [ ] Tried accessing https://console.firebase.google.com with all my Google accounts
- [ ] Searched email for "stepahead-519b0" or Firebase invitations
- [ ] Checked Google Cloud Console for the project
- [ ] Ran `firebase login:list` to see current account
- [ ] Verified the project ID in `.firebaserc` and Firebase config files
- [ ] Confirmed `stepahead-519b0` actually exists (not just in config files)

## Next Steps

Once you've identified the correct Google account or created a new project:
1. Update Firebase CLI login
2. Run `./deployment/setup-privacy-policy.sh`
3. Complete privacy policy deployment
4. Proceed with App Store submission
