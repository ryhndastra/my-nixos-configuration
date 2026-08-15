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
    (pkgs.wrapOBS {
      plugins = with pkgs.obs-studio-plugins; [
        obs-pipewire-audio-capture  # capture audio dari app spesifik
        obs-gstreamer               # screen capture Wayland via PipeWire
        wlrobs                      # Wayland screen capture (wlroots)
      ];
    })
  ];
}
