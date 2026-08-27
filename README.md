<div align="center">

# ❄️ Sho's NixOS Dotfiles & Flakes ❄️

<p align="center">
  <i>A modular, declarative, and reproducible Wayland desktop powered by NixOS, Flakes, Home-Manager, Niri, and Noctalia.</i>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/NixOS-26.11%20Zokor-5277C3?style=for-the-badge&logo=nixos&logoColor=white" alt="NixOS" />
  <img src="https://img.shields.io/badge/Kernel-Linux%207.1.8-blue?style=for-the-badge&logo=linux&logoColor=white" alt="Kernel" />
  <img src="https://img.shields.io/badge/Compositor-Niri%2026.04-9B59B6?style=for-the-badge&logo=wayland&logoColor=white" alt="Niri" />
  <img src="https://img.shields.io/badge/Shell-Noctalia-FF6B6B?style=for-the-badge&logo=gnome&logoColor=white" alt="Noctalia" />
  <img src="https://img.shields.io/badge/Terminal-Kitty%200.48.2-1E1E2E?style=for-the-badge&logo=kitty&logoColor=white" alt="Kitty" />
  <img src="https://img.shields.io/badge/GPU-Intel%20%2B%20RTX%203050-76B900?style=for-the-badge&logo=nvidia&logoColor=white" alt="NVIDIA" />
  <img src="https://img.shields.io/badge/RAM-24%20GB%20DDR4-orange?style=for-the-badge" alt="RAM" />
</p>

</div>

---

## 💻 Hardware Specifications

| Component | Specification |
| :--- | :--- |
| **Model** | MSI Thin 15 B12UC (REV: 1.0) |
| **CPU** | 12th Gen Intel® Core™ i5-12450H (8 Cores / 12 Threads @ up to 4.40 GHz) |
| **iGPU** | Intel® UHD Graphics @ 1.20 GHz [Integrated] |
| **dGPU** | NVIDIA GeForce RTX 3050 Mobile [Discrete] (PRIME Offload Mode) |
| **RAM** | 24 GB DDR4 (23.18 GiB Usable) |
| **Primary Storage** | 512 GB NVMe SSD (`/dev/nvme0n1p2` - Btrfs Root OS) |
| **Secondary Storage**| 1 TB Secondary Drive (`/dev/sda4` - 800 GB Ext4 mounted at `/mnt/data`) |

---

## ✨ Key Features & Highlights

- 🌌 **Infinite Scrollable Tiling (Niri):** Dynamic multi-column layout with fluid gestures and workspace management.
- 🎨 **Unified Aesthetic (Noctalia Shell):** High-opacity top bar, custom widgets, system controls, and bundled custom-patched **W-Engine** plugin.
- 🎵 **Themed Spotify (Spicetify):** Fully declarative Catppuccin theme integration with custom animations and plugins.
- 🛠️ **Isolated Per-Project Dev Environment (`dev-init`):** Declarative helper script to instantiate zero-pollution environments for **Node.js, PHP, Go, Python, and Rust** via `direnv` + `nix-shell`.
- 📽️ **Presentation Mode (`Super + P`):** Seamless one-key display mirroring script for external monitors & HDMI InFocus projectors.
- 🎮 **Full Gaming Suite:** Steam with Gamescope session, GameMode, MangoHud, **ProtonUp-Qt**, and **Protontricks**.
- 🛡️ **Zero-Hang Storage Automount:** Partition `/mnt/data` with systemd timeout automount preventing shutdown hangs.
- ⚡ **Lightning Fast Rebuilds (`nh`):** Clean CLI visualizer powered by `nh os switch`.

---

## 📁 Repository Structure

```text
/etc/nixos/
├── flake.nix                  # Flake dependencies & system output declarations
├── flake.lock                 # Immutable locked dependency graph
├── configuration.nix          # Minimal system entrypoint
├── home.nix                   # Minimal user-level entrypoint (Home Manager)
├── hardware-configuration.nix # Auto-generated hardware scan
│
├── modules/
│   ├── system/                # System-level configurations (Root / NixOS)
│   │   ├── boot.nix           # GRUB UEFI Bootloader & latest Linux Kernel
│   │   ├── hardware.nix       # Intel + NVIDIA PRIME Offload drivers & OpenGL
│   │   ├── networking.nix     # NetworkManager, firewall & DNS
│   │   ├── packages.nix       # Core CLI utilities, fonts & desktop tools
│   │   ├── services.nix       # SDDM Greeter, PipeWire audio, Tailscale & storage
│   │   └── users.nix          # User account, Niri session & shell declarations
│   │
│   └── home/                  # User-level configurations (Home Manager)
│       ├── shell.nix          # Zsh, Starship, Kitty & CLI packages
│       ├── dev.nix            # Development toolchains, Git, IDEs & dev-init
│       ├── spicetify.nix      # Spicetify-Nix Catppuccin Spotify configuration
│       └── gui/               # Categorized desktop application modules
│           ├── browser.nix    # Zen Browser, Chromium & web tools
│           ├── gaming.nix     # Steam, GameMode, Proton utilities
│           ├── media.nix      # OBS Studio (with plugins), VLC, MPV
│           ├── social.nix     # Discord / Vesktop, Telegram
│           └── tools.nix      # Obsidian, WPS Office, Remmina (FreeRDP)
│
└── dotfiles/                  # Raw config files & assets
    ├── niri/                  # Niri compositor config (config.kdl)
    ├── noctalia/              # Noctalia config & patched plugins
    ├── kitty/                 # Kitty terminal config & themes
    ├── starship/              # Starship prompt configuration
    ├── fastfetch/             # Fastfetch config & custom ASCII art
    ├── zsh/                   # Portable standalone .zshrc
    └── scripts/               # Helper scripts (dev-init, mirror-display)
```

---

## ⌨️ Niri Keybindings & Hotkeys

### 🚀 App Shortcuts
| Shortcut | Action |
| :--- | :--- |
| **`Super + T`** | Open Terminal (`kitty`) |
| **`Super + W`** | Launch Browser (`zen-beta`) |
| **`Super + E`** | Open File Manager (`nautilus`) |
| **`Super + C`** | Launch Editor (`code`) |
| **`Super + M`** | Open Music (`spotify`) |
| **`Super + Space`** | Open Application Launcher (`noctalia`) |
| **`Super + S`** / **`Super + ,`** | Open Control Center / Settings (`noctalia`) |

### 🪟 Window & Layout Management
| Shortcut | Action |
| :--- | :--- |
| **`Super + Q`** | Close Focused Window |
| **`Super + F`** | Maximize Column |
| **`Super + R`** | Switch Preset Column Widths |
| **`Super + V`** | Move Window Between Floating & Tiling |
| **`Super + Shift + V`** | Switch Focus Between Floating & Tiling |
| **`Super + [`** / **`Super + ]`** | Consume / Expel Window Left / Right |

### 🧭 Navigation & Workspaces
| Shortcut | Action |
| :--- | :--- |
| **`Super + Left`** / **`Right`** | Focus Column Left / Right |
| **`Super + Ctrl + Left`** / **`Right`** | Move Column Left / Right |
| **`Super + Page Up`** / **`Down`** | Switch Workspace Up / Down |
| **`Super + Ctrl + Page Up`** / **`Down`** | Move Column to Workspace Up / Down |
| **`Super + D`** | Open Window Overview |

### 🛠️ System & Tools
| Shortcut | Action |
| :--- | :--- |
| **`Super + P`** | **Mirror Display (InFocus / Proyektor)** |
| **`PrtSc`** | Take a Screenshot |
| **`Super + Alt + L`** | Lock Screen (`swaylock`) |
| **`Super + Shift + /`** | Show Important Hotkeys Help |
| **`Super + Shift + E`** | Exit Niri Session |

---

## 🚀 Installation & Disaster Recovery

### Restore to a Fresh NixOS Installation

1. **Install NixOS** using the standard graphical installer (GNOME or Plasma).
2. Open terminal and clone this repository to `/etc/nixos`:
   ```bash
   sudo rm -rf /etc/nixos
   sudo git clone https://github.com/ryhndastra/my-nixos-configuration.git /etc/nixos
   sudo chown -R $USER:users /etc/nixos
   ```
3. *(If installing on a different machine)* regenerate hardware config:
   ```bash
   nixos-generate-config --show-hardware-config > /etc/nixos/hardware-configuration.nix
   ```
4. **Rebuild and Activate the System:**
   ```bash
   nh os switch /etc/nixos/
   
   # Or using standard nixos-rebuild:
   sudo nixos-rebuild switch --flake /etc/nixos#nixos
   ```
5. **Clean Bootloader Migration (Fix UEFI Boot Priority):**
   *(Crucial step: prevent motherboard BIOS from booting installer's old systemd-boot fallback)*
   ```bash
   # Hapus sisa konfigurasi systemd-boot bawaan installer
   sudo rm -rf /boot/loader /boot/EFI/systemd

   # Timpa file fallback BOOTX64.EFI dengan GRUB
   sudo cp -f /boot/EFI/NixOS-boot/grubx64.efi /boot/EFI/BOOT/BOOTX64.EFI

   # Set GRUB (NixOS-boot) sebagai prioritas boot #1
   sudo efibootmgr -o 0002,0001,0003,0004,0005
   ```
6. **Restart Laptop:**
   ```bash
   reboot
   ```
7. **Post-Install Setup:**
   * **Antigravity / App Credentials:** Login sekali di browser setelah masuk ke desktop. Sesi login otomatis tersimpan permanen di GNOME Keyring (di-unlock otomatis oleh PAM SDDM).
   * **Noctalia Patched Plugins:** Daftarkan direktori plugin lokal ke Noctalia:
     ```bash
     noctalia msg plugins source add local path ~/.local/share/noctalia-plugins
     noctalia msg plugins enable sho/w-engine-patched
     ```
   * **Storage (`/mnt/data`):** Partisi sekunder menggunakan systemd automount (lazy mount). Partisi akan otomatis ter-mount begitu folder `/mnt/data` diakses.

---

## 🧹 Maintenance & Utilities

```bash
# Update flake inputs to the latest versions
nix flake update /etc/nixos/

# Switch system configuration with automatic update
nh os switch --update /etc/nixos/

# Perform garbage collection & clean older generations
nh clean all
```

---

<div align="center">
  <p><b>Crafted with precision & passion by <a href="https://github.com/ryhndastra">Sho (@ryhndastra)</a></b></p>
  <p><i>Powered by NixOS ❄️</i></p>
</div>
