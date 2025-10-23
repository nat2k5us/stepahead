# Converting Template to Your App

This guide explains how to convert the base template (currently configured as "TacoTalk") into your own app (like "StarGazing").

## Current State

The template is currently configured with **TacoTalk** as a test/example app:
- App Name: TacoTalk
- Bundle ID: com.burrito.tacotalk
- Display Name: TacoTalk
- Theme: Taco-themed with 🌮 icon
- Firebase: **FAKE/PLACEHOLDER credentials** (see below)

### ⚠️ Important: TacoTalk Firebase Credentials are Fake!

The template includes **dummy Firebase credentials** that are NOT real:

```javascript
// These are FAKE placeholders - NOT a real Firebase project!
Firebase Project ID:    tacotalk-firebase-42          // Fake project
API Key:                AIzaSyTest123FakeTacoKey456   // Notice "Test" and "Fake"
Auth Domain:            tacotalk-firebase-42.firebaseapp.com
Storage Bucket:         tacotalk-firebase-42.firebasestorage.app
Messaging Sender ID:    987654321
App ID:                 1:987654321:web:abc123tacotest
Measurement ID:         G-TACOTEST123
```

**Why fake credentials?**
- ✅ Template works out-of-the-box for testing UI/UX
- ✅ You can explore the structure without Firebase setup
- ✅ No risk of accidentally using someone else's Firebase
- ✅ Clear indicator that you must customize it
- ⚠️ Backend features (auth, database, storage) won't work until you add real credentials

**What works with fake credentials:**
- All UI/navigation
- Theme switching
- Layout and design testing
- Local development

**What doesn't work:**
- User authentication
- Database operations
- File storage
- Any Firebase-dependent features

## Flow to Convert to Your App

### Option 1: Using the Interactive Menu (Recommended) ⭐

**Step 1:** Run the FZF menu
```bash
./run-me-first.sh
```

**Step 2:** Select option **"🎯 Initialize template"** from the Setup section

**Step 3:** Follow the interactive prompts (details below)

### Option 2: Using the Classic Menu

```bash
./what-do-you-want-2-do.sh
```
Select option **6** - Initialize template

### Option 3: Direct Script Execution

```bash
./init-template.sh
```

## What the Init Script Does

The `init-template.sh` script performs a **complete transformation** of the template:

### 1️⃣ Collects Your App Information

The script will interactively prompt you for:

#### **Basic App Identity**
- **App Display Name**: "StarGazing"
  - What users see on their home screen
- **App Full Name**: "StarGazing - Explore the Night Sky"
  - Used in App Store listing
- **Short Description**: "Track constellations and celestial events"
  - Brief tagline for your app
- **Package Name**: "stargazing"
  - Lowercase, no spaces (used in package.json)
- **Bundle ID**: "com.yourcompany.stargazing"
  - Unique identifier (reverse domain format)

#### **Firebase Configuration**

**IMPORTANT**: You must create a REAL Firebase project first!

**Step 1: Create Firebase Project**
1. Go to [Firebase Console](https://console.firebase.google.com)
2. Click "Add project" (or use existing project)
3. Follow the setup wizard:
   - Enter project name (e.g., "stargazing-app-2024")
   - Choose whether to enable Google Analytics (recommended)
   - Accept terms and create project

**Step 2: Add Web App to Your Firebase Project**
1. In Firebase Console, click the **Web icon** (</>)
2. Register your app:
   - App nickname: "StarGazing Web" (or your app name)
   - Check "Also set up Firebase Hosting" (optional)
   - Click "Register app"

**Step 3: Copy Your Firebase Config**

You'll see a configuration object like this:
```javascript
const firebaseConfig = {
  apiKey: "AIzaSyC1a2b3c4d5e6f7g8h9i0j1k2l3m4n5o6p",  // REAL key
  authDomain: "stargazing-app-2024.firebaseapp.com",
  projectId: "stargazing-app-2024",
  storageBucket: "stargazing-app-2024.appspot.com",
  messagingSenderId: "123456789012",
  appId: "1:123456789012:web:abc123def456ghi789jkl",
  measurementId: "G-ABC1234XYZ"
};
```

**Step 4: Copy These Values for init-template.sh**

When `init-template.sh` prompts you, enter:
- **Project ID**: `stargazing-app-2024` (from projectId)
- **API Key**: `AIzaSyC1a2b3c4d5e6f7g8h9i0j1k2l3m4n5o6p` (from apiKey)
- **Auth Domain**: `stargazing-app-2024.firebaseapp.com` (from authDomain)
- **Storage Bucket**: `stargazing-app-2024.appspot.com` (from storageBucket)
- **Messaging Sender ID**: `123456789012` (from messagingSenderId)
- **App ID**: `1:123456789012:web:abc123def456ghi789jkl` (from appId)
- **Measurement ID**: `G-ABC1234XYZ` (from measurementId - optional)

**Step 5: Download Config Files for Native Apps**

After registering the web app:
- **For iOS**: Download `GoogleService-Info.plist`
  - Add iOS app in Firebase Console
  - Enter bundle ID (e.g., com.astronomy.stargazing)
  - Download the plist file
  - Place in `ios/App/App/GoogleService-Info.plist`

- **For Android**: Download `google-services.json`
  - Add Android app in Firebase Console
  - Enter package name (e.g., com.astronomy.stargazing)
  - Download the json file
  - Place in `android/app/google-services.json`

**Common Mistakes to Avoid:**
- ❌ Using the fake TacoTalk credentials
- ❌ Forgetting to create the Firebase project first
- ❌ Using wrong bundle ID (must match your app)
- ❌ Not downloading the native config files (plist/json)
- ✅ Keep Firebase Console open while running init-template.sh

#### **Company/Developer Details**
- **Company Name**: "Your Company Name"
- **Website**: "www.yourcompany.com"
- **Developer Name**: Your name
- **Support Email**: support@yourdomain.com
- **Privacy Email**: privacy@yourdomain.com
- **Contact Phone**: +1 (555) 123-4567
- **Company Address**: Full mailing address

#### **Deployment Settings**
- **Primary Domain**: yourdomain.com
- **Netlify Site Name**: your-netlify-site
- **App Category**: Lifestyle / Education / Entertainment
- **Keywords**: stargazing,astronomy,stars,constellations
- **Age Rating**: 4+ / 9+ / 12+ / 17+

#### **Design Preferences**
- **Primary Color**: #1a237e (hex color code)
  - Main theme color for your app

#### **Navigation Configuration**
- **Login Icon**: 🌟 (emoji)
- For each of 4 tabs:
  - **Tab ID**: home, explore, favorites, profile
  - **Tab Icon**: 🏠, 🔭, ⭐, 👤
  - **Tab Label**: Home, Explore, Favorites, Profile

### 2️⃣ Files That Get Updated

The script performs find-and-replace across these files:

#### **Configuration Files**
```
✓ package.json              - name, description, keywords
✓ capacitor.config.json     - appId, appName, colors
✓ .firebaserc               - Firebase project ID
```

#### **Web Files**
```
✓ index.html                - All template values, Firebase config
✓ web/index.html            - Same updates for web deployment
✓ ios/App/App/public/       - iOS webview content
```

#### **iOS Files**
```
✓ ios/App/App/Info.plist    - Bundle ID, display name, URL schemes
```

#### **Android Files**
```
✓ android/app/src/main/res/values/strings.xml  - App name
✓ android/app/build.gradle  - Package ID, app name
```

### 3️⃣ What Gets Replaced

All template placeholders are replaced:

```
{{APP_DISPLAY_NAME}}       → StarGazing
{{APP_FULL_NAME}}          → StarGazing - Explore the Night Sky
{{APP_SHORT_DESC}}         → Track constellations and celestial events
{{PACKAGE_NAME}}           → stargazing
{{BUNDLE_ID}}              → com.yourcompany.stargazing
{{FIREBASE_PROJECT_ID}}    → your-firebase-project
{{FIREBASE_API_KEY}}       → AIza...
{{COMPANY_NAME}}           → Your Company Name
{{DEVELOPER_NAME}}         → Your Name
{{SUPPORT_EMAIL}}          → support@yourdomain.com
{{PRIMARY_COLOR}}          → #1a237e
{{LOGIN_ICON}}             → 🌟
{{NAV_TAB_1_ID}}           → home
{{NAV_TAB_1_ICON}}         → 🏠
{{NAV_TAB_1_LABEL}}        → Home
... and many more
```

## Example: TacoTalk → StarGazing Conversion

### Before (TacoTalk)
```javascript
// package.json
{
  "name": "tacotalk",
  "description": "A revolutionary app for serious taco enthusiasts"
}

// capacitor.config.json
{
  "appId": "com.burrito.tacotalk",
  "appName": "TacoTalk"
}
```

### After Running init-template.sh (StarGazing)
```javascript
// package.json
{
  "name": "stargazing",
  "description": "Track constellations and celestial events"
}

// capacitor.config.json
{
  "appId": "com.yourcompany.stargazing",
  "appName": "StarGazing"
}
```

## Step-by-Step Example Session

```bash
$ ./init-template.sh

🚀 Welcome to the Base Template Initializer

This script will help you convert this base template into your new project.

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
App Identity
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

App Display Name (shown on home screen) [MyApp]: StarGazing
App Full Name (for App Store) [My Awesome App]: StarGazing - Explore the Night Sky
Short Description [A great mobile app]: Track constellations and celestial events
Package Name (lowercase, no spaces) [myapp]: stargazing
Bundle/Package ID (com.company.app) [com.example.myapp]: com.astronomy.stargazing

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Firebase Configuration
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Firebase Project ID: stargazing-app-2024
Firebase API Key: AIzaSyD...
Firebase Auth Domain [stargazing-app-2024.firebaseapp.com]:
...

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Design Preferences
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Primary Color (hex code) [#667eea]: #1a237e

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Navigation Configuration
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Login screen icon (emoji) [🔐]: 🌟

Tab 1 - ID [home]:
Tab 1 - Icon (emoji) [🏠]:
Tab 1 - Label [Home]:

Tab 2 - ID [explore]: telescope
Tab 2 - Icon (emoji) [🔍]: 🔭
Tab 2 - Label [Explore]: Constellations

...

✓ Configuration files updated
✓ Web files updated
✓ iOS files updated
✓ Android files updated

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✓ Template initialization complete!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Next steps:
1. Replace icon.jpg with your app icon (1024x1024px)
2. Update iOS icons in ios/App/App/Assets.xcassets/
3. Update Android icons in android/app/src/main/res/mipmap-*/
4. Add Firebase config files:
   - ios/App/App/GoogleService-Info.plist
   - android/app/google-services.json
5. Run: npm install
6. Test: ./run-me-first.sh → "Sync web to iOS"
```

## After Initialization

### Manual Steps Required

1. **Replace App Icons**
   ```bash
   # Replace the placeholder icon
   cp your-icon.jpg icon.jpg
   ```

2. **Update iOS Icons**
   - Open `ios/App/App/Assets.xcassets/AppIcon.appiconset/`
   - Replace all icon sizes
   - Or use a tool like [appicon.co](https://appicon.co)

3. **Update Android Icons**
   - Update icons in `android/app/src/main/res/mipmap-*/`
   - Include all density sizes (mdpi, hdpi, xhdpi, xxhdpi, xxxhdpi)

4. **Add Firebase Configuration Files**
   ```bash
   # Download from Firebase Console
   # iOS: Add GoogleService-Info.plist to ios/App/App/
   # Android: Add google-services.json to android/app/
   ```

5. **Install Dependencies**
   ```bash
   npm install
   ```

6. **Sync and Test**
   ```bash
   ./run-me-first.sh
   # Select: 🔄 Sync web to iOS
   # Then test in Xcode simulator
   ```

## Can You Re-run init-template.sh?

**Yes!** You can run it multiple times:
- It will **overwrite** the current configuration
- Useful if you made a mistake or want to change something
- All values will be replaced again

## Important Notes

### ⚠️ Before Running init-template.sh

1. **Commit your changes** (if you've made customizations)
   ```bash
   git add -A
   git commit -m "Save current state before re-initialization"
   ```

2. **Have your Firebase project ready** ⚠️ CRITICAL
   - **DO NOT** use the fake TacoTalk credentials!
   - Create a REAL project at [console.firebase.google.com](https://console.firebase.google.com)
   - Add a web app to get configuration values
   - Copy all the config values before starting init-template.sh
   - See the detailed Firebase setup guide above
   - Keep Firebase Console tab open during initialization

3. **Choose your bundle ID carefully**
   - Cannot be easily changed after App Store submission
   - Must be unique (not used by any other app)
   - Follow reverse domain format: `com.company.appname`

### 🎯 What Doesn't Get Changed

These things remain the same (you customize later):
- App functionality/features (tabs, pages)
- Code logic (authentication, database)
- Deployment scripts
- Documentation

### 💡 Quick Tips

1. **TacoTalk is just a demo**: All credentials are FAKE - you must create your own Firebase project
2. **Firebase FIRST**: Create your Firebase project BEFORE running init-template.sh
3. **Keep TacoTalk for testing**: You can clone the repo to have a test version
4. **Bundle ID**: Use your real domain in reverse: `com.mydomain.myapp`
5. **Verify with show-config**: Use `./show-config.sh` to check if you're still using fake credentials
6. **Colors**: Pick your brand color, use hex format (#RRGGBB)
7. **Icons**: Use emojis for navigation tabs (works great on iOS/Android)

## Troubleshooting

### "Bundle ID already exists"
- Choose a different bundle ID
- Check App Store Connect for conflicts

### "Firebase not connecting"
**Symptom**: App loads but authentication/database doesn't work

**Causes & Solutions**:
1. **Still using fake TacoTalk credentials**
   - Check with `./show-config.sh`
   - Look for `tacotalk-firebase-42` or `AIzaSyTest123FakeTacoKey456`
   - Solution: Run `./init-template.sh` with REAL Firebase credentials

2. **Incorrect API key**
   - Verify API key in Firebase Console → Project Settings → General
   - Should start with `AIzaSy` followed by random characters
   - Should NOT contain words like "Test" or "Fake"

3. **Wrong Firebase project**
   - Check project ID matches what's in Firebase Console
   - Verify you're looking at the correct Firebase project

4. **Domain not whitelisted**
   - Firebase Console → Authentication → Settings
   - Add your domain to "Authorized domains"
   - For local dev, add `localhost`

5. **Missing native config files**
   - iOS: Check for `ios/App/App/GoogleService-Info.plist`
   - Android: Check for `android/app/google-services.json`
   - Download from Firebase Console → Add App → iOS/Android

**How to verify you have REAL credentials**:
```bash
./show-config.sh
# Look at Firebase section - if you see:
#   Project ID: tacotalk-firebase-42 ✓  ← BAD! Still using fake
#   API Key: AIzaSyTest123FakeTacoKey456 ✓  ← BAD! Contains "Test" and "Fake"
#
# Should see:
#   Project ID: your-real-project (customized)  ← GOOD!
#   API Key: AIzaSyC1a2b3c... (customized)  ← GOOD! Real key
```

### "Icons not showing"
- Make sure you replaced icon files after init
- Rebuild the app: `npx cap sync`

## Viewing Current Configuration

### When to View Configuration

You might want to view the current template configuration to:
- Check if the template has been customized
- See what values are currently set
- Compare current values to TacoTalk defaults
- Debug configuration issues
- Document your app setup
- Before running init-template or revert

### How to View Configuration

**Option 1: Using the FZF Menu (Recommended)**
```bash
./run-me-first.sh
# Select: 📋 Show current config
```

**Option 2: Using the Classic Menu**
```bash
./what-do-you-want-2-do.sh
# Select option 8 - Show current configuration
```

**Option 3: Direct Script Execution**
```bash
./show-config.sh
```

### What the Show Config Script Displays

The script shows all customizable parameters organized by category:

**📱 App Identity**
- Display Name
- Full Name
- Description
- Package Name
- Bundle ID

**🔥 Firebase Configuration**
- Project ID
- API Key
- Auth Domain
- Storage Bucket
- Messaging Sender ID
- App ID
- Measurement ID

**👤 Developer Information**
- Developer Name

**🎨 Navigation Configuration**
- Login Icon
- Tab 1-4: ID, Icon, Label

**📦 Version Information**
- iOS Version
- iOS Build Number

**🔑 OAuth Configuration**
- Google OAuth (iOS)

### Example Output

```bash
$ ./show-config.sh

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
│           Template Configuration Viewer              │
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

This shows all customizable parameters for this template.

Legend:
  Value ✓               = Using TacoTalk default
  Value (customized)    = Has been customized

✓ Template Status: Customized (8 of 25 parameters)

📱 App Identity
────────────────────────────────────────────────────────
  Display Name:         StarGazing (customized)
  Full Name:            StarGazing - Explore the Night Sky (customized)
  Description:          Track constellations and celestial events (customized)
  Package Name:         stargazing (customized)
  Bundle ID:            com.astronomy.stargazing (customized)

🔥 Firebase Configuration
────────────────────────────────────────────────────────
  Project ID:           stargazing-app-2024 (customized)
  API Key:              AIzaSyD... (customized)
  Auth Domain:          stargazing-app-2024.firebaseapp.com (customized)
  Storage Bucket:       stargazing-app-2024.firebasestorage.app ✓
  Messaging Sender ID:  987654321 ✓
  App ID:               1:987654321:web:... ✓
  Measurement ID:       G-TACOTEST123 ✓

👤 Developer Information
────────────────────────────────────────────────────────
  Developer Name:       Chef Burrito McGuacamole ✓

🎨 Navigation Configuration
────────────────────────────────────────────────────────
  Login Icon:           🌟 (customized)

  Tab 1:
    - ID:               telescope (customized)
    - Icon:             🔭 (customized)
    - Label:            Constellations (customized)

  Tab 2:
    - ID:               explore ✓
    - Icon:             🔍 ✓
    - Label:            Explore ✓

  ... (tabs 3-4)

📦 Version Information
────────────────────────────────────────────────────────
  iOS Version:          1.0 ✓
  iOS Build:            1 ✓

🔑 OAuth Configuration
────────────────────────────────────────────────────────
  Google OAuth (iOS):   com.googleusercontent.apps.tacotalk-test ✓

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

💡 Available Actions:
  • ./init-template.sh     - Reconfigure template
  • ./revert-template.sh   - Reset to TacoTalk defaults
  • ./run-me-first.sh      - Access deployment menu

📁 Files that contain these values:
  • package.json
  • capacitor.config.json
  • .firebaserc
  • index.html, web/index.html
  • ios/App/App/Info.plist
  • android/app/src/main/res/values/strings.xml
  • android/app/build.gradle
```

### Understanding the Output

**Color Coding:**
- **Green ✓**: Value matches TacoTalk default
- **Blue (customized)**: Value has been changed from default
- **Template Status**: Shows how many parameters are customized

**Use Cases:**
1. **Before Init**: See if template needs initialization
2. **After Init**: Verify all values were set correctly
3. **Debugging**: Check if a specific value is set properly
4. **Documentation**: Capture current configuration for team

## Reverting to TacoTalk (Starting Over)

### When to Revert

You might want to revert the template back to its original TacoTalk configuration if:
- You made a mistake during initialization
- Want to start over from scratch
- Testing the init-template script
- Need to reset to a clean state

### How to Revert

**Option 1: Using the FZF Menu (Recommended)**
```bash
./run-me-first.sh
# Select: 🔄 Revert to TacoTalk
```

**Option 2: Using the Classic Menu**
```bash
./what-do-you-want-2-do.sh
# Select option 7 - Revert template to TacoTalk defaults
```

**Option 3: Direct Script Execution**
```bash
./revert-template.sh
```

### What the Revert Script Does

✅ **Reverts these to TacoTalk defaults:**
- App name → TacoTalk
- Bundle ID → com.burrito.tacotalk
- Firebase config → Test credentials
- All branding and theming
- Navigation icons and labels
- Version numbers → 1.0 build 1

✅ **Creates a backup first:**
- Saves current config to `.template-backups/pre-revert-TIMESTAMP/`
- Can restore from backup if needed

✅ **Preserves these:**
- Your custom code changes
- Additional files you've added
- Git history
- Deployment scripts

### After Reverting

1. **Install dependencies**
   ```bash
   npm install
   ```

2. **Sync to iOS**
   ```bash
   ./run-me-first.sh
   # Select: 🔄 Sync web to iOS
   ```

3. **Test the app**
   - Verify it shows TacoTalk branding
   - Check that everything works

4. **When ready, initialize again**
   ```bash
   ./init-template.sh
   ```

### Example: Revert Session

```bash
$ ./revert-template.sh

🔄 Template Revert Tool
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

⚠️  WARNING

This will revert the template back to its original TacoTalk configuration.

What will be reset:
  • App name → TacoTalk
  • Bundle ID → com.burrito.tacotalk
  • Firebase config → Test credentials
  • All branding and theming
  • Navigation configuration

Continue with revert? [y/N]: y

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
         Reverting to TacoTalk Template
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📋 Detecting current configuration...

  Current App Name: StarGazing
  Current Bundle ID: com.astronomy.stargazing

  Reverting to: TacoTalk (com.burrito.tacotalk)

💾 Creating backup...
✓ Backup created at: .template-backups/pre-revert-20250122_143022

📝 Reverting configuration files...
✓ package.json reverted
✓ capacitor.config.json reverted
✓ .firebaserc reverted

🌐 Reverting HTML files...
✓ index.html reverted
✓ web/index.html reverted
✓ ios/App/App/public/index.html reverted

📱 Reverting iOS configuration...
✓ iOS Info.plist reverted (version reset to 1.0 build 1)

🤖 Reverting Android configuration...
✓ Android strings.xml reverted
✓ Android build.gradle reverted (version reset to 1.0 build 1)

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✅ Revert Complete!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Template has been reverted to TacoTalk configuration

Configuration:
  • App Name: TacoTalk
  • Bundle ID: com.burrito.tacotalk
  • Version: 1.0 (build 1)
  • Firebase: tacotalk-firebase-42 (test credentials)

Backup Location:
  .template-backups/pre-revert-20250122_143022

Next Steps:
  1. Run: npm install
  2. Sync: ./run-me-first.sh → "🔄 Sync web to iOS"
  3. Test the app
  4. When ready, run: ./init-template.sh to reconfigure

✓ Revert completed successfully!
```

### Backup Location

All backups are stored in `.template-backups/` with timestamps:
```
.template-backups/
├── pre-revert-20250122_143022/
│   ├── package.json
│   ├── capacitor.config.json
│   ├── .firebaserc
│   ├── index.html
│   ├── web/
│   └── Info.plist
└── pre-revert-20250122_150145/
    └── ...
```

**To restore from a backup:**
```bash
# If you need to undo a revert
cp .template-backups/pre-revert-20250122_143022/package.json ./
cp .template-backups/pre-revert-20250122_143022/capacitor.config.json ./
# ... etc
```

## Summary

**The flow is:**
1. Run `./run-me-first.sh` or `./init-template.sh`
2. Answer ~25-30 questions about your app
3. Script replaces ALL template values automatically
4. Manually add icons and Firebase config files
5. Run `npm install` and sync
6. Test your newly branded app!

**Configuration Management:**
- `./show-config.sh` - View current configuration and what's customized
- `./init-template.sh` - Initialize or reconfigure template
- `./revert-template.sh` - Reset to TacoTalk defaults (with backup)

**If you need to start over:**
- Run `./revert-template.sh` to reset to TacoTalk
- Creates a backup before reverting
- Can run init-template.sh again after reverting

**Time required:**
- Initial setup: 10-15 minutes
- View config: ~2 seconds
- Revert: ~10 seconds

**Result:** A completely transformed app with your branding, ready to customize the features!
