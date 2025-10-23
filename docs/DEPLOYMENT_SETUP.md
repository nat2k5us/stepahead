# iOS App Store Deployment Setup Guide

This guide walks you through setting up your app for the first time in the App Store.

## Prerequisites
- Active Apple Developer Program membership ($99/year)
- Xcode installed with command line tools
- Valid Apple ID

## Step 1: Register App ID (Bundle Identifier)

1. Go to [Apple Developer Portal](https://developer.apple.com/account)
2. Navigate to **Certificates, Identifiers & Profiles**
3. Click **Identifiers** → **+** button
4. Select **App IDs** → Continue
5. Fill in the form:
   - **Description**: Speech Trainer
   - **Bundle ID**: Select "Explicit"
   - **Bundle ID Value**: `com.speechtherapy.com`
   - **Team ID**: RMMLMVNZ3L (will be auto-filled)
6. **Capabilities**: Enable any needed capabilities:
   - [ ] Push Notifications (if needed)
   - [ ] In-App Purchase (if needed)
   - [ ] Sign in with Apple (if needed)
7. Click **Continue** → **Register**

## Step 2: Create App in App Store Connect

1. Go to [App Store Connect](https://appstoreconnect.apple.com)
2. Click **Apps** → **+** button → **New App**
3. Fill in the form:
   - **Platforms**: ✓ iOS
   - **Name**: Speech Trainer
   - **Primary Language**: English (U.S.)
   - **Bundle ID**: Select `com.speechtherapy.com` (the one you just created)
   - **SKU**: `speech-trainer-001` (or any unique identifier)
   - **User Access**: Full Access
4. Click **Create**

## Step 3: Set Up Signing & Certificates

### Option A: Automatic Signing (Recommended for first-timers)

1. Open the project in Xcode:
   ```bash
   open ios/App/App.xcworkspace
   ```

2. Select the **App** target

3. Go to **Signing & Capabilities** tab

4. **For All Configurations**, check:
   - ✓ **Automatically manage signing**
   - **Team**: Select your team (RMMLMVNZ3L - Team ID)
   - **Bundle Identifier**: `com.speechtherapy.com`

5. Xcode will automatically:
   - Create development certificates
   - Create provisioning profiles
   - Register devices

### Option B: Manual Signing (Advanced)

If you prefer manual control:

1. **Create Certificates**:
   - Development Certificate (for testing)
   - Distribution Certificate (for App Store)

2. **Create Provisioning Profiles**:
   - Development Profile
   - App Store Distribution Profile

3. Configure in Xcode:
   - Uncheck "Automatically manage signing"
   - Select appropriate profiles for Debug/Release

## Step 4: Configure App Metadata

In App Store Connect, fill in required information:

1. **App Information**:
   - Name: Speech Trainer
   - Subtitle: (50 characters)
   - Category: Education or Medical
   - Privacy Policy URL

2. **Pricing and Availability**:
   - Price: Free or Paid
   - Availability: Countries/regions

3. **App Privacy**:
   - Complete privacy questionnaire
   - Describe data collection practices

4. **Age Rating**:
   - Complete questionnaire

## Step 5: Prepare App Metadata & Assets

### Required Screenshots (for iPhone & iPad):
- 6.7" iPhone (1290 x 2796 px) - iPhone 15 Pro Max
- 6.5" iPhone (1284 x 2778 px) - iPhone 13 Pro Max
- 5.5" iPhone (1242 x 2208 px) - iPhone 8 Plus
- iPad Pro (2048 x 2732 px) - 12.9" display

### App Icon:
- 1024 x 1024 px PNG (no transparency)

### App Preview Videos (Optional):
- Up to 3 videos per device size

## Step 6: Update Export Options

After completing the above, update the export options with your Team ID:

1. Edit `ios/App/exportOptions.plist`:
   ```xml
   <key>teamID</key>
   <string>RMMLMVNZ3L</string>
   ```

2. Edit `ios/App/exportOptionsAppStore.plist`:
   ```xml
   <key>teamID</key>
   <string>RMMLMVNZ3L</string>
   ```

3. Verify the Bundle ID in both files matches:
   ```xml
   <key>com.speechtherapy.com</key>
   ```

## Step 7: First TestFlight Build

Once setup is complete, run:

```bash
./publish-testflight.sh
```

This will:
1. Sync web files to iOS app
2. Clean build
3. Create archive
4. Upload to TestFlight

## Step 8: Add TestFlight Testers

1. In App Store Connect, go to **TestFlight**
2. Select your build
3. Add internal testers (up to 100)
4. Add external testers (up to 10,000) after providing test information
5. Testers will receive email invitation

## Step 9: Submit for App Store Review

After TestFlight testing:

1. In App Store Connect, go to **App Store** tab
2. Click **+** next to **iOS App** to create new version
3. Fill in:
   - Version number (e.g., 1.0)
   - What's New in This Version
   - Upload screenshots
   - Promotional text
4. Select the build from TestFlight
5. Complete all required fields
6. Click **Add for Review**
7. Click **Submit for Review**

## Troubleshooting

### "No signing identity found"
- Make sure you're logged into Xcode with your Apple ID
- Go to Xcode → Settings → Accounts → Add Apple ID

### "Failed to register bundle identifier"
- Bundle ID might already be taken
- Try a different Bundle ID (e.g., `com.yourname.speechtrainer`)

### "Invalid provisioning profile"
- Delete derived data: `rm -rf ~/Library/Developer/Xcode/DerivedData`
- Clean build folder in Xcode: Cmd+Shift+K
- Try automatic signing first

### "Asset validation failed"
- Check that app icons are correct size
- Ensure no alpha channels in icon
- Verify screenshots match required dimensions

## Next Steps

After approval:
1. App will be "Ready for Sale" in App Store Connect
2. Users can download from the App Store
3. Monitor reviews and ratings
4. Release updates using `./publish-appstore.sh`

## Resources

- [Apple Developer Documentation](https://developer.apple.com/documentation/)
- [App Store Connect Help](https://help.apple.com/app-store-connect/)
- [App Review Guidelines](https://developer.apple.com/app-store/review/guidelines/)
- [Human Interface Guidelines](https://developer.apple.com/design/human-interface-guidelines/)
