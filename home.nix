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
    inputs.noctalia.homeModules.default
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
    size = 16;
    gtk.enable = true;
    x11.enable = true;
  };

  gtk = {
    enable = true;
    cursorTheme = {
      package = aospCursors;
      name = "aosp-cursors";
      size = 16;
    };
  };

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      cursor-theme = "aosp-cursors";
      cursor-size = 16;
    };
  };

  xresources.properties = {
    "Xcursor.size" = 16;
    "Xcursor.theme" = "aosp-cursors";
  };

  # Niri Compositor
  programs.niri = {
    config = builtins.readFile ./dotfiles/niri/config.kdl;
  };

  # Noctalia Shell
  programs.noctalia = {
    enable = true;
    settings = {
      ui = {
        panelBackgroundOpacity = 1.0;
      };
      bar = {
        position = "top";
      };
      colorSchemes.predefinedScheme = "Noctalia (default)";
    };
  };

  xdg.configFile."noctalia/config.toml" = {
    source = lib.mkForce ./dotfiles/noctalia/config.toml;
    force = true;
  };

  xdg.configFile."noctalia/settings.json" = {
    text = builtins.toJSON {
      settingsVersion = 59;
      bar = {
        backgroundOpacity = 1.0;
        capsuleOpacity = 1.0;
        useSeparateOpacity = false;
      };
      ui = {
        panelBackgroundOpacity = 1.0;
        translucentWidgets = false;
      };
    };
    force = true;
  };

  home.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    XCURSOR_THEME = "aosp-cursors";
    XCURSOR_SIZE = "16";
    HYPRCURSOR_THEME = "aosp-cursors";
    HYPRCURSOR_SIZE = "16";
    NH_FLAKE = "/etc/nixos";
  };
}
