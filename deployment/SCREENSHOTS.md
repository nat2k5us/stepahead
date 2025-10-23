# Screenshot Capture Guide

This guide explains how to capture and upload screenshots for App Store and Play Store submissions.

## Quick Start

Run the screenshot capture script:

```bash
./deployment/capture-screenshots.sh
```

Or include it as part of your publish workflow:

```bash
./deployment/publish-testflight.sh   # Prompts for screenshots
./deployment/publish-playstore.sh     # Prompts for screenshots
```

## Screenshot Requirements

### App Store (iOS)

**Required Sizes:**
- **6.7" Display** (iPhone 16 Pro Max, iPhone 15 Pro Max): 1290 x 2796
- **6.5" Display** (iPhone 11 Pro Max, XS Max): 1242 x 2688
- **5.5" Display** (iPhone 8 Plus): 1242 x 2208

**Guidelines:**
- Minimum 2 screenshots
- Maximum 10 screenshots
- PNG or JPEG format
- RGB color space
- No transparency
- Portrait orientation recommended

### Play Store (Android)

**Required Sizes:**
- **Phone**: 1080 x 1920 or higher (up to 4K)
- **7" Tablet**: 1200 x 1920 or higher
- **10" Tablet**: 1600 x 2560 or higher

**Guidelines:**
- Minimum 2 screenshots
- Maximum 8 screenshots
- PNG or JPEG format
- 16:9 or 9:16 aspect ratio
- Portrait or landscape

## Screenshot Capture Process

### iOS (Automated)

The script will:
1. Launch iOS Simulator (iPhone 16 Pro Max)
2. Build and install the app
3. Guide you through capturing 5 screenshots:
   - Home screen with story list
   - Reading view (start of story)
   - Reading in progress (with word highlighting)
   - Profile settings
   - Speech recognition settings

Screenshots are saved to: `screenshots/ios/`

### Android (Manual)

The script will:
1. Connect to your Android device via ADB
2. Guide you through navigating the app
3. Capture screenshots from the device:
   - Home screen with story list
   - Reading view (start of story)
   - Reading in progress (with word highlighting)
   - Profile settings
   - Speech recognition settings

Screenshots are saved to: `screenshots/android/`

## Uploading Screenshots

### App Store Connect

1. Go to [App Store Connect](https://appstoreconnect.apple.com)
2. Select your app
3. Navigate to **App Store** tab
4. Scroll to **Screenshots** section
5. Select device size (6.7", 6.5", or 5.5")
6. Drag and drop screenshots or click **+** to upload
7. Arrange screenshots in desired order
8. Add captions/descriptions if needed
9. Click **Save**

### Google Play Console

1. Go to [Google Play Console](https://play.google.com/console)
2. Select your app
3. Navigate to **Store presence** → **Main store listing**
4. Scroll to **Screenshots** section
5. Select device type (Phone, 7" tablet, 10" tablet)
6. Click **+ Add screenshots**
7. Upload screenshots from `screenshots/android/`
8. Arrange screenshots in desired order
9. Click **Save**

## Screenshot Tips

### Composition
- Show key features and functionality
- Use actual content (not lorem ipsum)
- Capture important UI elements
- Show the app in action
- Highlight unique features

### Content
- Use real data from the app
- Show various story difficulties
- Demonstrate speech recognition working
- Display profile customization options
- Show progress/achievements

### Quality
- Use high-resolution images
- Ensure text is readable
- Good lighting and contrast
- No pixelation or artifacts
- Consistent styling across screenshots

## Adding Text Overlays (Optional)

You can add text overlays to screenshots using tools like:
- **Sketch** (macOS)
- **Figma** (Web-based)
- **Adobe Photoshop**
- **Preview** (macOS - basic editing)

Common overlay text:
- Feature highlights
- Benefits
- Call-to-action
- Key differentiators

## Automation Notes

The screenshot capture script (`capture-screenshots.sh`):
- Uses `xcrun simctl` for iOS screenshots
- Uses `adb` for Android screenshots
- Saves files with descriptive names
- Opens the folder when complete
- Can be run independently or as part of publish workflow

## Troubleshooting

### iOS Simulator Issues

**Simulator won't boot:**
```bash
xcrun simctl boot "iPhone 16 Pro Max"
```

**App won't install:**
```bash
xcrun simctl uninstall booted com.speechtherapy.app
```

**Screenshots are blank:**
- Wait a few seconds after navigating
- Make sure simulator is in foreground
- Try closing and reopening simulator

### Android Device Issues

**Device not detected:**
```bash
adb devices
adb kill-server
adb start-server
```

**Permission denied:**
```bash
adb shell settings put global usb_debugging 1
```

**Screenshots fail:**
- Check USB debugging is enabled
- Verify device has storage space
- Try revoking and re-granting USB debugging

## File Organization

```
screenshots/
├── ios/
│   ├── 01-home-screen.png
│   ├── 02-reading-view.png
│   ├── 03-reading-active.png
│   ├── 04-profile-settings.png
│   └── 05-speech-settings.png
└── android/
    ├── 01-home-screen.png
    ├── 02-reading-view.png
    ├── 03-reading-active.png
    ├── 04-profile-settings.png
    └── 05-speech-settings.png
```

## Related Documentation

- [App Store Connect Guidelines](https://developer.apple.com/app-store/product-page/)
- [Play Store Asset Guidelines](https://support.google.com/googleplay/android-developer/answer/9866151)
- [iOS Human Interface Guidelines](https://developer.apple.com/design/human-interface-guidelines/)
- [Android Design Guidelines](https://developer.android.com/design)
