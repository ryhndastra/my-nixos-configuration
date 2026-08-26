{ pkgs, ... }:

{
  home.packages = with pkgs; [
    gamescope
    mangohud
    protontricks
    protonup-qt
    # Note: Roblox is installed via Flatpak (Sober).
    # To install: flatpak install flathub org.vinegarhq.Sober
  ];
}
