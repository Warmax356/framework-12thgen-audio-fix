# Framework 13 (12th Gen Intel) Audio Hot-Reload Workaround

[![SWH](https://archive.softwareheritage.org/badge/origin/https://github.com/Warmax356/framework-12thgen-audio-fix/)](https://archive.softwareheritage.org/browse/origin/?origin_url=https://github.com/Warmax356/framework-12thgen-audio-fix)
[![Bash](https://img.shields.io/badge/Language-Bash-4EAA25?style=flat&logo=gnu-bash&logoColor=white)](https://www.gnu.org/software/bash/)
[![License](https://img.shields.io/github/license/Warmax356/framework-12thgen-audio-fix)](LICENSE)

An automated and manual workaround designed to resolve audio dropouts on the **Framework Laptop 13 (12th Gen Intel Core)** running Linux without requiring a system reboot by re-probing hardware and reloading drivers.

---

## 🔍 Intended Purpose & The Problem

Addresses Linux kernel audio codec drops on 12th Gen Intel Framework 13 architectures caused by sleep/wake cycles or physical case flexing.

---

## 🚀 Installation Options

### Option 1: Automated Installation (Recommended)

Run the automated setup script directly via `curl`:

```bash
curl -sSL https://raw.githubusercontent.com/Warmax356/framework-12thgen-audio-fix/refs/heads/main/install.sh | sudo bash
```

### Option 2: Manual Installation

1. Configure kernel driver modprobe overrides in `/etc/modprobe.d/framework-audio.conf`.
2. Place and make executable `framework-audio-fix.sh` in `/usr/local/bin/`:
   ```bash
   sudo curl -sSL https://raw.githubusercontent.com/Warmax356/framework-12thgen-audio-fix/refs/heads/main/framework-audio-fix.sh -o /usr/local/bin/framework-audio-fix.sh
   sudo chmod +x /usr/local/bin/framework-audio-fix.sh
   ```
3. Deploy `framework-audio-resume.sh` to `/lib/systemd/system-sleep/`:
   ```bash
   sudo curl -sSL https://raw.githubusercontent.com/Warmax356/framework-12thgen-audio-fix/refs/heads/main/framework-audio-resume.sh -o /lib/systemd/system-sleep/framework-audio-resume.sh
   sudo chmod +x /lib/systemd/system-sleep/framework-audio-resume.sh
   ```
4. Add the terminal alias to your shell profile (`~/.bashrc` or `~/.zshrc`):
   ```bash
   alias fixaudio="sudo /usr/local/bin/framework-audio-fix.sh"
   ```

---

## ⌨️ Usage

- **Automatic Mode:** Executes seamlessly via systemd sleep hooks upon system wake.
- **Manual Override:** Execute the alias in your terminal whenever audio drops occur:
  ```bash
  fixaudio
  ```

---

## 🤝 Contributing, Issues, & Contact

To help improve the project or report issues:
- **GitHub Issues:** Open an issue or submit a pull request on the **[GitHub Issues Page](https://github.com/Warmax356/framework-12thgen-audio-fix/issues)**.
- **Community Portal:** Reach out through **[Open Source Society Malta (OSSMalta)](https://ossmalta.eu)**.
