<div align="center">
  <h1>❄️ Sho's NixOS Configuration ❄️</h1>
  <p><i>My personal, reproducible, and declarative NixOS setup.</i></p>
</div>

---

## 🚀 Overview

This repository contains my personal NixOS configuration, powered by **Flakes** and **Home Manager**. This setup is highly modular, splitting configurations into logical components for easier maintenance, debugging, and readability.

## 🎨 Tech Stack & Theming

- **OS:** NixOS (Unstable/Flakes)
- **Window Manager:** Niri (Wayland Compositor)
- **Desktop Theme:** [Noctalia](https://github.com/noctalia-dev/noctalia) 
- **Display Manager:** SDDM (Astronaut Theme - Pixel Sakura)
- **Terminal:** Kitty
- **Shell:** Zsh + Oh-My-Zsh + Zsh Autocomplete
- **Prompt:** Starship (Customized for Noctalia)
- **Music:** Spotify (Themed via Spicetify-Nix with SpicetifyCat & CatJam)
- **Editor:** Neovim

## 📁 Directory Structure

This configuration embraces a modular **Bundler Architecture**. Instead of giant mono-files, the setup is split into highly focused modules:

- `configuration.nix` : Minimal system entrypoint.
- `home.nix` : Minimal user-level entrypoint.
- `flake.nix` : The flake defining dependencies (Spicetify, Niri, Noctalia, Zen Browser, etc.).
- `modules/system/` : **System Modules** (Root level configs)
  - `boot.nix`, `hardware.nix`, `networking.nix`, `packages.nix`, `services.nix`, `users.nix`
- `modules/home/` : **User Modules** (Home Manager configs)
  - `shell.nix`, `dev.nix`, `spicetify.nix`
  - `gui/` : Desktop applications (`browser.nix`, `gaming.nix`, `media.nix`, `social.nix`, `tools.nix`)
- `dotfiles/` : Raw configurations for specific apps (Kitty, Starship, Fastfetch, Niri, etc.).

## 🛠️ Installation / Restoration

To restore this configuration on a fresh NixOS installation:

1. Clone this repository into `/etc/nixos/`:
   ```bash
   sudo rm -rf /etc/nixos/*
   sudo git clone https://github.com/ryhndastra/my-nixos-configuration.git /etc/nixos/
   ```
2. Rebuild the system using `nh` (Nix Helper) or the standard `nixos-rebuild`:
   ```bash
   nh os switch /etc/nixos/
   
   # Or, if 'nh' is not installed yet (e.g. on a fresh install):
   sudo nixos-rebuild switch --flake /etc/nixos#nixos
   ```
3. Enjoy the setup! 🚀

---
<p align="center"><i>Built with ❤️ using NixOS</i></p>
