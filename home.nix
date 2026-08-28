{
  pkgs,
  inputs,
  lib,
  ...
}:

let
  aospCursors = pkgs.stdenvNoCC.mkDerivation {
    pname = "aosp-cursors";
    version = "1.3.1";

    src = pkgs.fetchurl {
      url = "https://github.com/Tech-Tac/aosp-cursors/releases/download/1.3.1/aosp-cursors-linux-1.3.1.tar.xz";
      hash = "sha256-0nHSviCm16wTdH5NkiSijdv34sH6sugFzfA73gWgo64=";
    };

    unpackPhase = ''
      tar -xJf "$src"
    '';

    installPhase = ''
      mkdir -p "$out/share/icons"
      cp -r aosp-cursors "$out/share/icons/"
    '';
  };
in
{
  imports = [
    ./modules/home
    inputs.spicetify-nix.homeManagerModules.default
  ];

  home.username = "sho";
  home.homeDirectory = "/home/sho";
  home.stateVersion = "25.05";

  programs.home-manager.enable = true;

  home.pointerCursor = {
    enable = true;
    package = aospCursors;
    name = "aosp-cursors";
    size = 24;
    gtk.enable = true;
    x11.enable = true;
  };

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      cursor-theme = "aosp-cursors";
      cursor-size = 24;
    };
  };

  xresources.properties = {
    "Xcursor.size" = 24;
    "Xcursor.theme" = "aosp-cursors";
  };

  # Link Illogical-Impulse & end4-pC Dotfiles
  xdg.configFile."hypr" = {
    source = ./dotfiles/hypr;
    recursive = true;
    force = true;
  };

  xdg.configFile."quickshell" = {
    source = ./dotfiles/quickshell;
    recursive = true;
    force = true;
  };

  xdg.configFile."matugen" = {
    source = ./dotfiles/matugen;
    recursive = true;
    force = true;
  };

  xdg.configFile."fuzzel" = {
    source = ./dotfiles/fuzzel;
    recursive = true;
    force = true;
  };

  xdg.configFile."wlogout" = {
    source = ./dotfiles/wlogout;
    recursive = true;
    force = true;
  };

  home.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    MOZ_ENABLE_WAYLAND = "1";
    XDG_CURRENT_DESKTOP = "Hyprland";
    XDG_SESSION_TYPE = "wayland";
    XDG_SESSION_DESKTOP = "Hyprland";
    QT_QPA_PLATFORM = "wayland;xcb";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
    GDK_BACKEND = "wayland,x11,*";
    CLUTTER_BACKEND = "wayland";
    XCURSOR_THEME = "aosp-cursors";
    XCURSOR_SIZE = "24";
    HYPRCURSOR_THEME = "aosp-cursors";
    HYPRCURSOR_SIZE = "24";
    NH_FLAKE = "/etc/nixos";
  };
}
