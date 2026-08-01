{ pkgs, ... }:

{
  home.packages = with pkgs; [
    ffmpeg
    grim
    hyprpicker
    imv
    linux-wallpaperengine
    mpv
    pamixer
    pavucontrol
    playerctl
    slurp
    python3
    swappy
    wf-recorder
  ];
}
