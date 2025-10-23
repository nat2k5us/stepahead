#!/bin/bash

# Android CLI-Only Setup Script
# Sets up Android build tools without Android Studio

set -e

echo "🤖 Setting up Android CLI tools (no Android Studio required)..."
echo ""

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# Check if Homebrew is installed
if ! command -v brew &> /dev/null; then
    echo -e "${RED}❌ Homebrew is not installed${NC}"
    echo "Install from: https://brew.sh"
    exit 1
fi

echo -e "${GREEN}✓ Homebrew found${NC}"

# Install Java (OpenJDK 17)
echo ""
echo "📦 Installing OpenJDK 17..."
if command -v java &> /dev/null; then
    JAVA_VERSION=$(java -version 2>&1 | head -1 | cut -d'"' -f2 | cut -d'.' -f1)
    echo -e "${GREEN}✓ Java $JAVA_VERSION already installed${NC}"
else
    brew install openjdk@17
    echo -e "${GREEN}✓ Java 17 installed${NC}"
fi

# Install Android command-line tools
echo ""
echo "📦 Installing Android command-line tools..."
if [ -d "$HOME/Library/Android/sdk" ]; then
    echo -e "${GREEN}✓ Android SDK already exists${NC}"
else
    brew install --cask android-commandlinetools
    echo -e "${GREEN}✓ Android command-line tools installed${NC}"
fi

# Set up environment variables
echo ""
echo "🔧 Setting up environment variables..."

ANDROID_HOME="$HOME/Library/Android/sdk"
SHELL_RC=""

if [ -f "$HOME/.zshrc" ]; then
    SHELL_RC="$HOME/.zshrc"
elif [ -f "$HOME/.bash_profile" ]; then
    SHELL_RC="$HOME/.bash_profile"
else
    SHELL_RC="$HOME/.zshrc"
    touch "$SHELL_RC"
fi

# Check if variables already exist
if grep -q "ANDROID_HOME" "$SHELL_RC"; then
    echo -e "${GREEN}✓ ANDROID_HOME already configured${NC}"
else
    echo "" >> "$SHELL_RC"
    echo "# Android SDK" >> "$SHELL_RC"
    echo "export ANDROID_HOME=\$HOME/Library/Android/sdk" >> "$SHELL_RC"
    echo "export PATH=\$PATH:\$ANDROID_HOME/cmdline-tools/latest/bin" >> "$SHELL_RC"
    echo "export PATH=\$PATH:\$ANDROID_HOME/platform-tools" >> "$SHELL_RC"
    echo "export PATH=\$PATH:\$ANDROID_HOME/emulator" >> "$SHELL_RC"
    echo -e "${GREEN}✓ Added ANDROID_HOME to $SHELL_RC${NC}"
fi

# Source the shell config
export ANDROID_HOME="$HOME/Library/Android/sdk"
export PATH="$PATH:$ANDROID_HOME/cmdline-tools/latest/bin"
export PATH="$PATH:$ANDROID_HOME/platform-tools"
export PATH="$PATH:$ANDROID_HOME/emulator"

# Create SDK directories if they don't exist
mkdir -p "$ANDROID_HOME/cmdline-tools"

# Install SDK components
echo ""
echo "📦 Installing Android SDK components..."

# Accept licenses
yes | sdkmanager --licenses 2>/dev/null || true

# Install required SDK packages
echo "Installing platform-tools..."
sdkmanager --install "platform-tools"

echo "Installing Android 34 platform..."
sdkmanager --install "platforms;android-34"

echo "Installing build tools..."
sdkmanager --install "build-tools;34.0.0"

echo -e "${GREEN}✓ SDK components installed${NC}"

# Optional: Install emulator
echo ""
echo -ne "${YELLOW}Install Android Emulator? (y/N): ${NC}"
read -r install_emulator

if [ "$install_emulator" = "y" ] || [ "$install_emulator" = "Y" ]; then
    echo "Installing emulator..."
    sdkmanager --install "emulator"
    sdkmanager --install "system-images;android-34;google_apis;x86_64"
    echo -e "${GREEN}✓ Emulator installed${NC}"

    # Create AVD
    echo ""
    echo "Creating Android Virtual Device (AVD)..."
    echo "no" | avdmanager create avd -n "Pixel_6_API_34" -k "system-images;android-34;google_apis;x86_64" -d "pixel_6"
    echo -e "${GREEN}✓ AVD 'Pixel_6_API_34' created${NC}"
fi

# Verify installation
echo ""
echo "✅ Verifying installation..."
echo ""

if command -v java &> /dev/null; then
    JAVA_VERSION=$(java -version 2>&1 | head -1)
    echo -e "${GREEN}✓ Java: $JAVA_VERSION${NC}"
else
    echo -e "${RED}❌ Java not found${NC}"
fi

if command -v adb &> /dev/null; then
    ADB_VERSION=$(adb --version | head -1)
    echo -e "${GREEN}✓ ADB: $ADB_VERSION${NC}"
else
    echo -e "${RED}❌ ADB not found${NC}"
fi

if command -v sdkmanager &> /dev/null; then
    echo -e "${GREEN}✓ SDK Manager: Available${NC}"
else
    echo -e "${RED}❌ SDK Manager not found${NC}"
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo -e "${GREEN}✅ Android CLI setup complete!${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "📝 Next steps:"
echo "1. Restart your terminal or run: source $SHELL_RC"
echo "2. Verify: adb version"
echo "3. Build your app: ./what-do-you-want-2-do.sh 4"
echo ""
echo "💾 Disk space saved: ~12 GB (vs Android Studio)"
echo ""

# Show total size
if [ -d "$ANDROID_HOME" ]; then
    SDK_SIZE=$(du -sh "$ANDROID_HOME" | cut -f1)
    echo "📊 Android SDK size: $SDK_SIZE"
fi
