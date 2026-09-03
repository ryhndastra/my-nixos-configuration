{ pkgs, ... }:

{
  home.packages = with pkgs; [
    adwaita-fonts
    blueman
    brightnessctl
    networkmanagerapplet
    noto-fonts-color-emoji
    polkit_gnome
    wpsoffice
    obsidian
    postman
    wl-mirror
    wlr-randr
    wdisplays
    (pkgs.remmina.override {
      freerdp = pkgs.freerdp;
    })
  ];
}
