# Android Setup Guide

This guide helps you set up and deploy the Speech Therapy app to Android devices and the Google Play Store.

## Two Setup Options

### Option A: CLI-Only Setup (Recommended) 🚀
**Pros:** Lightweight (~2-3 GB), fast, perfect for CI/CD
**Cons:** No visual editor, no GUI tools

**Quick setup:**
```bash
cd deployment && ./setup-android-cli.sh
```

This automated script installs:
- OpenJDK 17
- Android command-line tools
- SDK Platform & Build Tools
- Platform tools (adb, etc.)
- Optional: Emulator

**Saves ~12 GB** compared to Android Studio!

---

### Option B: Full Android Studio
**Pros:** Visual editor, GUI debugger, easier for beginners
**Cons:** Large download (~15 GB), slower

### 1. Install Android Studio
Download and install Android Studio from https://developer.android.com/studio

### 2. Install Java Development Kit (JDK)
Android requires JDK 11 or later:
```bash
# Check if Java is installed
java -version

# If not installed, download from:
# https://www.oracle.com/java/technologies/downloads/
```

### 3. Set up Android SDK
1. Open Android Studio
2. Go to `Tools` → `SDK Manager`
3. Install:
   - Android SDK Platform (API 33 or later)
   - Android SDK Build-Tools
   - Android Emulator
   - Android SDK Platform-Tools

### 4. Configure Environment Variables
Add to your `~/.zshrc` or `~/.bash_profile`:
```bash
export ANDROID_HOME=$HOME/Library/Android/sdk
export PATH=$PATH:$ANDROID_HOME/tools
export PATH=$PATH:$ANDROID_HOME/platform-tools
```

Then reload:
```bash
source ~/.zshrc  # or source ~/.bash_profile
```

## Development Workflow

### 1. Sync Web Assets to Android
```bash
./what-do-you-want-2-do.sh 4
# or directly:
cd deployment && ./sync-web-to-android.sh
```

This script will:
- Update version info
- Copy index.html to www/
- Sync web assets to Android
- Clean and build the app
- Install on connected device/emulator

### 2. Run on Emulator
1. Open Android Studio
2. Go to `Tools` → `Device Manager`
3. Create a new virtual device (e.g., Pixel 6 API 33)
4. Start the emulator
5. Run the sync script (option 4)

### 3. Run on Physical Device
1. Enable Developer Options on your Android device:
   - Go to `Settings` → `About Phone`
   - Tap `Build Number` 7 times
2. Enable USB Debugging:
   - Go to `Settings` → `Developer Options`
   - Enable `USB Debugging`
3. Connect device via USB
4. Verify connection: `adb devices`
5. Run the sync script (option 4)

## Publishing to Play Store

### 1. Create a Google Play Developer Account
- Go to https://play.google.com/console
- Pay the one-time $25 registration fee
- Complete your account setup

### 2. Configure App Signing

#### Generate a keystore:
```bash
keytool -genkey -v -keystore my-release-key.keystore \
  -alias my-key-alias -keyalg RSA -keysize 2048 -validity 10000
```

#### Update android/app/build.gradle:
```gradle
android {
    ...
    signingConfigs {
        release {
            storeFile file('my-release-key.keystore')
            storePassword 'YOUR_KEYSTORE_PASSWORD'
            keyAlias 'my-key-alias'
            keyPassword 'YOUR_KEY_PASSWORD'
        }
    }
    buildTypes {
        release {
            signingConfig signingConfigs.release
            ...
        }
    }
}
```

**IMPORTANT:** Never commit your keystore or passwords to git!
Add to .gitignore:
```
*.keystore
keystore.properties
```

### 3. Build Release AAB
```bash
./what-do-you-want-2-do.sh 5
# or directly:
cd deployment && ./publish-playstore.sh
```

The AAB file will be created at:
`android/app/build/outputs/bundle/release/app-release.aab`

### 4. Upload to Play Store
1. Go to Google Play Console
2. Create a new app or select existing app
3. Go to `Release` → `Production` (or `Testing` for testing track)
4. Click `Create new release`
5. Upload the AAB file
6. Fill in release notes
7. Review and roll out

## App Configuration

### Update App Details
Edit `android/app/src/main/res/values/strings.xml`:
```xml
<resources>
    <string name="app_name">Speech Therapy</string>
    <string name="title_activity_main">Speech Therapy</string>
    <string name="package_name">com.speechtherapy.app</string>
</resources>
```

### Update Package Name
If you need to change the package name:
1. Edit `android/app/build.gradle`:
```gradle
defaultConfig {
    applicationId "com.yourcompany.yourapp"
    ...
}
```
2. Rename folder structure in `android/app/src/main/java/`
3. Update `android/app/src/main/AndroidManifest.xml`

### Update App Icon
Replace icons in:
- `android/app/src/main/res/mipmap-*/ic_launcher.png`
- `android/app/src/main/res/mipmap-*/ic_launcher_round.png`

Use Android Studio's Image Asset tool:
1. Right-click on `res` folder
2. `New` → `Image Asset`
3. Follow the wizard

## Troubleshooting

### Build Fails
```bash
# Clean build
cd android
./gradlew clean

# Check for errors
./gradlew assembleDebug --stacktrace
```

### Device Not Detected
```bash
# Restart adb
adb kill-server
adb start-server
adb devices
```

### Permission Issues
Make sure your AndroidManifest.xml includes necessary permissions:
```xml
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.RECORD_AUDIO" />
```

## Next Steps

1. **Test on multiple devices** - Test different screen sizes and Android versions
2. **Configure Firebase** - Set up Firebase for Android if using Firebase services
3. **Add Google Sign-In** - Configure OAuth credentials for Android
4. **Set up crash reporting** - Integrate Firebase Crashlytics or similar
5. **Optimize performance** - Use Android Profiler in Android Studio

## Resources

- [Capacitor Android Documentation](https://capacitorjs.com/docs/android)
- [Android Developer Guide](https://developer.android.com/guide)
- [Google Play Console Help](https://support.google.com/googleplay/android-developer)
- [Signing Your App](https://developer.android.com/studio/publish/app-signing)
