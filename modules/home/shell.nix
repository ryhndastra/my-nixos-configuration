{ config, pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    shellAliases = {
      code = "code > /dev/null 2>&1";
    };
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

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    enableZshIntegration = true;
  };

  xdg.configFile."starship.toml" = {
    source = ../../dotfiles/starship/starship.toml;
    force = true;
  };

  programs.kitty = {
    enable = true;
    extraConfig = builtins.readFile ../../dotfiles/kitty/kitty.conf;
  };

  xdg.configFile."kitty/themes/noctalia.conf" = {
    source = ../../dotfiles/kitty/themes/noctalia.conf;
    force = true;
  };

  home.packages = with pkgs; [
    bat
    btop
    cliphist
    delta
    evtest
    eza
    fastfetch
    fd
    file
    fzf
    hyperfine
    jq
    just
    ripgrep
    tmux
    wl-clipboard
    xdg-utils
    zoxide
  ];
}
