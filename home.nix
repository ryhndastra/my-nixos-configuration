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

  spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.hostPlatform.system};
in
{
  imports = [
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

  # Zsh + prompt
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
        "sudo"
      ];
      theme = "";
    };
    initContent = ''
      # Print logo and system info on shell startup
      cat /etc/nixos/dotfiles/fastfetch/logo.txt
      fastfetch -c /etc/nixos/dotfiles/fastfetch/config.jsonc --logo /etc/nixos/dotfiles/fastfetch/ghost.txt --logo-type file

      # Interactive menu selection for tab completion
      zstyle ':completion:*' menu select
      bindkey '^[[Z' reverse-menu-complete
    '';
  };

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "ryhndastra";
        email = "ryhndastra@gmail.com";
      };
      init.defaultBranch = "main";
    };
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    enableZshIntegration = true;
  };

  xdg.configFile."starship.toml" = {
    source = ./dotfiles/starship/starship.toml;
    force = true;
  };

  # Kitty Terminal
  programs.kitty = {
    enable = true;
    extraConfig = builtins.readFile ./dotfiles/kitty/kitty.conf;
  };

  xdg.configFile."kitty/themes/noctalia.conf" = {
    source = ./dotfiles/kitty/themes/noctalia.conf;
    force = true;
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
    FLAKE = "/etc/nixos";
  };

  home.packages = with pkgs; [
    (pkgs.writeShellScriptBin "dev-init" ''
            if [ -z "$1" ]; then
              echo "Usage: dev-init <lang1> [lang2] [lang3] ..."
              echo "Available: php, node, go, rust"
              exit 1
            fi

            if [ -f "flake.nix" ]; then
              echo "flake.nix already exists!"
              exit 1
            fi

            cat << 'EOF' > flake.nix
      {
        description = "Development environment";
        inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
        outputs = { self, nixpkgs }: let
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
        in {
          devShells.x86_64-linux.default = pkgs.mkShell {
            packages = with pkgs; [
      EOF

            for lang in "$@"; do
              case "$lang" in
                php)
                  cat << 'EOF' >> flake.nix
              php84
              php84Packages.composer
              phpactor
              intelephense
              laravel
      EOF
                  ;;
                node)
                  cat << 'EOF' >> flake.nix
              nodejs_24
              bun
              pnpm
              yarn
              typescript
      EOF
                  ;;
                go)
                  cat << 'EOF' >> flake.nix
              go
              gopls
      EOF
                  ;;
                rust)
                  cat << 'EOF' >> flake.nix
              rustup
      EOF
                  ;;
                *)
                  echo "Unknown language: $lang, skipping..."
                  ;;
              esac
            done

            cat << 'EOF' >> flake.nix
            ];
          };
        };
      }
      EOF

            echo "use flake" > .envrc
            direnv allow
            echo "✅ Development environment for $@ is ready!"
    '')
    adwaita-fonts
    alejandra
    android-studio
    antigravity-ide
    bat
    blueman
    btop
    brightnessctl
    cliphist
    delta
    evtest
    eza
    fastfetch
    fd
    ffmpeg
    file
    fzf
    gamescope
    gh
    git-lfs
    glow
    grim
    flutter
    hyperfine
    imv
    jq
    just
    lazygit
    linux-wallpaperengine
    mangohud
    mariadb
    mpv
    networkmanagerapplet
    nil
    nixd
    nixfmt
    noto-fonts-color-emoji
    obsidian
    pamixer
    pavucontrol
    playerctl
    polkit_gnome
    procs
    protonup-qt
    ripgrep
    sd
    slurp
    swappy
    tealdeer
    telegram-desktop
    tmux
    vesktop
    vite
    wl-clipboard
    wf-recorder
    wpsoffice
    xwayland-satellite
    xdg-utils
    inputs.zen-browser.packages."${pkgs.stdenv.hostPlatform.system}".default
    zoxide
  ];

  programs.spicetify = {
    enable = true;
    theme = {
      name = "SpicetifyCat";
      src = pkgs.fetchFromGitHub {
        owner = "Adrien5902";
        repo = "SpicetifyCat";
        rev = "main";
        sha256 = "1s3h9wx32pnh2aqnv59vi234jsfab34qjmwwajc004r6w2cqj705";
      };
    };
    colorScheme = "Purple";

    enabledExtensions = with spicePkgs.extensions; [
      adblock
      hidePodcasts
      shuffle
      spicyLyrics
      romajiConvert
      oneko
      catJamSynced
    ];
  };
}
