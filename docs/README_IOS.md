# Speech Therapy iOS App - Quick Start

## 🚀 Quick Setup (5 minutes)

```bash
# Run the automated setup script
./setup-ios.sh

# Open Xcode
npm run capacitor:open:ios

# That's it! Configure signing in Xcode and run.
```

## 📋 Prerequisites

- **macOS** (Monterey or later)
- **Xcode 15+** (Mac App Store)
- **Apple Developer Account** ($99/year for App Store deployment)

## 🎯 Quick Commands

```bash
# Development
npm run ios:build              # Sync and open in Xcode
npm run capacitor:sync         # Sync web changes to iOS
npm run capacitor:open:ios     # Open Xcode project

# Testing
# Build and run in Xcode (⌘R)
# Or select device and click Run button

# Deployment
npm run fastlane:beta          # Upload to TestFlight
npm run fastlane:release       # Submit to App Store
```

## 📖 Full Documentation

See **[IOS_DEPLOYMENT_GUIDE.md](./IOS_DEPLOYMENT_GUIDE.md)** for complete instructions covering:

- ✅ Detailed setup instructions
- ✅ Xcode configuration
- ✅ App Store Connect setup
- ✅ TestFlight beta testing
- ✅ App Store submission process
- ✅ Fastlane automation
- ✅ Troubleshooting guide
- ✅ App Store Optimization tips

## 🎨 Assets Needed

Before App Store submission, prepare:

1. **App Icon**: 1024x1024px PNG (no transparency)
2. **Screenshots**:
   - iPhone 15 Pro Max (6.7"): 1290 x 2796px
   - iPhone 11 Pro Max (6.5"): 1242 x 2688px
   - iPhone 8 Plus (5.5"): 1242 x 2208px
3. **Privacy Policy**: Published URL (required)
4. **Support URL**: Website or contact page

## 💰 Cost Breakdown

- Apple Developer Program: **$99/year** (required for App Store)
- TestFlight: **Free** (included)
- Development tools: **Free** (Xcode, Capacitor, Fastlane)

## ⚡ Development Workflow

1. **Make changes** to `index.html` or assets
2. **Sync to iOS**: `npm run capacitor:sync`
3. **Test in Xcode**: Run on simulator or device
4. **Iterate** until ready
5. **Deploy**: Use Fastlane or Xcode to upload

## 🔑 Key Files

- `capacitor.config.json` - Capacitor configuration
- `ios/App/App.xcworkspace` - Xcode workspace (open this, not .xcodeproj)
- `ios/App/App/Info.plist` - iOS app configuration
- `package.json` - Dependencies and scripts
- `setup-ios.sh` - Automated setup script

## 🆘 Quick Troubleshooting

**App not syncing changes?**
```bash
npx cap sync ios
```

**CocoaPods issues?**
```bash
cd ios/App
pod repo update
pod install
```

**Code signing errors?**
- In Xcode: Select project > Signing & Capabilities
- Enable "Automatically manage signing"
- Select your Team

**Microphone not working?**
- Add permissions to `Info.plist` (see full guide)
- Request permissions before use
- Test on real device (simulators don't have mics)

## 📞 Support

- **Full Guide**: [IOS_DEPLOYMENT_GUIDE.md](./IOS_DEPLOYMENT_GUIDE.md)
- **Capacitor Docs**: https://capacitorjs.com/docs/ios
- **Apple Developer**: https://developer.apple.com/support/
- **GitHub Issues**: (your repo URL)

---

**Ready to deploy?** Follow the complete guide in `IOS_DEPLOYMENT_GUIDE.md`
