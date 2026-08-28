{ pkgs, ... }:

{
  services.flatpak.enable = true;

  services.gvfs.enable = true;
  services.udisks2.enable = true;
  services.gnome.gnome-keyring.enable = true;
  security.pam.services.login.enableGnomeKeyring = true;
  security.pam.services.sddm.enableGnomeKeyring = true;

  services.printing.enable = false;

  # Enable MariaDB (MySQL) for local development
  services.mysql = {
    enable = true;
    package = pkgs.mariadb;
  };

  # Enable sound.
  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  virtualisation.docker.enable = false;
  
  programs.gamemode.enable = true;
  programs.steam = {
    enable = true;
    gamescopeSession.enable = true;
  };

  # Window Manager: Hyprland (Wayland)
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  # Hyprlock PAM service for secure screen locking
  security.pam.services.hyprlock = {};

  # XDG Portals for Hyprland screen sharing & file picker
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-hyprland
      xdg-desktop-portal-gtk
    ];
  };

  # Default session for Display Manager
  services.displayManager.defaultSession = "hyprland";

  # Greeter / Display Manager (SDDM Astronaut)
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
    theme = "sddm-astronaut-theme";
    extraPackages = with pkgs; [
      kdePackages.qtsvg
      kdePackages.qtmultimedia
      kdePackages.qtvirtualkeyboard
    ];
  };

  services.power-profiles-daemon.enable = true;
  services.upower.enable = true;

  services.tailscale.enable = true;

  # /mnt/data (ext4 data partition)
  # x-systemd.automount   : mount saat pertama diakses (lazy mount)
  # x-systemd.idle-timeout: otomatis unmount setelah 5 menit idle
  # nofail                 : boot tetap lanjut walau disk gagal mount
  fileSystems."/mnt/data" = {
    device = "/dev/disk/by-uuid/9ea5a392-65e2-4559-84a5-d46acaa09a50";
    fsType = "ext4";
    options = [
      "nofail"
      "x-systemd.automount"
      "x-systemd.idle-timeout=300"
    ];
  };
}
