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

  gtk = {
    enable = true;
    cursorTheme = {
      package = aospCursors;
      name = "aosp-cursors";
      size = 16;
    };
    iconTheme = {
      package = pkgs.papirus-icon-theme;
      name = "Papirus-Dark";
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

  # Declarative KDE Plasma 6 Ricing (Japanese Aesthetic + Hyprland/Niri Style)
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

    # Matching SDDM Pixel Sakura Lockscreen
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
        blur = {
          enable = true;
          noiseStrength = 5;
        };
        translucency.enable = true;
        wobblyWindows.enable = false;
      };
      nightLight = {
        enable = false;
      };
      virtualDesktops = {
        number = 5;
        rows = 1;
      };
    };

    # Floating Island Top Bar (Segmented Capsule Aesthetic)
    panels = [
      {
        location = "top";
        height = 40;
        floating = true;
        alignment = "center";
        screen = "all";
        widgets = [
          # Left Island: NixOS Sakura Launcher + Workspace Pager
          {
            name = "org.kde.plasma.kickoff";
            config = {
              General = {
                icon = "distributor-logo-nixos";
                favoritesPortedToKAstats = true;
              };
            };
          }
          {
            name = "org.kde.plasma.pager";
            config = {
              General = {
                showWindowIcons = true;
                displayedText = "Number";
              };
            };
          }
          "org.kde.plasma.panelspacer"

          # Center Island: Running Tasks & Dock Icons
          {
            name = "org.kde.plasma.icontasks";
            config = {
              General = {
                launchers = [
                  "applications:kitty.desktop"
                  "applications:zen-beta.desktop"
                  "applications:code.desktop"
                  "applications:spotify.desktop"
                  "applications:org.gnome.Nautilus.desktop"
                ];
              };
            };
          }
          "org.kde.plasma.panelspacer"

          # Right Island: Spotify Media Controller + System Tray + Japanese/Aesthetic Clock
          {
            name = "org.kde.plasma.mediacontroller";
          }
          {
            name = "org.kde.plasma.systemtray";
          }
          {
            name = "org.kde.plasma.digitalclock";
            config = {
              Appearance = {
                showSeconds = "never";
                customDateFormat = "MM月dd日 (ddd)";
                dateFormat = "custom";
                use24hFormat = 2;
              };
            };
          }
        ];
      }
    ];

    # Keybindings (Single Super for Launcher + Niri/Hyprland Shortcuts + Quick Tiling)
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

      # Quick Tiling (Make Window Tiled / Half / Quarter Screen)
      "kwin"."Window Quick Tile Left" = "Meta+Left";
      "kwin"."Window Quick Tile Right" = "Meta+Right";
      "kwin"."Window Quick Tile Top" = "Meta+Up";
      "kwin"."Window Quick Tile Bottom" = "Meta+Down";
      "kwin"."Window Quick Tile Top Left" = "Meta+Shift+Left";
      "kwin"."Window Quick Tile Top Right" = "Meta+Shift+Right";

      # Window Resize via Keyboard
      "kwin"."Window Grow Horizontal" = "Meta+Ctrl+Right";
      "kwin"."Window Shrink Horizontal" = "Meta+Ctrl+Left";
      "kwin"."Window Grow Vertical" = "Meta+Ctrl+Up";
      "kwin"."Window Shrink Vertical" = "Meta+Ctrl+Down";

      # Workspaces Navigation & Window Moving (Win+Number & Win+Shift+Number)
      "kwin"."Switch to Desktop 1" = "Meta+1";
      "kwin"."Switch to Desktop 2" = "Meta+2";
      "kwin"."Switch to Desktop 3" = "Meta+3";
      "kwin"."Switch to Desktop 4" = "Meta+4";
      "kwin"."Switch to Desktop 5" = "Meta+5";

      "kwin"."Window to Desktop 1" = "Meta+Shift+1";
      "kwin"."Window to Desktop 2" = "Meta+Shift+2";
      "kwin"."Window to Desktop 3" = "Meta+Shift+3";
      "kwin"."Window to Desktop 4" = "Meta+Shift+4";
      "kwin"."Window to Desktop 5" = "Meta+Shift+5";

      # Lock screen (matching Niri Meta+Alt+L)
      "ksmserver"."Lock Session" = "Meta+Alt+L";
    };

    configFile = {
      "kdeglobals"."KDE"."widgetStyle" = "Breeze";
      "kwinrc"."ModifierOnlyShortcuts"."Meta" = "org.kde.plasma.kickoff,org.kde.plasma.kickoff,toggle";
      "kwinrc"."Plugins"."krohnkiteEnabled" = false;
      "kwinrc"."Plugins"."wobblywindowsEnabled" = false;

      # Native KWin Smooth Rounded Corners Shader (14px radius + Sakura Outline Border)
      "kwinrc"."Plugins"."kwin4_effect_shapecornersEnabled" = true;
      "kwinrc"."Effect-shapecorners"."RoundCorners" = true;
      "kwinrc"."Effect-shapecorners"."CornerRadius" = 14;
      "kwinrc"."Effect-shapecorners"."Outline" = true;
      "kwinrc"."Effect-shapecorners"."OutlineThickness" = 1.5;
      "kwinrc"."Effect-shapecorners"."OutlineColor" = "203,166,247,190";
      "kwinrc"."Effect-shapecorners"."Shadow" = true;
      "kwinrc"."Effect-shapecorners"."SecondCornerRadius" = 14;

      # Sleek Modern Window Decorations (Clean minimal borders)
      "kwinrc"."org.kde.kdecoration2"."BorderSize" = "None";
      "kwinrc"."org.kde.kdecoration2"."BorderSizeAuto" = false;
      "kwinrc"."org.kde.kdecoration2"."ButtonsOnLeft" = "";
      "kwinrc"."org.kde.kdecoration2"."ButtonsOnRight" = "IAX";

      # Mouse on Focus (Focus Follows Mouse)
      "kwinrc"."Windows"."FocusPolicy" = "FocusFollowsMouse";
      "kwinrc"."Windows"."NextFocusPrefersMouse" = true;
      "kwinrc"."Windows"."DelayFocusInterval" = 0;
      "kwinrc"."Windows"."AutoRaise" = false;

      # Window Placement & Dimensions (Moderate Centered Floating Window by default)
      "kwinrc"."Windows"."Placement" = "Centered";
      "kwinrc"."Windows"."BorderlessMaximizedWindows" = true;
      "kwinrc"."Windows"."CommandAllKey" = "Meta";
      "kwinrc"."Windows"."CommandAll1" = "Move";
      "kwinrc"."Windows"."CommandAll2" = "Resize";
      "kwinrc"."Windows"."CommandAll3" = "Maximize";

      # Default Moderate Initial Window Size Rule (1060x660 centered, not auto-maximized)
      "kwinrulesrc"."1"."Description" = "Default Centered Moderate Window Size";
      "kwinrulesrc"."1"."types" = "1";
      "kwinrulesrc"."1"."wmclassmatch" = 0;
      "kwinrulesrc"."1"."size" = "1060,660";
      "kwinrulesrc"."1"."sizerule" = 4; # Apply initially
      "kwinrulesrc"."1"."maximizehoriz" = false;
      "kwinrulesrc"."1"."maximizehorizrule" = 4;
      "kwinrulesrc"."1"."maximizevert" = false;
      "kwinrulesrc"."1"."maximizevertrule" = 4;
      "kwinrulesrc"."General"."count" = 1;
      "kwinrulesrc"."General"."rules" = "1";
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
