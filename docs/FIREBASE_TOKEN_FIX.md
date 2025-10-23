# Firebase Token Environment Variable Issue - SOLVED

## The Problem

Your Firebase CLI was using the wrong account because of environment variables:

```bash
FIREBASE_TOKEN=1//0fWMPvlpPpxMsCgYIARAAGA8SNgF-L9IrFVLN6oxi0rJWT6eYggn7qXMieodackfkLYfFkB2xBhYtGBosokM0514CqBbbCI0kKQ
FIREBASE_APP_ID=1:550114633788:ios:2f91145c372f88dbe7bb39
FIREBASE_SERVICE_ACCOUNT_FILE=/Users/nbontha/dev/glatlas/sre/macminiscripts/mobiletrading-ios-eng-f14d370a57eb.json
```

These environment variables are pointing to your **MobileTrading** Firebase project, NOT StepAhead!

When you run `firebase` commands, the CLI sees `FIREBASE_TOKEN` and uses it instead of your logged-in account.

## The Solution

You need to **temporarily unset** these environment variables when working on StepAhead.

### Option 1: Quick Fix (Temporary - For Current Session)

```bash
# Unset the Firebase environment variables
unset FIREBASE_TOKEN
unset FIREBASE_APP_ID
unset FIREBASE_SERVICE_ACCOUNT_FILE

# Now login with the correct account for StepAhead
firebase logout
firebase login

# Verify you can access stepahead-519b0
firebase projects:list | grep stepahead-519b0

# Run privacy policy setup
./deployment/setup-privacy-policy.sh
```

**Note:** This only works for your current terminal session. If you close the terminal and open a new one, the environment variables will be back (if they're set in your shell config files).

### Option 2: Wrapper Script (Recommended)

Create a script that automatically unsets these variables when running Firebase commands for StepAhead:

```bash
# This script already exists and handles it for you!
./deployment/setup-privacy-policy.sh
```

I'll update the script to automatically handle this.

### Option 3: Check Your Shell Configuration

These environment variables are likely set in one of these files:
- `~/.zshrc` (if using zsh)
- `~/.bashrc` (if using bash)
- `~/.bash_profile`
- `~/.profile`

You can either:
1. **Remove them** (if you don't need them for other projects)
2. **Comment them out** when working on StepAhead
3. **Use a tool like direnv** to set environment variables per directory

## Why This Happens

The warning you saw earlier confirms this:
```
⚠  Authenticating with `FIREBASE_TOKEN` is deprecated and will be removed in a future major version of `firebase-tools`
```

The Firebase CLI is using the `FIREBASE_TOKEN` environment variable instead of your normal login.

## Quick Test

After unsetting the variables, test that it's fixed:

```bash
# Check which Firebase projects you can access now
firebase projects:list
```

You should see `stepahead-519b0` instead of just MobileTrading projects.
