<div align="center">

# ❄️ Sho's NixOS Dotfiles & Flakes ❄️

<p align="center">
  <i>A modular, declarative, and reproducible Wayland desktop powered by NixOS, Flakes, Home-Manager, Niri, and Noctalia.</i>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/NixOS-Unstable-5277C3?style=for-the-badge&logo=nixos&logoColor=white" alt="NixOS" />
  <img src="https://img.shields.io/badge/Compositor-Niri-9B59B6?style=for-the-badge&logo=wayland&logoColor=white" alt="Niri" />
  <img src="https://img.shields.io/badge/Shell-Noctalia-FF6B6B?style=for-the-badge&logo=gnome&logoColor=white" alt="Noctalia" />
  <img src="https://img.shields.io/badge/Terminal-Kitty-1E1E2E?style=for-the-badge&logo=kitty&logoColor=white" alt="Kitty" />
  <img src="https://img.shields.io/badge/Prompt-Starship-F4D03F?style=for-the-badge&logo=starship&logoColor=black" alt="Starship" />
  <img src="https://img.shields.io/badge/GPU-Intel%20%2B%20NVIDIA%20PRIME-76B900?style=for-the-badge&logo=nvidia&logoColor=white" alt="NVIDIA" />
  <img src="https://img.shields.io/badge/Flakes-Enabled-blue?style=for-the-badge&logo=nixos&logoColor=white" alt="Flakes" />
</p>

</div>

---

## 💻 Hardware Specifications

| Component | Specification |
| :--- | :--- |
| **Model** | MSI Thin 15 B12UC |
| **CPU** | Intel® Core™ i5-12450H (12 Cores, up to 4.40 GHz) |
| **iGPU** | Intel® UHD Graphics |
| **dGPU** | NVIDIA GeForce RTX 3050 Mobile (PRIME Offload + Dynamic Power Management) |
| **RAM** | 16 GB DDR4 |
| **Storage** | NVMe SSD (NixOS Root) + 1 TB Secondary Data Drive (`/mnt/data`) |

---

## ✨ Key Features & Highlights

- 🌌 **Smooth Wayland Compositor (Niri):** Infinite horizontal scrolling tiling window manager with dynamic workspaces and touchpad gesture navigation.
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
│   │   ├── boot.nix           # Systemd-boot & latest Linux Kernel
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

## 🚀 Installation & Disaster Recovery

### Option 1: Restore to a Fresh NixOS Installation

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
5. **Log out** and select the **Niri** session in SDDM. Enjoy your complete desktop environment! 🎉

---

## ⌨️ Essential Keybindings (Niri)

| Shortcut | Action |
| :--- | :--- |
| **`Super + Return`** | Launch Kitty Terminal |
| **`Super + B`** | Launch Zen Browser |
| **`Super + E`** | Launch Nautilus File Manager |
| **`Super + Space`** | Application Launcher |
| **`Super + P`** | **Toggle HDMI InFocus / External Monitor Mirror** |
| **`Super + Q`** | Close Active Window |
| **`Super + F`** | Toggle Fullscreen |
| **`Super + Left / Right`** | Focus Left / Right Column |
| **`Super + 1..9`** | Switch to Workspace 1–9 |
| **`Super + Shift + 1..9`** | Move Active Window to Workspace 1–9 |
| **`Super + Shift + E`** | Power Menu / Quit Session |

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
