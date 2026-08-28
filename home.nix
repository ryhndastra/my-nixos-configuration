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
  sakuraWallpaper = "${./dotfiles/wallpapers/pixel_sakura.png}";
in
{
  imports = [
    ./modules/home
    inputs.plasma-manager.homeModules.plasma-manager
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

  # Pure Standard KDE Plasma 6 Configuration
  programs.plasma = {
    enable = true;

    workspace = {
      clickItemTo = "select";
      lookAndFeel = "org.kde.breezedark.desktop";
      colorScheme = "CatppuccinMochaLavender";
      cursor = {
        theme = "aosp-cursors";
        size = 16;
      };
      iconTheme = "Papirus-Dark";
      wallpaper = sakuraWallpaper;
    };

    fonts = {
      general = {
        family = "Noto Sans CJK JP";
        pointSize = 10;
      };
      fixedWidth = {
        family = "JetBrainsMono Nerd Font";
        pointSize = 10;
      };
      small = {
        family = "Noto Sans CJK JP";
        pointSize = 8;
      };
      toolbar = {
        family = "Noto Sans CJK JP";
        pointSize = 10;
      };
      menu = {
        family = "Noto Sans CJK JP";
        pointSize = 10;
      };
      windowTitle = {
        family = "Noto Sans CJK JP";
        pointSize = 10;
      };
    };

    kscreenlocker = {
      appearance = {
        alwaysShowClock = true;
        showMediaControls = true;
        wallpaper = sakuraWallpaper;
      };
      lockOnResume = true;
      timeout = 10;
    };

    kwin = {
      effects = {
        blur.enable = true;
        translucency.enable = true;
        wobblyWindows.enable = false;
      };
      nightLight.enable = false;
      virtualDesktops = {
        number = 5;
        rows = 1;
      };
    };

    # Standard Native KDE Plasma 6 Floating Panel
    panels = [
      {
        location = "bottom";
        height = 44;
        floating = true;
        widgets = [
          {
            name = "org.kde.plasma.kickoff";
            config = {
              General = {
                icon = "nix-snowflake";
              };
            };
          }
          {
            name = "org.kde.plasma.pager";
          }
          {
            name = "org.kde.plasma.icontasks";
            config = {
              General = {
                launchers = [
                  "applications:kitty.desktop"
                  "applications:zen-beta.desktop"
                  "applications:org.gnome.Nautilus.desktop"
                  "applications:code.desktop"
                  "applications:spotify.desktop"
                ];
              };
            };
          }
          {
            name = "org.kde.plasma.systemtray";
          }
          {
            name = "org.kde.plasma.digitalclock";
          }
        ];
      }
    ];

    # Standard Clean Shortcuts
    shortcuts = {
      # Applications
      "services/kitty.desktop"."_launch" = "Meta+T";
      "services/zen-beta.desktop"."_launch" = "Meta+W";
      "services/org.gnome.Nautilus.desktop"."_launch" = "Meta+E";
      "services/code.desktop"."_launch" = "Meta+C";
      "services/spotify.desktop"."_launch" = "Meta+M";
      "services/org.kde.spectacle.desktop"."_launch" = "Print";

      # Launcher & Overview
      "org.kde.plasma.kickoff"."_launch" = "Meta";
      "services/org.kde.plasma.kickoff.desktop"."_launch" = "Meta";
      "krunner.desktop"."_launch" = "Meta+D";
      "org.kde.krunner.desktop"."_launch" = "Meta+D";

      # Window Controls
      "kwin"."Window Close" = "Meta+Q";
      "kwin"."Window Maximize" = "Meta+F";
      "kwin"."Window Fullscreen" = "Meta+Shift+F";
      "kwin"."Window Floating" = "Meta+V";
      "kwin"."Walk Through Windows" = "Alt+Tab";
      "kwin"."Overview" = "Meta+Tab";
      "kwin"."Show Desktop" = "Meta+Shift+D";

      # Quick Tiling (Native KWin Tile Snapping)
      "kwin"."Window Quick Tile Left" = "Meta+Left";
      "kwin"."Window Quick Tile Right" = "Meta+Right";
      "kwin"."Window Quick Tile Top" = "Meta+Up";
      "kwin"."Window Quick Tile Bottom" = "Meta+Down";

      # Workspaces Navigation & Window Moving
      "kwin"."Switch to Desktop 1" = "Meta+1";
      "kwin"."Switch to Desktop 2" = "Meta+2";
      "kwin"."Switch to Desktop 3" = "Meta+3";
      "kwin"."Switch to Desktop 4" = "Meta+4";
      "kwin"."Switch to Desktop 5" = "Meta+5";

      "kwin"."Window to Desktop 1" = "Meta+Shift+1\tMeta+!";
      "kwin"."Window to Desktop 2" = "Meta+Shift+2\tMeta+@";
      "kwin"."Window to Desktop 3" = "Meta+Shift+3\tMeta+#";
      "kwin"."Window to Desktop 4" = "Meta+Shift+4\tMeta+$";
      "kwin"."Window to Desktop 5" = "Meta+Shift+5\tMeta+%";

      # Lock screen
      "ksmserver"."Lock Session" = "Meta+Alt+L";
    };

    configFile = {
      # Native Breeze Window Decoration
      "kwinrc"."org.kde.kdecoration2"."library" = "org.kde.breeze";
      "kwinrc"."org.kde.kdecoration2"."theme" = "Breeze";
      "kwinrc"."org.kde.kdecoration2"."ButtonsOnLeft" = "XIA";
      "kwinrc"."org.kde.kdecoration2"."ButtonsOnRight" = "";

      # Standard Window Behavior
      "kwinrc"."Windows"."FocusPolicy" = "FocusFollowsMouse";
      "kwinrc"."Windows"."NextFocusPrefersMouse" = true;
      "kwinrc"."Windows"."Placement" = "Centered";
    };
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
