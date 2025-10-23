# Deployment Guide

Quick reference for deploying and managing the Speech Therapy iOS app.

## 🚀 Quick Start

### Interactive Menu (Recommended)
```bash
./what-do-you-want-2-do.sh
```

This shows an interactive menu with all deployment options.

### Default Action (Sync Web to iOS)
```bash
./what-do-you-want-2-do.sh
# or
./what-do-you-want-2-do.sh 1
```

Runs without showing menu - just syncs web files to iOS.

### Direct Command
```bash
./what-do-you-want-2-do.sh [choice]
```

Where `[choice]` is a number from the menu.

## 📋 Available Options

### 1. 🔄 Sync Web Files to iOS (Default)
**Command:** `./what-do-you-want-2-do.sh 1`

**What it does:**
- Creates `www` folder if needed
- Copies `index.html` to `www/index.html`
- Runs `npx cap copy ios`
- Runs `npx cap sync ios`

**When to use:**
- After making changes to `index.html`
- Before testing in iOS Simulator
- Before building the app

### 2. 📦 Increment Version/Build Number
**Command:** `./what-do-you-want-2-do.sh 2`

**What it does:**
- Shows submenu for version type
- Increments build, patch, minor, or major version
- Updates `Info.plist` and related files

**When to use:**
- Before publishing to TestFlight
- Before submitting to App Store
- When releasing new versions

**Version types:**
- Build: `1.0.0 (4)` → `1.0.0 (5)`
- Patch: `1.0.0` → `1.0.1`
- Minor: `1.0.0` → `1.1.0`
- Major: `1.0.0` → `2.0.0`

### 3. 🔍 Verify OAuth Configuration
**Command:** `./what-do-you-want-2-do.sh 3`

**What it checks:**
- ✅ GoogleService-Info.plist has OAuth credentials
- ✅ Info.plist has URL scheme registered
- ✅ AppDelegate has URL handling
- ✅ JavaScript has redirect auth implemented

**When to use:**
- After configuring social authentication
- When troubleshooting OAuth issues
- Before testing social login

### 4. 🔑 Check Google OAuth Credentials
**Command:** `./what-do-you-want-2-do.sh 4`

**What it checks:**
- ✅ REVERSED_CLIENT_ID present
- ✅ CLIENT_ID present
- ✅ Bundle ID correct

**When to use:**
- Quick OAuth credential verification
- After downloading new GoogleService-Info.plist

### 5. ✅ Verify General Setup
**Command:** `./what-do-you-want-2-do.sh 5`

**What it checks:**
- Development environment setup
- Required dependencies
- File structure
- Configuration files

**When to use:**
- Initial project setup
- Troubleshooting build issues
- Onboarding new developers

### 6. 🚀 Publish to TestFlight
**Command:** `./what-do-you-want-2-do.sh 6`

**What it does:**
1. Verifies Firebase API is accessible
2. Auto-increments build number
3. Updates version info in HTML
4. Syncs web files to iOS
5. Navigates to iOS project
6. Cleans Xcode build
7. Creates archive
8. Uploads to TestFlight

**When to use:**
- Testing with beta testers
- Before App Store submission
- Sharing builds with team

**Prerequisites:**
- Firebase Firestore API accessible
- Apple Developer account configured
- Signing certificates valid

### 7. 🏪 Publish to App Store
**Command:** `./what-do-you-want-2-do.sh 7`

**What it does:**
1. Auto-increments build number
2. Updates version info in HTML
3. Syncs web files to iOS
4. Creates App Store archive
5. Uploads to App Store Connect

**When to use:**
- Final release to production
- Submitting updates

**Prerequisites:**
- App Store listing created
- Screenshots and metadata ready
- App Review submission prepared

### 8. 📝 Update App Version in HTML
**Command:** `./what-do-you-want-2-do.sh 8`

**What it does:**
- Reads version from Info.plist
- Updates version display in HTML
- Syncs version across app

**When to use:**
- After incrementing version
- To ensure version consistency

## 🎯 Common Workflows

### Testing Changes Locally
```bash
# 1. Make changes to index.html
# 2. Sync to iOS
./what-do-you-want-2-do.sh 1

# 3. Open Xcode and run
open ios/App/App.xcworkspace
```

### Publishing to TestFlight
```bash
# Run the full TestFlight publish workflow
./what-do-you-want-2-do.sh 6

# Or run individual steps:
./what-do-you-want-2-do.sh 2  # Increment version
./what-do-you-want-2-do.sh 8  # Update HTML version
./what-do-you-want-2-do.sh 1  # Sync to iOS
# Then manually build in Xcode
```

### Verifying OAuth Setup
```bash
# Quick check
./what-do-you-want-2-do.sh 4

# Full verification
./what-do-you-want-2-do.sh 3
```

### Releasing New Version
```bash
# 1. Increment version
./what-do-you-want-2-do.sh 2
# Choose: 2 (Patch), 3 (Minor), or 4 (Major)

# 2. Publish to TestFlight for testing
./what-do-you-want-2-do.sh 6

# 3. After testing, publish to App Store
./what-do-you-want-2-do.sh 7
```

## 🔧 Individual Scripts

All scripts are in the `deployment/` folder:

```bash
deployment/
├── increment-version.sh       # Version management
├── publish-appstore.sh        # App Store deployment
├── publish-testflight.sh      # TestFlight deployment
├── sync-web-to-ios.sh        # Web to iOS sync
├── update-app-version.sh     # HTML version update
├── verify-google-plist.sh    # OAuth credential check
├── verify-oauth-config.sh    # OAuth config verification
└── verify-setup.sh           # General setup check
```

You can run them directly:
```bash
./deployment/sync-web-to-ios.sh
./deployment/verify-oauth-config.sh
```

## 💡 Tips

### Default Behavior
Running `./what-do-you-want-2-do.sh` without arguments:
- **Interactive terminal**: Shows menu
- **Non-interactive** (scripts, CI/CD): Runs sync (option 1)

### Quick Commands
```bash
# Sync (default)
./what-do-you-want-2-do.sh

# Or be explicit
./what-do-you-want-2-do.sh 1

# Increment build
./what-do-you-want-2-do.sh 2

# Verify OAuth
./what-do-you-want-2-do.sh 3
```

### Chaining Actions
After completing an action, the script asks if you want to do something else:
```
Do something else? (y/N):
```

Type `y` to return to the menu.

## 🚨 Error Handling

The script will:
- ✅ Show clear success messages in green
- ❌ Show errors in red with exit codes
- ⚠️  Ask for confirmation on destructive actions
- 🔍 Provide helpful error messages

## 📚 Documentation

- **OAuth Setup**: See `OAUTH_SETUP_COMPLETE.md`
- **Social Auth**: See `SOCIAL_AUTH_SETUP.md`
- **General Deployment**: This file

## 🛠️ Troubleshooting

### Script not found
Make sure you're in the project root:
```bash
cd /Users/natrajbontha/dev/html/ios/ios-speech-therapy
./what-do-you-want-2-do.sh
```

### Permission denied
Make it executable:
```bash
chmod +x what-do-you-want-2-do.sh
```

### TestFlight fails with quota error
Firebase quota exceeded. Either:
1. Wait for quota reset (midnight Pacific Time)
2. Bypass check: `SKIP_API_CHECK=1 ./deployment/publish-testflight.sh`

## 🎨 Color Coding

The script uses colors for clarity:
- 🔵 **Blue**: Informational messages
- 🟢 **Green**: Success messages
- 🔴 **Red**: Errors and warnings
- 🟡 **Yellow**: Prompts and questions
- 🔷 **Cyan**: Headers and separators

---

**Quick Reference Card**
```
1 - Sync web to iOS (default)
2 - Increment version
3 - Verify OAuth
4 - Check Google credentials
5 - Verify setup
6 - Publish to TestFlight
7 - Publish to App Store
8 - Update HTML version
0 - Exit
```

Save this for quick access! 📌
