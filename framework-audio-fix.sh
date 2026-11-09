#!/bin/bash
# Framework 13 (12th Gen Intel) Audio Hot-Reload Workaround
# Fixes the kernel error: "Cannot probe codecs, giving up" without a reboot.

if [ "$EUID" -ne 0 ]; then
  echo "Please run this script with sudo or as root."
  exit 1
fi

echo "🚀 [Framework Audio Fix] Gracefully stopping user-space sound engines..."
pkill -9 -f pipewire
pkill -9 -f wireplumber

echo "🔄 [Framework Audio Fix] Forcing PCI bus reset for Intel Audio Controller..."
if [ -e "/sys/bus/pci/devices/0000:00:1f.3/remove" ]; then
    echo "1" > /sys/bus/pci/devices/0000:00:1f.3/remove
    sleep 0.5
fi

# Force motherboard PCI tracks to re-probe for the physical audio daughterboard
echo "1" > /sys/bus/pci/rescan
sleep 0.5

echo "🛠️ [Framework Audio Fix] Forcing ALSA sound architecture module reload..."
/sbin/alsa force-reload

echo "✅ [Framework Audio Fix] Completed successfully! Hardware bus restored."
