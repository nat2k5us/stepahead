# Documentation

Complete documentation for the Speech Therapy iOS app.

## 📚 Quick Links

### Getting Started
- **[CLAUDE.md](./CLAUDE.md)** - Project overview and architecture guide for Claude Code
- **[README_IOS.md](./README_IOS.md)** - iOS-specific setup instructions

### Deployment Guides
- **[DEPLOYMENT_SETUP.md](./DEPLOYMENT_SETUP.md)** - First-time App Store setup guide
- **[DEPLOYMENT_SCRIPTS.md](./DEPLOYMENT_SCRIPTS.md)** - How to use deployment scripts
- **[IOS_DEPLOYMENT_GUIDE.md](./IOS_DEPLOYMENT_GUIDE.md)** - Comprehensive iOS deployment guide
- **[IOS_SETUP_SUMMARY.md](./IOS_SETUP_SUMMARY.md)** - Quick setup summary
- **[VERSIONING_GUIDE.md](./VERSIONING_GUIDE.md)** - Automatic versioning system

### Configuration
- **[FIREBASE_SETUP.md](./FIREBASE_SETUP.md)** - Firebase configuration guide

### Development
- **[less-tokens.md](./less-tokens.md)** - Token optimization for Claude Code

## 🚀 Common Tasks

### First-Time Setup
1. Read [IOS_SETUP_SUMMARY.md](./IOS_SETUP_SUMMARY.md)
2. Follow [DEPLOYMENT_SETUP.md](./DEPLOYMENT_SETUP.md)
3. Configure Firebase: [FIREBASE_SETUP.md](./FIREBASE_SETUP.md)

### Publishing to TestFlight
See [DEPLOYMENT_SCRIPTS.md](./DEPLOYMENT_SCRIPTS.md#2-publish-testflightsh---testflight-beta-testing)

### Publishing to App Store
See [DEPLOYMENT_SCRIPTS.md](./DEPLOYMENT_SCRIPTS.md#3-publish-appstoresk---app-store-release)

### Version Management
See [VERSIONING_GUIDE.md](./VERSIONING_GUIDE.md)

## 📂 Project Structure

```
docs/
├── README.md                    # This file
├── CLAUDE.md                    # Project architecture
├── DEPLOYMENT_SCRIPTS.md        # Script usage guide
├── DEPLOYMENT_SETUP.md          # App Store setup
├── FIREBASE_SETUP.md            # Firebase config
├── IOS_DEPLOYMENT_GUIDE.md      # Complete iOS guide
├── IOS_SETUP_SUMMARY.md         # Quick setup
├── README_IOS.md                # iOS README
├── VERSIONING_GUIDE.md          # Version management
└── less-tokens.md               # Development tips
```

## 🔍 Find What You Need

### "How do I...?"

| Task | Document |
|------|----------|
| Set up the project for the first time | [IOS_SETUP_SUMMARY.md](./IOS_SETUP_SUMMARY.md) |
| Create an App Store listing | [DEPLOYMENT_SETUP.md](./DEPLOYMENT_SETUP.md) |
| Publish to TestFlight | [DEPLOYMENT_SCRIPTS.md](./DEPLOYMENT_SCRIPTS.md) |
| Change version numbers | [VERSIONING_GUIDE.md](./VERSIONING_GUIDE.md) |
| Configure Firebase | [FIREBASE_SETUP.md](./FIREBASE_SETUP.md) |
| Understand the codebase | [CLAUDE.md](./CLAUDE.md) |
| Deploy to App Store | [IOS_DEPLOYMENT_GUIDE.md](./IOS_DEPLOYMENT_GUIDE.md) |

## 💡 Tips

- All deployment scripts automatically increment build numbers
- Use `./verify-setup.sh` in the root directory to check configuration
- Documentation paths updated throughout the project

## 🆘 Need Help?

1. Check the relevant guide above
2. Run `./verify-setup.sh` to diagnose issues
3. Review commit history for recent changes
4. Check Apple Developer documentation
