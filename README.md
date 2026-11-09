# Framework 13 (12th Gen Intel) Audio Fix for Ubuntu/Linux

An automated, non-destructive workaround for the persistent **"Cannot probe codecs, giving up"** hardware initialization error on the **Framework Laptop 13 (12th Gen Intel Core)** running Ubuntu and other modern Linux distributions.

---

## The Problem
On the 12th Gen Intel (Alder Lake) Framework 13 architecture, the audio daughterboard connects via a small ribbon cable. Due to slight structural case flexing or power-state transitions during system wake/sleep cycles, the Linux kernel frequently loses communication with the audio codec chip. 

When this happens:
* The kernel throws: `snd_hda_intel 0000:00:1f.3: Cannot probe codecs, giving up`
* All input and output devices vanish entirely (`aplay -l` returns no soundcards found)
* Standard software service restarts (`pipewire`, `pulseaudio`) fail because the kernel has disabled the device at the hardware layer.

## The Solution
This repository provides a hardware hot-reload workaround that detaches the glitched PCI sound controller, forces a live motherboard bus re-scan to re-detect the audio daughterboard, reloads the ALSA modules without a reboot, and hooks the sequence to automated system-sleep events.

---

## Installation & Setup

### 1. Configure Kernel Audio Mapping Override
Force the Linux Sound Open Firmware (SOF) driver to accept the explicit 12th Gen physical hardware profile:

```bash
echo "options snd-intel-dspcfg dsp_driver=3" | sudo tee /etc/modprobe.d/framework-audio.conf
echo "options snd-hda-intel model=framework-laptop_12th" | sudo tee -a /etc/modprobe.d/framework-audio.conf
```

Update your initial RAM filesystem so Ubuntu applies these parameters at startup:
```bash
sudo update-initramfs -u -k all
```

### 2. Install the Core Hot-Reload Script
Download `framework-audio-fix.sh` from this repository to your local system binaries folder:

```bash
sudo cp framework-audio-fix.sh /usr/local/bin/framework-audio-fix.sh
sudo chmod +x /usr/local/bin/framework-audio-fix.sh
```

### 3. Automate Fix on Laptop Wakeup (System Suspend Hook)
Move the resume handler script into your system power management hooks to ensure your speakers and audio jack are ready every time you open the laptop lid:

```bash
sudo cp framework-audio-resume /lib/systemd/system-sleep/framework-audio-resume
sudo chmod +x /lib/systemd/system-sleep/framework-audio-resume
```

---

## Optional: Manual Shortcut Alias
If your audio ever drops mid-session due to case movement or flexing, you can create a simple one-word terminal shortcut to run the hot-probe instantly.

Add the following to your `~/.bashrc` or `~/.zshrc`:
```bash
alias fixaudio="sudo /usr/local/bin/framework-audio-fix.sh"
```
Apply changes: `source ~/.bashrc`. Now, typing `fixaudio` instantly restores your sound in under two seconds!

## Note on Hardware Grounds
If the software hot-reload still fails to detect devices, your physical internal ribbon cable is loose or the audio daughterboard grounding screw has backed out. Follow the **[Official Framework Audio Daughterboard Guide](https://frame.work)** to open the input cover and firmly re-seat the physical connector.
