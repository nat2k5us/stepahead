# iOS App Development & Deployment Guide
## Speech Therapy App - Complete Guide

---

## 📋 Table of Contents
1. [Prerequisites](#prerequisites)
2. [Project Setup](#project-setup)
3. [iOS Development](#ios-development)
4. [App Store Connect Setup](#app-store-connect-setup)
5. [TestFlight Beta Testing](#testflight-beta-testing)
6. [App Store Deployment](#app-store-deployment)
7. [Fastlane Automation](#fastlane-automation)
8. [Troubleshooting](#troubleshooting)

---

## 🛠 Prerequisites

### Required Software
- **macOS** (Ventura 13.0 or later)
- **Xcode 15+** (from Mac App Store)
- **Command Line Tools**: `xcode-select --install`
- **Node.js 18+**: `brew install node`
- **CocoaPods**: `sudo gem install cocoapods`
- **Fastlane**: `brew install fastlane`

### Required Accounts
1. **Apple ID** (free)
2. **Apple Developer Account** ($99/year)
   - Enroll at: https://developer.apple.com/programs/
3. **App Store Connect Access**
   - Access at: https://appstoreconnect.apple.com/

### Cost Breakdown
- Apple Developer Program: **$99/year**
- Xcode: **Free**
- TestFlight: **Free** (included in Developer Program)
- App Store Distribution: **Free** (included in Developer Program)

---

## 🚀 Project Setup

### Step 1: Install Dependencies

```bash
cd /Users/natrajbontha/dev/html/speech_therapy

# Install Node dependencies
npm install

# Install Capacitor CLI globally (optional)
npm install -g @capacitor/cli
```

### Step 2: Initialize Capacitor

```bash
# Initialize Capacitor (if not already done)
npx cap init "Speech Therapy" "com.speechtherapy.app"

# This will create capacitor.config.json
```

### Step 3: Add iOS Platform

```bash
# Add iOS platform
npm run capacitor:add:ios

# This creates the ios/ directory with Xcode project
```

### Step 4: Sync Web Assets

```bash
# Copy web files to iOS project
npm run capacitor:sync

# This copies index.html and assets to ios/App/public
```

---

## 📱 iOS Development

### Step 1: Open Xcode Project

```bash
# Open the iOS project in Xcode
npm run capacitor:open:ios

# Or manually:
open ios/App/App.xcworkspace
```

### Step 2: Configure Project Settings in Xcode

#### A. General Settings
1. Select **App** target in Project Navigator
2. Go to **General** tab
3. Configure:
   - **Display Name**: `My Speech Therapy`
   - **Bundle Identifier**: `com.speechtherapy.app`
   - **Version**: `1.0.0`
   - **Build**: `1`
   - **Deployment Target**: iOS 14.0 or later

#### B. Signing & Capabilities
1. Go to **Signing & Capabilities** tab
2. Check **Automatically manage signing**
3. Select your **Team** (your Apple Developer account)
4. Xcode will automatically:
   - Create App ID
   - Generate signing certificates
   - Create provisioning profiles

#### C. Add Required Capabilities
Click **+ Capability** and add:
- **Background Modes** (if needed for audio)
- **Speech Recognition** (for speech-to-text)

#### D. Info.plist Permissions
1. Select `Info.plist`
2. Add these privacy descriptions:

```xml
<key>NSMicrophoneUsageDescription</key>
<string>This app needs microphone access to analyze your reading voice and provide feedback.</string>

<key>NSSpeechRecognitionUsageDescription</key>
<string>This app uses speech recognition to help improve your pronunciation and reading skills.</string>

<key>NSCameraUsageDescription</key>
<string>Optional: Take photos for your profile (if adding this feature later)</string>
```

### Step 3: Test on Simulator

1. Select a simulator from device menu (e.g., iPhone 15)
2. Click **Run** button (⌘R)
3. App should launch in simulator

**Note**: Microphone won't work in simulator. Use a real device for testing.

### Step 4: Test on Physical Device

1. Connect iPhone/iPad via USB
2. Select your device from device menu
3. Click **Run** button (⌘R)
4. First time: Trust computer on device
5. If app fails to launch:
   - Go to Settings > General > VPN & Device Management
   - Trust your developer certificate

---

## 🌐 App Store Connect Setup

### Step 1: Create App Record

1. Go to https://appstoreconnect.apple.com/
2. Click **My Apps** > **+** > **New App**
3. Fill in details:
   - **Platforms**: iOS
   - **Name**: My Speech Therapy
   - **Primary Language**: English (U.S.)
   - **Bundle ID**: Select `com.speechtherapy.app`
   - **SKU**: `speech-therapy-001` (unique identifier)
   - **User Access**: Full Access

### Step 2: App Information

1. Go to **App Information** section
2. Fill in:
   - **Category**: Education or Medical
   - **Content Rights**: Check if you own or license content
   - **Age Rating**: Click Edit, answer questionnaire
   - **Privacy Policy URL**: (required for App Store)
   - **Support URL**: Your website or GitHub

### Step 3: Pricing and Availability

1. Go to **Pricing and Availability**
2. Set:
   - **Price**: Free (or set price)
   - **Availability**: All countries or specific regions

### Step 4: Prepare Metadata

Create these assets before submission:

#### App Screenshots (Required)
- **6.7" Display (iPhone 15 Pro Max)**: 1290 x 2796 pixels (3 required)
- **6.5" Display (iPhone 11 Pro Max)**: 1242 x 2688 pixels
- **5.5" Display (iPhone 8 Plus)**: 1242 x 2208 pixels
- **iPad Pro (12.9", 3rd gen)**: 2048 x 2732 pixels (for iPad)

Tips for screenshots:
- Use macOS Screenshot tool on simulator
- Show app's main features
- Add text overlays in Preview or Sketch

#### App Preview Videos (Optional)
- 15-30 seconds
- Show app functionality
- No audio required

#### App Icon
- **1024x1024 pixels** (PNG, no transparency, no rounded corners)
- Tools: Sketch, Figma, Canva

#### Description & Keywords
```
Description:
[YOUR_APP_NAME] is an innovative app designed for [YOUR_APP_PURPOSE]. Replace this description with your app's unique value proposition and key features.

Features:
• [Feature 1]
• [Feature 2]
• [Feature 3]
• [Feature 4]
• [Feature 5]

Keywords: (max 100 characters)
[keyword1],[keyword2],[keyword3],[keyword4]
```

---

## 🧪 TestFlight Beta Testing

### Step 1: Archive Your App

1. In Xcode, select **Any iOS Device (arm64)** from device menu
2. Go to **Product** > **Archive**
3. Wait for archive to complete (5-10 minutes)
4. **Organizer** window will open

### Step 2: Upload to App Store Connect

1. In Organizer, select your archive
2. Click **Distribute App**
3. Select **App Store Connect**
4. Click **Upload**
5. Select signing options:
   - **Automatically manage signing** (recommended)
6. Click **Upload**
7. Wait for upload (10-30 minutes depending on size)

### Step 3: Configure TestFlight

1. Go to App Store Connect
2. Select your app
3. Go to **TestFlight** tab
4. Wait for build to process (30 minutes to 2 hours)
5. Build will show "Ready to Submit" when processed

### Step 4: Internal Testing

1. Click on your build number
2. Go to **Internal Testing** section
3. Add internal testers:
   - Click **+** next to Internal Testers
   - Add Apple IDs of team members
4. Testers will receive email invitation
5. They install **TestFlight app** from App Store
6. Open invitation link to install your app

### Step 5: External Testing (Optional)

1. Go to **External Testing** section
2. Create a new group: "Beta Testers"
3. Add up to 10,000 external testers
4. **First time**: Submit for Beta App Review (1-2 days)
5. Add testers by email or public link
6. Testers install via TestFlight

### Step 6: Gather Feedback

- Monitor crash reports in TestFlight
- Read tester feedback
- Fix issues and upload new builds
- Repeat until stable

---

## 📦 App Store Deployment

### Step 1: Prepare for Review

1. Complete all metadata in App Store Connect
2. Upload all required screenshots
3. Upload app icon
4. Write release notes
5. Set age rating
6. Add privacy policy URL

### Step 2: Submit for Review

1. Go to **App Store** tab (not TestFlight)
2. Click **+ Version or Platform** > **iOS**
3. Enter version number: `1.0.0`
4. Fill in **What's New in This Version**:
   ```
   Initial release of Speech Therapy!

   Features:
   • Real-time speech recognition and feedback
   • 10 engaging reading stories
   • Custom story support
   • Progress tracking and history
   • Adjustable reading speed
   • Pronunciation scoring
   ```
5. Select your build from TestFlight
6. Click **Add for Review**
7. Answer app review questions:
   - **Export Compliance**: No encryption (if not using)
   - **Advertising Identifier**: No (if not using ads)
   - **Content Rights**: Yes
8. Click **Submit for Review**

### Step 3: App Review Process

**Timeline**: 24-48 hours (average)

**Possible Outcomes**:
- **Approved**: App goes live! 🎉
- **Metadata Rejected**: Fix metadata, resubmit (no new build needed)
- **Binary Rejected**: Fix code issues, upload new build

**Common Rejection Reasons**:
1. Missing privacy policy
2. Crashes or bugs
3. Incomplete functionality
4. Misleading screenshots/description
5. Microphone permission not explained

### Step 4: Release Your App

After approval:
1. **Automatic Release**: App goes live immediately
2. **Manual Release**: You control when to release
   - Go to app page
   - Click **Release This Version**

### Step 5: Post-Release

- Monitor reviews and ratings
- Respond to user feedback
- Fix bugs quickly
- Plan updates

---

## ⚡ Fastlane Automation

Fastlane automates building, testing, and deploying iOS apps.

### Step 1: Install Fastlane

```bash
# Install via Homebrew
brew install fastlane

# Or via RubyGems
sudo gem install fastlane
```

### Step 2: Initialize Fastlane

```bash
cd /Users/natrajbontha/dev/html/speech_therapy/ios/App

# Initialize fastlane
fastlane init

# Select option 2: "Automate beta distribution to TestFlight"
```

This creates:
- `fastlane/Fastfile` (automation scripts)
- `fastlane/Appfile` (app configuration)

### Step 3: Configure Fastlane

Edit `ios/App/fastlane/Appfile`:

```ruby
app_identifier("com.speechtherapy.app")
apple_id("your.apple.id@email.com")
itc_team_id("YOUR_TEAM_ID") # Team ID from App Store Connect
team_id("YOUR_DEVELOPER_TEAM_ID") # Team ID from Developer Portal

# Optional: specify scheme
# For more information: https://docs.fastlane.tools/actions/gym/#parameters
```

Edit `ios/App/fastlane/Fastfile`:

```ruby
default_platform(:ios)

platform :ios do

  # Lane for building and uploading to TestFlight
  lane :beta do
    # Increment build number
    increment_build_number(xcodeproj: "App.xcodeproj")

    # Build the app
    build_app(
      scheme: "App",
      export_method: "app-store"
    )

    # Upload to TestFlight
    upload_to_testflight(
      skip_waiting_for_build_processing: true
    )

    # Send notification (optional)
    slack(
      message: "Successfully uploaded a new beta build to TestFlight",
      channel: "#ios-builds"
    )
  end

  # Lane for App Store release
  lane :release do
    # Increment build number
    increment_build_number(xcodeproj: "App.xcodeproj")

    # Build the app
    build_app(
      scheme: "App",
      export_method: "app-store"
    )

    # Upload to App Store
    upload_to_app_store(
      submit_for_review: true,
      automatic_release: false,
      force: true,
      skip_metadata: false,
      skip_screenshots: false
    )
  end

  # Lane for screenshots
  lane :screenshots do
    snapshot
  end

  # Lane for code signing
  lane :certificates do
    match(type: "appstore")
  end

end
```

### Step 4: Create API Key for Automation

To avoid entering passwords:

1. Go to App Store Connect
2. Click **Users and Access** > **Keys**
3. Click **+** to generate new key
4. Name: "Fastlane CI"
5. Access: **App Manager**
6. Download **AuthKey_XXXXXX.p8** file
7. Save to `ios/App/fastlane/` (never commit this!)

Add to `Fastfile`:

```ruby
app_store_connect_api_key(
  key_id: "YOUR_KEY_ID",
  issuer_id: "YOUR_ISSUER_ID",
  key_filepath: "./AuthKey_XXXXXX.p8"
)
```

### Step 5: Run Fastlane Commands

```bash
cd /Users/natrajbontha/dev/html/speech_therapy

# Upload to TestFlight
npm run fastlane:beta

# Or directly:
cd ios/App && fastlane beta

# Release to App Store
npm run fastlane:release
```

### Step 6: Continuous Integration (Optional)

Integrate with GitHub Actions:

Create `.github/workflows/ios.yml`:

```yaml
name: iOS Build and Deploy

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

jobs:
  build:
    runs-on: macos-latest

    steps:
    - uses: actions/checkout@v3

    - name: Set up Node.js
      uses: actions/setup-node@v3
      with:
        node-version: '18'

    - name: Install dependencies
      run: npm install

    - name: Sync Capacitor
      run: npx cap sync

    - name: Install CocoaPods
      run: |
        cd ios/App
        pod install

    - name: Build and Test
      run: |
        cd ios/App
        fastlane beta
      env:
        APP_STORE_CONNECT_API_KEY_ID: ${{ secrets.APP_STORE_CONNECT_API_KEY_ID }}
        APP_STORE_CONNECT_ISSUER_ID: ${{ secrets.APP_STORE_CONNECT_ISSUER_ID }}
        APP_STORE_CONNECT_API_KEY_CONTENT: ${{ secrets.APP_STORE_CONNECT_API_KEY_CONTENT }}
```

---

## 🔧 Troubleshooting

### Common Issues

#### 1. Code Signing Errors
**Problem**: "No signing identity found"
**Solution**:
```bash
# In Xcode, go to Preferences > Accounts
# Select your Apple ID > Download Manual Profiles
# Or use Fastlane Match for team signing
fastlane match development
fastlane match appstore
```

#### 2. CocoaPods Issues
**Problem**: "Unable to find a specification for..."
**Solution**:
```bash
cd ios/App
pod repo update
pod install
```

#### 3. Capacitor Sync Issues
**Problem**: "Changes not appearing in iOS app"
**Solution**:
```bash
# Clean and rebuild
npx cap sync ios
cd ios/App
pod install
# Then rebuild in Xcode
```

#### 4. Firebase Configuration
**Problem**: "Firebase not working in iOS"
**Solution**:
1. Download `GoogleService-Info.plist` from Firebase Console
2. Add to Xcode project (drag into `App` folder)
3. Ensure it's in **Copy Bundle Resources** build phase

#### 5. Microphone Permission Denied
**Problem**: Microphone not working
**Solution**:
- Check `Info.plist` has `NSMicrophoneUsageDescription`
- Reset privacy settings in Settings > General > Reset > Reset Location & Privacy
- Request permissions in code before using

#### 6. TestFlight Build Processing Forever
**Problem**: Build stuck in "Processing" state
**Solution**:
- Usually takes 30 mins to 2 hours
- Check email for "Invalid Binary" notification
- Common causes: Missing compliance info, crash on launch

#### 7. App Store Rejection: Guideline 2.1 - Performance
**Problem**: App crashes or has bugs
**Solution**:
- Test thoroughly on physical devices
- Use TestFlight to catch bugs
- Add crash reporting (Firebase Crashlytics)
- Fix all bugs before submission

---

## 📊 App Store Optimization (ASO)

### Tips for Better Visibility

1. **App Name**: Keep it clear and searchable (max 30 chars)
2. **Subtitle**: Describe your app (max 30 chars)
3. **Keywords**: Research and use relevant keywords (max 100 chars)
4. **Icon**: Professional, recognizable at small sizes
5. **Screenshots**: Show key features, add text overlays
6. **Preview Video**: Hook users in first 3 seconds
7. **Description**: Clear, benefit-focused, use formatting
8. **Ratings**: Encourage happy users to leave reviews

### Launch Checklist

- [ ] App tested on multiple iOS versions
- [ ] All features work offline (if applicable)
- [ ] Microphone permissions handled gracefully
- [ ] App doesn't crash on any screen
- [ ] Privacy policy published online
- [ ] Support email/website available
- [ ] App Store screenshots prepared (6.7", 6.5", 5.5" displays)
- [ ] App icon uploaded (1024x1024px)
- [ ] App description written and optimized
- [ ] Keywords researched and added
- [ ] Age rating set correctly
- [ ] Pricing configured
- [ ] All metadata complete in App Store Connect
- [ ] TestFlight testing completed
- [ ] Crash logs reviewed and fixed
- [ ] Submitted for App Review

---

## 🎯 Next Steps

After successful deployment:

1. **Monitor Analytics**
   - Install Google Analytics or Firebase Analytics
   - Track user behavior and engagement

2. **Collect Feedback**
   - Monitor App Store reviews
   - Set up in-app feedback form
   - Create user survey

3. **Plan Updates**
   - Fix bugs reported by users
   - Add requested features
   - Improve performance

4. **Marketing**
   - Share on social media
   - Create landing page
   - Reach out to your target community
   - Write blog posts
   - Submit to app review sites

5. **Monetization** (if desired)
   - In-app purchases for premium features
   - Subscription model for advanced features
   - One-time purchase to remove ads

---

## 📚 Additional Resources

### Documentation
- [Capacitor iOS Docs](https://capacitorjs.com/docs/ios)
- [Fastlane Docs](https://docs.fastlane.tools/)
- [App Store Connect Help](https://developer.apple.com/app-store-connect/)
- [Human Interface Guidelines](https://developer.apple.com/design/human-interface-guidelines/)

### Communities
- [Capacitor Discord](https://discord.gg/UPYYRhtyzp)
- [iOS Developers Subreddit](https://reddit.com/r/iOSProgramming)
- [Stack Overflow - iOS](https://stackoverflow.com/questions/tagged/ios)

### Tools
- [App Icon Generator](https://appicon.co/)
- [Screenshot Framer](https://theapplaunchpad.com/)
- [ASO Tools](https://www.apptweak.com/)

---

## 📝 Quick Command Reference

```bash
# Project setup
npm install
npx cap init
npx cap add ios
npx cap sync

# Development
npx cap open ios
npx cap copy ios
npx cap sync ios

# Fastlane
cd ios/App
fastlane beta          # Upload to TestFlight
fastlane release       # Submit to App Store
fastlane screenshots   # Generate screenshots

# Xcode command line
xcodebuild clean
xcodebuild archive
xcodebuild -list      # List schemes
```

---

**Good luck with your iOS app! 🚀**

If you encounter any issues not covered here, feel free to ask for help or consult the official documentation.
