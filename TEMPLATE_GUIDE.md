# Template Initialization Guide

This document explains how to use the base template to create a new mobile app project.

## Overview

This template provides a complete foundation for building cross-platform mobile applications with:
- **Web App**: HTML, CSS (Tailwind), JavaScript
- **iOS App**: Capacitor-based native app
- **Android App**: Capacitor-based native app
- **Firebase Backend**: Authentication, Firestore database
- **Deployment Scripts**: Automated deployment to TestFlight, App Store, and Google Play

## Template Placeholders

The template uses the following placeholders that will be replaced during initialization:

### App Information
- `{{APP_DISPLAY_NAME}}` - Short name shown under app icon
- `{{APP_FULL_NAME}}` - Full marketing name
- `{{APP_SHORT_DESC}}` - Brief description
- `{{PACKAGE_NAME}}` - NPM package name (lowercase, no spaces)
- `{{BUNDLE_ID}}` - App bundle identifier (e.g., com.company.appname)
- `{{APP_KEYWORDS}}` - Comma-separated keywords
- `{{APP_CATEGORY}}` - App Store category
- `{{AGE_RATING}}` - Age rating (e.g., 4+)

### Firebase Configuration
- `{{FIREBASE_PROJECT_ID}}` - Firebase project ID
- `{{FIREBASE_API_KEY}}` - Firebase API key
- `{{FIREBASE_AUTH_DOMAIN}}` - Firebase auth domain
- `{{FIREBASE_STORAGE_BUCKET}}` - Firebase storage bucket
- `{{FIREBASE_SENDER_ID}}` - Firebase messaging sender ID
- `{{FIREBASE_APP_ID}}` - Firebase app ID
- `{{FIREBASE_MEASUREMENT_ID}}` - Firebase analytics measurement ID

### Company & Contact
- `{{COMPANY_NAME}}` - Company or organization name
- `{{COMPANY_WEBSITE}}` - Company website
- `{{DEVELOPER_NAME}}` - Developer name
- `{{SUPPORT_EMAIL}}` - Support email address
- `{{PRIVACY_EMAIL}}` - Privacy-specific email
- `{{CONTACT_PHONE}}` - Contact phone number
- `{{COMPANY_ADDRESS}}` - Physical address

### URLs & Deployment
- `{{PRIMARY_DOMAIN}}` - Primary domain (without https://)
- `{{NETLIFY_SITE}}` - Netlify site name

### Design
- `{{PRIMARY_COLOR}}` - Primary brand color (hex code)

### OAuth (Optional)
- `{{GOOGLE_OAUTH_IOS}}` - Google OAuth client ID for iOS

## Step-by-Step Initialization

### 1. Clone or Download the Template

```bash
git clone <template-repo-url> my-new-app
cd my-new-app
```

### 2. Run the Initialization Script

```bash
chmod +x init-template.sh
./init-template.sh
```

The script will:
1. Prompt you for all required information
2. Show a summary for confirmation
3. Replace all placeholders in the codebase
4. Create a `.template-config` file with your configuration

### 3. Replace Assets

#### App Icon
- Replace `icon.jpg` with your app icon (1024x1024px recommended)
- Use a tool like [App Icon Generator](https://appicon.co/) to create all required sizes

#### iOS Icons
```bash
# iOS app icon location
ios/App/App/Assets.xcassets/AppIcon.appiconset/
```
Replace `AppIcon-512@2x.png` with your icon

#### Android Icons
```bash
# Android icon locations
android/app/src/main/res/mipmap-hdpi/
android/app/src/main/res/mipmap-mdpi/
android/app/src/main/res/mipmap-xhdpi/
android/app/src/main/res/mipmap-xxhdpi/
android/app/src/main/res/mipmap-xxxhdpi/
```

#### Splash Screens
- iOS: `ios/App/App/Assets.xcassets/Splash.imageset/`
- Android: `android/app/src/main/res/drawable-*/splash.png`

#### App-Specific Images
Replace or remove images in `images/` directory if they're app-specific

### 4. Configure Firebase

#### Create Firebase Project
1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Create a new project with your `{{FIREBASE_PROJECT_ID}}`
3. Add iOS and Android apps to your project

#### iOS Firebase Configuration
1. Download `GoogleService-Info.plist` from Firebase
2. Replace `ios/App/App/GoogleService-Info.plist`

#### Android Firebase Configuration
1. Download `google-services.json` from Firebase
2. Place it in `android/app/google-services.json`

#### Enable Authentication
In Firebase Console:
1. Go to Authentication → Sign-in method
2. Enable Email/Password
3. Enable Google (optional)
4. Enable other providers as needed

#### Configure Firestore
1. Go to Firestore Database
2. Create database in production mode
3. Update security rules as needed

### 5. Update Documentation

#### README.md
Add detailed information about your app:
- Feature list
- Usage instructions
- Installation requirements
- Screenshots

#### Privacy Policy
Create `PRIVACY_POLICY.md` with your privacy policy. Use `.template-examples/PRIVACY_POLICY.md` as a reference.

#### App Store Information
Create `APP_STORE_INFO.md` with your App Store metadata. Use `.template-examples/APP_STORE_INFO.md` as a reference.

### 6. Install Dependencies

```bash
npm install
```

### 7. Test the App

#### Web Version
```bash
npm run dev
# Open http://localhost:8000
```

#### iOS Version
```bash
npm run capacitor:sync
npm run capacitor:open:ios
# Build and run in Xcode
```

#### Android Version
```bash
npm run capacitor:sync
npx cap open android
# Build and run in Android Studio
```

### 8. Configure Code Signing

#### iOS
1. Open project in Xcode
2. Select the App target
3. Go to Signing & Capabilities
4. Select your Team
5. Xcode will automatically create signing certificates

#### Android
1. Generate a signing key:
```bash
keytool -genkey -v -keystore my-app-release-key.keystore -alias my-app-alias -keyalg RSA -keysize 2048 -validity 10000
```
2. Update `android/app/build.gradle` with signing configuration
3. Never commit the keystore file to version control

### 9. Customize Functionality

The template includes:
- Firebase Authentication (Email, Google, etc.)
- User profile management
- Leaderboard system
- Sample data and stories

Modify or remove these features based on your app's requirements.

### 10. Deploy

#### TestFlight (iOS Beta)
```bash
./deployment/publish-testflight.sh
```

#### App Store (iOS Production)
```bash
./deployment/publish-appstore.sh
```

#### Google Play (Android)
```bash
./deployment/publish-playstore.sh
```

## Files Modified by init-template.sh

The initialization script modifies the following files:

### Configuration Files
- `package.json`
- `capacitor.config.json`
- `.firebaserc`
- `ios/App/App/Info.plist`
- `ios/App/App.xcodeproj/project.pbxproj`
- `android/app/build.gradle`
- `android/app/src/main/res/values/strings.xml`

### HTML Files
- `index.html`
- `web/index.html`
- `ios/App/App/public/index.html`

### Documentation
- `README.md`

### Deployment Scripts
All scripts in `deployment/` directory that reference Firebase or bundle IDs

## Manual Customization

After initialization, you may want to manually customize:

### Colors
Update the color scheme in:
- `index.html` (Tailwind configuration)
- `capacitor.config.json` (splash screen and status bar)

### Permissions
Update permission descriptions in:
- `ios/App/App/Info.plist` (iOS)
- `android/app/src/main/AndroidManifest.xml` (Android)

### Features
Modify or remove features in `index.html`:
- Authentication methods
- Leaderboard
- User profiles
- Story/content management

### Firebase Collections
Update collection names in `index.html` if you're using different data structures:
- `reading_sessions` - Leaderboard data
- `stories` - Content data

## Troubleshooting

### Placeholders Not Replaced
If you see `{{PLACEHOLDER}}` text in your app:
1. Check if the script ran successfully
2. Manually search for remaining placeholders:
```bash
grep -r "{{" --include="*.html" --include="*.json" --include="*.xml" --include="*.plist" .
```
3. Replace manually if needed

### iOS Build Errors
- Make sure Xcode is installed
- Run `pod install` in `ios/App/` directory
- Clean build folder in Xcode (Shift+Cmd+K)
- Update CocoaPods: `sudo gem install cocoapods`

### Android Build Errors
- Make sure Android Studio is installed
- Update Gradle if prompted
- Sync project with Gradle files
- Invalidate caches and restart Android Studio

### Firebase Errors
- Verify Firebase configuration files are in place
- Check Firebase project settings match your configuration
- Enable required services in Firebase Console
- Update Firestore security rules if getting permission errors

## Next Steps

After initialization:

1. ✅ Run initialization script
2. ✅ Replace all assets (icons, splash screens, images)
3. ✅ Configure Firebase (download config files, enable services)
4. ✅ Update documentation (README, privacy policy, App Store info)
5. ✅ Install dependencies (`npm install`)
6. ✅ Test on web, iOS, and Android
7. ✅ Customize features for your use case
8. ✅ Configure code signing
9. ✅ Deploy to beta (TestFlight, Google Play Beta)
10. ✅ Submit to App Store and Google Play

## Support

If you encounter issues with the template, please:
1. Check this guide thoroughly
2. Review the example files in `.template-examples/`
3. Check documentation in `docs/` directory
4. Contact the template maintainer

## Template Version

Version: 1.0
Last Updated: 2025
Based on: iSpeakClear speech therapy app template

## License

[Add your license here]
