{ pkgs, ... }:

{
  services.flatpak.enable = true;

  services.gvfs.enable = true;
  services.udisks2.enable = true;
  services.gnome.gnome-keyring.enable = true;
  security.pam.services.login.enableGnomeKeyring = true;

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

  # Greeter / Display Manager (SDDM)
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
}
