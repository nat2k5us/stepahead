# Deployment Scripts Quick Reference

## Overview
This project includes automated scripts for iOS app deployment to simulators, TestFlight, and the App Store.

## Prerequisites Check
Before using any deployment script, verify your setup:

```bash
./verify-setup.sh
```

This will check:
- ✓ Xcode installation
- ✓ Node.js and npm
- ✓ Project files
- ✓ Bundle ID (com.speechtherapy.app)
- ✓ Team ID (RMMLMVNZ3L)
- ✓ Developer certificates
- ✓ Deployment scripts

## Available Scripts

### 1. `sync-web-to-ios.sh` - Simulator Testing
**Purpose**: Sync web files and run on iOS Simulator

**What it does**:
1. Copies `index.html` to `www/` directory
2. Runs `npx cap copy ios` to sync web assets
3. Runs `npx cap sync ios` to update iOS project
4. Cleans Xcode build
5. Builds for iPhone 16 Pro Max simulator
6. Installs and launches app on simulator

**Usage**:
```bash
./sync-web-to-ios.sh
```

**When to use**:
- During development
- Testing UI changes
- Quick iteration cycles
- Before publishing to TestFlight

---

### 2. `publish-testflight.sh` - TestFlight Beta Testing
**Purpose**: Build and upload to TestFlight for beta testing

**What it does**:
1. Syncs web files to iOS
2. Cleans build
3. Creates Release archive
4. Uploads to TestFlight automatically

**Usage**:
```bash
./publish-testflight.sh
```

**When to use**:
- Beta testing with internal testers (up to 100)
- Beta testing with external testers (up to 10,000)
- Before App Store submission
- Getting feedback on new features

**After running**:
1. Go to [App Store Connect](https://appstoreconnect.apple.com)
2. Navigate to TestFlight tab
3. Add testers or tester groups
4. Testers receive email invitation automatically

---

### 3. `publish-appstore.sh` - App Store Release
**Purpose**: Build and submit to App Store for public release

**What it does**:
1. Syncs web files to iOS
2. Cleans build
3. Creates Release archive for App Store
4. Exports IPA file
5. Uploads to App Store Connect for review

**Usage**:
```bash
./publish-appstore.sh
```

**When to use**:
- Releasing new version to public
- After successful TestFlight testing
- When submitting for App Store review

**Before first use**:
1. Update your Apple ID in the script (line 46-47)
2. Set up app-specific password:
   ```bash
   xcrun altool --store-password-in-keychain-item "AC_PASSWORD" \
     -u "your@email.com" \
     -p "app-specific-password"
   ```

**After running**:
1. Go to [App Store Connect](https://appstoreconnect.apple.com)
2. Select your app
3. Navigate to the version
4. Add release notes and metadata
5. Submit for review

---

## First-Time Setup

If this is your first deployment, follow the complete guide:

📖 **[DEPLOYMENT_SETUP.md](./DEPLOYMENT_SETUP.md)**

This guide covers:
1. Registering App ID in Apple Developer Portal
2. Creating app in App Store Connect
3. Setting up certificates and provisioning profiles
4. Configuring app metadata
5. Preparing screenshots and assets
6. First TestFlight build
7. Submitting for App Store review

## Configuration Files

### Bundle ID & Team ID
- **Bundle ID**: `com.speechtherapy.app`
- **Team ID**: `RMMLMVNZ3L`
- **App Name**: Speech Trainer

These are configured in:
- `ios/App/App.xcodeproj/project.pbxproj`
- `ios/App/exportOptions.plist`
- `ios/App/exportOptionsAppStore.plist`
- `capacitor.config.json`

### Signing Configuration
Located in Xcode project:
- Open: `open ios/App/App.xcworkspace`
- Go to: App target → Signing & Capabilities
- Method: Automatic signing (recommended)

## Troubleshooting

### Build fails with "No signing identity"
```bash
# Solution 1: Sign in to Xcode
# Xcode → Settings → Accounts → Add Apple ID

# Solution 2: Reset derived data
rm -rf ~/Library/Developer/Xcode/DerivedData
```

### "Failed to upload to App Store Connect"
```bash
# Check your Apple ID credentials
xcrun altool --validate-app --type ios --file path/to/App.ipa \
  --username "your@email.com" --password "@keychain:AC_PASSWORD"
```

### Simulator not showing app
```bash
# Restart simulator
xcrun simctl shutdown all
xcrun simctl boot "iPhone 16 Pro Max"
./sync-web-to-ios.sh
```

### Web changes not reflecting in app
```bash
# Force clean and rebuild
rm -rf www
rm -rf ios/App/App/public
./sync-web-to-ios.sh
```

## Workflow Example

### Development Cycle
```bash
# 1. Make changes to index.html
vim index.html

# 2. Test on simulator
./sync-web-to-ios.sh

# 3. Iterate until satisfied
# ... repeat steps 1-2 ...

# 4. Commit changes
git add index.html
git commit -m "Add new feature"
git push
```

### Release Cycle
```bash
# 1. Verify setup
./verify-setup.sh

# 2. Test on simulator
./sync-web-to-ios.sh

# 3. Upload to TestFlight for beta testing
./publish-testflight.sh

# 4. Get feedback from testers
# ... wait for feedback ...

# 5. Make fixes if needed
# ... repeat steps 1-3 ...

# 6. Submit to App Store
./publish-appstore.sh

# 7. Complete submission in App Store Connect
# - Add release notes
# - Submit for review
# - Wait for approval (typically 1-3 days)
```

## Version Management

### Incrementing Version Number
Before each release, update the version in Xcode:

1. Open project: `open ios/App/App.xcworkspace`
2. Select App target
3. Go to General tab
4. Update:
   - **Version**: 1.0.0, 1.1.0, 2.0.0, etc. (public-facing)
   - **Build**: 1, 2, 3, etc. (increments with each upload)

Or via command line:
```bash
# Update version
/usr/libexec/PlistBuddy -c "Set :CFBundleShortVersionString 1.1.0" ios/App/App/Info.plist

# Update build number
/usr/libexec/PlistBuddy -c "Set :CFBundleVersion 2" ios/App/App/Info.plist
```

## Resources

- **App Store Connect**: https://appstoreconnect.apple.com
- **Apple Developer Portal**: https://developer.apple.com/account
- **TestFlight Documentation**: https://developer.apple.com/testflight/
- **App Review Guidelines**: https://developer.apple.com/app-store/review/guidelines/
- **Capacitor iOS Docs**: https://capacitorjs.com/docs/ios

## Support

If you encounter issues:
1. Run `./verify-setup.sh` to diagnose problems
2. Check Xcode console for detailed error messages
3. Review [DEPLOYMENT_SETUP.md](./DEPLOYMENT_SETUP.md) for configuration steps
4. Check Apple Developer Forums: https://developer.apple.com/forums/
