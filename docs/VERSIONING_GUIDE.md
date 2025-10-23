# Automatic Versioning Guide

## Overview

This project uses **automatic versioning** for all builds and deployments. Every time you publish to TestFlight or the App Store, the build number is automatically incremented.

## Version Number Format

iOS apps use two version identifiers:

### 1. Marketing Version (CFBundleShortVersionString)
- **Format**: `MAJOR.MINOR.PATCH` (e.g., `1.0.0`, `2.3.1`)
- **Visibility**: Users see this in the App Store
- **When to change**:
  - **MAJOR** (X.0.0): Breaking changes, major redesigns
  - **MINOR** (1.X.0): New features, significant updates
  - **PATCH** (1.0.X): Bug fixes, minor improvements

### 2. Build Number (CFBundleVersion)
- **Format**: Integer (e.g., `1`, `2`, `3`, `42`)
- **Visibility**: Internal only, visible in TestFlight
- **When to change**: Every single build uploaded to TestFlight/App Store
- **Must be**: Unique and monotonically increasing

## Current Version

Check your current version:
```bash
# Quick check
./increment-version.sh

# Or manually
/usr/libexec/PlistBuddy -c "Print :CFBundleShortVersionString" ios/App/App/Info.plist
/usr/libexec/PlistBuddy -c "Print :CFBundleVersion" ios/App/App/Info.plist
```

## Automatic Versioning

### TestFlight & App Store (Automatic)

When you run these scripts, the **build number is automatically incremented**:

```bash
./publish-testflight.sh     # Auto-increments build: 1.0.0 (5) → 1.0.0 (6)
./publish-appstore.sh        # Auto-increments build: 1.0.0 (6) → 1.0.0 (7)
```

**How it works**:
1. Script calls `./increment-version.sh build`
2. Build number increases by 1
3. Version files are updated
4. Build proceeds with new number

**No manual action needed!** 🎉

## Manual Versioning

### When to Manually Change Version

Change the marketing version when:
- 🎉 **Releasing a new feature** → Minor version (1.0.0 → 1.1.0)
- 🐛 **Releasing bug fixes only** → Patch version (1.0.0 → 1.0.1)
- 🚀 **Major redesign/rewrite** → Major version (1.9.5 → 2.0.0)

### Increment Build Number Only

```bash
./increment-version.sh build
# Result: 1.0.0 (5) → 1.0.0 (6)
```

### Increment Patch Version

For bug fix releases:
```bash
./increment-version.sh patch
# Result: 1.0.5 (42) → 1.0.6 (1)
# Note: Build number resets to 1
```

### Increment Minor Version

For new feature releases:
```bash
./increment-version.sh minor
# Result: 1.2.3 (15) → 1.3.0 (1)
# Note: Build number resets to 1
```

### Increment Major Version

For major releases:
```bash
./increment-version.sh major
# Result: 1.9.5 (100) → 2.0.0 (1)
# Note: Build number resets to 1
```

### Set Specific Version

Manually set both version and build:
```bash
./increment-version.sh set 2.5.0 1
# Result: Sets to 2.5.0 (1)
```

## Git Tags

When you increment a **marketing version** (not just build), the script will ask if you want to create a git tag:

```bash
./increment-version.sh minor
# ... version updated ...
# Create git tag v1.3.0? (y/n) y
# ✅ Created git tag: v1.3.0
```

### Viewing All Version Tags

```bash
git tag
# Output:
# v1.0.0
# v1.1.0
# v1.2.0
```

### Pushing Tags to Remote

```bash
# Push specific tag
git push origin v1.3.0

# Push all tags
git push --tags
```

### Checking Out a Specific Version

```bash
git checkout v1.2.0
```

## Typical Workflows

### 1. Regular TestFlight Build (No Version Change)

Just bug fixes and minor tweaks:

```bash
# Edit code
vim index.html

# Test locally
./sync-web-to-ios.sh

# Publish (auto-increments build)
./publish-testflight.sh
# 1.0.0 (5) → 1.0.0 (6)
```

### 2. Bug Fix Release (Patch Version)

Small bug fixes ready for App Store:

```bash
# Increment patch version
./increment-version.sh patch
# 1.0.5 → 1.0.6 (1)

# Commit version bump
git add ios/App/App/Info.plist ios/App/App.xcodeproj/project.pbxproj
git commit -m "Bump version to 1.0.6"
git push

# Publish (build auto-increments)
./publish-appstore.sh
# 1.0.6 (1) → 1.0.6 (2)
```

### 3. New Feature Release (Minor Version)

New features ready for App Store:

```bash
# Increment minor version
./increment-version.sh minor
# 1.2.5 → 1.3.0 (1)

# Create git tag? (y/n) y
# ✅ Created git tag: v1.3.0

# Commit and push
git add ios/App/App/Info.plist ios/App/App.xcodeproj/project.pbxproj
git commit -m "Release version 1.3.0"
git push
git push origin v1.3.0

# Publish to App Store
./publish-appstore.sh
# 1.3.0 (1) → 1.3.0 (2)
```

### 4. Major Release (Major Version)

Complete redesign or breaking changes:

```bash
# Increment major version
./increment-version.sh major
# 1.9.5 → 2.0.0 (1)

# Create git tag? (y/n) y
# ✅ Created git tag: v2.0.0

# Commit and push
git add ios/App/App/Info.plist ios/App/App.xcodeproj/project.pbxproj
git commit -m "Release version 2.0.0"
git push
git push origin v2.0.0

# Publish to App Store
./publish-appstore.sh
# 2.0.0 (1) → 2.0.0 (2)
```

## Version History

### Tracking Versions in Git

All version changes are tracked in git:

```bash
# View version history
git log --oneline --grep="version"

# View all tags
git tag -l
```

### App Store Connect

Track versions in App Store Connect:
1. Go to [App Store Connect](https://appstoreconnect.apple.com)
2. Select your app
3. View all versions and their status

## Best Practices

### ✅ Do's

- ✅ Let scripts auto-increment build numbers
- ✅ Increment patch version for bug fixes
- ✅ Increment minor version for new features
- ✅ Increment major version for breaking changes
- ✅ Create git tags for releases
- ✅ Commit version changes with descriptive messages
- ✅ Test on simulator before publishing

### ❌ Don'ts

- ❌ Don't manually edit build numbers (let scripts handle it)
- ❌ Don't skip version numbers
- ❌ Don't reuse build numbers
- ❌ Don't decrease version numbers
- ❌ Don't publish without testing first

## Troubleshooting

### "Build number already used"

Apple requires unique, increasing build numbers. If you get this error:

```bash
# Check current build
./increment-version.sh

# Manually set to higher number
./increment-version.sh set 1.0.0 50

# Then publish
./publish-testflight.sh
```

### "Version string is not valid"

Ensure version follows `MAJOR.MINOR.PATCH` format:

```bash
# Correct formats
1.0.0
2.5.3
10.0.1

# Incorrect formats
1.0          # Missing patch
1.0.0.1      # Too many parts
v1.0.0       # Don't include 'v' prefix
```

### Reset Version Files

If version files get out of sync:

```bash
# Reset to specific version
./increment-version.sh set 1.0.0 1

# Verify
/usr/libexec/PlistBuddy -c "Print :CFBundleShortVersionString" ios/App/App/Info.plist
/usr/libexec/PlistBuddy -c "Print :CFBundleVersion" ios/App/App/Info.plist
```

## Summary

### Quick Reference

| Task | Command | Example |
|------|---------|---------|
| Check version | `./increment-version.sh` | Shows: 1.0.0 (5) |
| Auto-increment | Happens automatically in publish scripts | - |
| Bug fix release | `./increment-version.sh patch` | 1.0.0 → 1.0.1 |
| New feature | `./increment-version.sh minor` | 1.0.5 → 1.1.0 |
| Major release | `./increment-version.sh major` | 1.9.5 → 2.0.0 |
| Manual set | `./increment-version.sh set 2.0.0 1` | Sets to 2.0.0 (1) |
| TestFlight | `./publish-testflight.sh` | Auto-increments build |
| App Store | `./publish-appstore.sh` | Auto-increments build |

### Version Lifecycle

```
Development
    ↓
./increment-version.sh minor     # 1.0.0 → 1.1.0 (1)
    ↓
./publish-testflight.sh          # 1.1.0 (1) → 1.1.0 (2) [Auto]
    ↓
Beta Testing & Fixes
    ↓
./publish-testflight.sh          # 1.1.0 (2) → 1.1.0 (3) [Auto]
    ↓
./publish-testflight.sh          # 1.1.0 (3) → 1.1.0 (4) [Auto]
    ↓
Ready for Release
    ↓
./publish-appstore.sh            # 1.1.0 (4) → 1.1.0 (5) [Auto]
    ↓
App Store Review (1-3 days)
    ↓
Released to Public! 🎉
```

## Resources

- **Semantic Versioning**: https://semver.org
- **Apple Versioning Guide**: https://developer.apple.com/documentation/bundleresources/information_property_list/cfbundleshortversionstring
- **TestFlight Builds**: https://developer.apple.com/testflight/
