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
  nadirWallpaper = "${./dotfiles/nadir/wallpapers/1329166.png}";
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

  # Declarative Nadir KDE Plasma 6 Rice
  programs.plasma = {
    enable = true;

    workspace = {
      clickItemTo = "select";
      lookAndFeel = "org.kde.breezedark.desktop";
      theme = "ROUNDED-COLOR-OPAQUE-CUSTOM";
      colorScheme = "CatppuccinMochaLavender";
      cursor = {
        theme = "aosp-cursors";
        size = 16;
      };
      iconTheme = "Papirus-Dark";
      wallpaper = nadirWallpaper;
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
        wallpaper = nadirWallpaper;
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
        names = [ "Ⅰ" "Ⅱ" "Ⅲ" "Ⅳ" "Ⅴ" ];
        rows = 1;
      };
    };

    # Nadir Rice Panels: 1) Floating Top Bar + 2) Centered Floating Bottom Dock
    panels = [
      # Top Bar (32px Floating Rounded Pill Bar)
      {
        location = "top";
        height = 32;
        floating = true;
        widgets = [
          {
            name = "org.kde.plasma.kickoff";
            config = {
              General.icon = "nix-snowflake";
            };
          }
          {
            name = "org.kde.plasma.appmenu"; # Global Menu Bar
          }
          {
            name = "org.kde.plasma.panelspacer";
          }
          {
            name = "org.kde.plasma.digitalclock";
            config = {
              Appearance = {
                showDate = true;
                dateFormat = "shortDate";
              };
            };
          }
          {
            name = "org.kde.plasma.panelspacer";
          }
          {
            name = "org.kde.plasma.pager";
            config = {
              General = {
                showWindowOutlines = false;
                displayedText = "Name";
              };
            };
          }
          {
            name = "org.kde.plasma.systemtray";
          }
        ];
      }

      # Bottom Dock (56px Floating Centered Auto-Hide Dock)
      {
        location = "bottom";
        height = 56;
        floating = true;
        alignment = "center";
        hiding = "autohide";
        lengthMode = "fit";
        widgets = [
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
        ];
      }
    ];

    # Standard Shortcuts
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
      "krunner.desktop"."_launch" = "Meta+Space";
      "org.kde.krunner.desktop"."_launch" = "Meta+Space";

      # Window Controls
      "kwin"."Window Close" = "Meta+Q";
      "kwin"."Window Maximize" = "Meta+F";
      "kwin"."Window Fullscreen" = "Meta+Shift+F";
      "kwin"."Walk Through Windows" = "Alt+Tab";
      "kwin"."Overview" = "Meta+Tab";
      "kwin"."Show Desktop" = "Meta+Shift+D";

      # Quick Tiling (Native KWin Tile Snapping & Quarter Tiles with 16px Gaps)
      "kwin"."Window Quick Tile Left" = "Meta+Left";
      "kwin"."Window Quick Tile Right" = "Meta+Right";
      "kwin"."Window Quick Tile Top" = "Meta+Up";
      "kwin"."Window Quick Tile Bottom" = "Meta+Down";
      "kwin"."Window Quick Tile Top Left" = "Meta+Shift+Left";
      "kwin"."Window Quick Tile Top Right" = "Meta+Shift+Right";
      "kwin"."Window Quick Tile Bottom Left" = "Meta+Shift+Down";
      "kwin"."Window Quick Tile Bottom Right" = "Meta+Shift+Up";
      "kwin"."Edit Tiles" = "Meta+Shift+T";

      # Workspaces Navigation
      "kwin"."Switch to Desktop 1" = "Meta+1";
      "kwin"."Switch to Desktop 2" = "Meta+2";
      "kwin"."Switch to Desktop 3" = "Meta+3";
      "kwin"."Switch to Desktop 4" = "Meta+4";
      "kwin"."Switch to Desktop 5" = "Meta+5";

      # Lock screen
      "ksmserver"."Lock Session" = "Meta+Alt+L";
    };

    configFile = {
      # Sweet Dark Transparent Custom Window Decoration (Nadir Rice)
      "kwinrc"."org.kde.kdecoration2"."library" = "org.kde.kwin.aurorae";
      "kwinrc"."org.kde.kdecoration2"."theme" = "__aurorae__svg__Sweet-Dark-transparent-Custom";
      "kwinrc"."org.kde.kdecoration2"."ButtonsOnLeft" = "XIA";
      "kwinrc"."org.kde.kdecoration2"."ButtonsOnRight" = "";
      "kwinrc"."org.kde.kdecoration2"."BorderSize" = "Normal";
      "kwinrc"."org.kde.kdecoration2"."BorderSizeAuto" = false;

      # KWin Plasma 6 Tiling & Padding (16px aesthetic gaps)
      "kwinrc"."Tiling"."padding" = 16;
      "kwinrc"."Windows"."ElectricBorders" = 2;
      "kwinrc"."Windows"."ElectricBorderTiling" = true;
      "kwinrc"."Windows"."ElectricBorderMaximize" = false;

      # Native KWin Smooth Rounded Corners Shader (12px radius + 2.5px Lavender Outline Border)
      "kwinrc"."Plugins"."kwin4_effect_shapecornersEnabled" = true;
      "kwinrc"."Effect-kwin4_effect_shapecorners"."Size" = 12;
      "kwinrc"."Effect-kwin4_effect_shapecorners"."InactiveCornerRadius" = 12;
      "kwinrc"."Effect-kwin4_effect_shapecorners"."OutlineThickness" = 2.5;
      "kwinrc"."Effect-kwin4_effect_shapecorners"."OutlineColor" = "203,166,247";
      "kwinrc"."Effect-kwin4_effect_shapecorners"."ActiveOutlineUseCustom" = true;
      "kwinrc"."Effect-kwin4_effect_shapecorners"."ActiveOutlineAlpha" = 240;
      "kwinrc"."Effect-kwin4_effect_shapecorners"."DisableRoundMaximize" = true;
      "kwinrc"."Effect-kwin4_effect_shapecorners"."DisableOutlineMaximize" = true;
      "kwinrc"."Effect-kwin4_effect_shapecorners"."IncludeNormalWindows" = true;
      "kwinrc"."Effect-kwin4_effect_shapecorners"."IncludeDialogs" = true;

      # Standard Window Behavior
      "kwinrc"."Windows"."FocusPolicy" = "FocusFollowsMouse";
      "kwinrc"."Windows"."NextFocusPrefersMouse" = true;
      "kwinrc"."Windows"."Placement" = "Centered";
    };
  };

  # Link Nadir Custom Rice Themes (Aurorae, Plasma Desktop Theme, Wallpapers)
  xdg.dataFile."aurorae/themes/Sweet-Dark-transparent-Custom" = {
    source = ./dotfiles/nadir/aurorae-theme/Sweet-Dark-transparent-Custom;
    recursive = true;
  };
  xdg.dataFile."plasma/desktoptheme/ROUNDED-COLOR-OPAQUE-CUSTOM" = {
    source = ./dotfiles/nadir/plasma-theme/ROUNDED-COLOR-OPAQUE-CUSTOM;
    recursive = true;
  };
  xdg.dataFile."wallpapers/Abyss" = {
    source = ./dotfiles/nadir/wallpapers;
    recursive = true;
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
