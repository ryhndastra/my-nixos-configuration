{ pkgs, ... }:

{
  home.packages = with pkgs; [
    gamescope
    mangohud
    protonup-qt
    # Note: Roblox is installed via Flatpak (Sober).
    # To install: flatpak install flathub org.vinegarhq.Sober
  ];
}
