#!/bin/bash
# Installer script for Framework 13 12th Gen Audio Hot-Reload Workaround
# Repository: https://github.com/Warmax356/framework-12thgen-audio-fix

set -e

# Ensure the script is running as root
if [ "$EUID" -ne 0 ]; then
  echo "❌ Error: Please run this installer with sudo."
  exit 1
fi

echo "===================================================="
echo "🛠️  Installing Framework 12th Gen Audio Fix..."
echo "===================================================="

# 1. Configure Kernel Audio Mapping Overrides
echo "📝 Step 1: Setting up modprobe configuration flags..."
mkdir -p /etc/modprobe.d
cat << 'EOF' > /etc/modprobe.d/framework-audio.conf
options snd-intel-dspcfg dsp_driver=3
options snd-hda-intel model=framework-laptop_12th
EOF

# 2. Update initramfs to ensure settings register on boot
echo "📦 Step 2: Updating initial RAM filesystem (initramfs)..."
update-initramfs -u -k all

# 3. Pull and configure core fix script
echo "📥 Step 3: Downloading core hot-reload script..."
curl -sSL "https://raw.githubusercontent.com/Warmax356/framework-12thgen-audio-fix/refs/heads/main/framework-audio-fix.sh" -o /usr/local/bin/framework-audio-fix.sh
chmod +x /usr/local/bin/framework-audio-fix.sh

# 4. Pull and configure systemd sleep hook
echo "💤 Step 4: Downloading systemd suspend/resume hook..."
mkdir -p /lib/systemd/system-sleep
curl -sSL "https://raw.githubusercontent.com/Warmax356/framework-12thgen-audio-fix/refs/heads/main/framework-audio-resume.sh" -o /lib/systemd/system-sleep/framework-audio-resume
chmod +x /lib/systemd/system-sleep/framework-audio-resume

# 5. Inject a global terminal alias shortcut
echo "⌨️  Step 5: Appending 'fixaudio' alias globally to shell configs..."
USER_HOME=$(eval echo "~${SUDO_USER}")

if [ -f "$USER_HOME/.bashrc" ]; then
    if ! grep -q "alias fixaudio=" "$USER_HOME/.bashrc"; then
        echo 'alias fixaudio="sudo /usr/local/bin/framework-audio-fix.sh"' >> "$USER_HOME/.bashrc"
        chown ${SUDO_USER}:${SUDO_USER} "$USER_HOME/.bashrc"
    fi
fi

if [ -f "$USER_HOME/.zshrc" ]; then
    if ! grep -q "alias fixaudio=" "$USER_HOME/.zshrc"; then
        echo 'alias fixaudio="sudo /usr/local/bin/framework-audio-fix.sh"' >> "$USER_HOME/.zshrc"
        chown ${SUDO_USER}:${SUDO_USER} "$USER_HOME/.zshrc"
    fi
fi

echo "===================================================="
echo "✅ Installation Complete! Your audio fix is active."
echo "===================================================="
echo "💡 Note: Open a new terminal tab or run 'source ~/.bashrc'"
echo "   to use the 'fixaudio' command manual bypass anytime."
echo "===================================================="
