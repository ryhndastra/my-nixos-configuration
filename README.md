<div align="center">
  <h1>❄️ Sho's NixOS Configuration ❄️</h1>
  <p><i>My personal, reproducible, and declarative NixOS setup.</i></p>
</div>

---

## 🚀 Overview

This repository contains my personal NixOS configuration, powered by **Flakes** and **Home Manager**. By leveraging the declarative nature of NixOS, this setup ensures that my entire operating system—from packages and window manager configs to terminal themes—can be reliably reproduced on any machine.

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

- `configuration.nix` : System-level configuration, hardware drivers, and system packages.
- `home.nix` : User-level configuration (Home Manager), user packages, and dotfile linking.
- `flake.nix` : The entry point defining the system architecture and external dependencies (like Spicetify-Nix).
- `dotfiles/` : Application-specific configurations (Kitty, Starship, Fastfetch, Niri, etc.) modularized for easy management.

## 🛠️ Installation / Restoration

To restore this configuration on a fresh NixOS installation:

1. Clone this repository into `/etc/nixos/`:
   ```bash
   sudo rm -rf /etc/nixos/*
   sudo git clone https://github.com/ryhndastra/my-nixos-configuration.git /etc/nixos/
   ```
2. Rebuild the system:
   ```bash
   sudo nixos-rebuild switch --flake /etc/nixos#nixos
   ```
3. Enjoy the setup! 🚀

---
<p align="center"><i>Built with ❤️ using NixOS</i></p>
