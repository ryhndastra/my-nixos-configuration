{ pkgs, ... }:

{
  programs.git = {
    enable = true;
    ignores = [
      ".direnv"
      ".direnv/"
    ];
    settings = {
      user = {
        name = "ryhndastra";
        email = "ryhndastra@gmail.com";
      };
      init.defaultBranch = "main";
      credential."https://github.com".helper = "!gh auth git-credential";
      credential."https://gist.github.com".helper = "!gh auth git-credential";
    };
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
          pkgs = import nixpkgs {
            system = "x86_64-linux";
            config.allowUnfree = true;
          };
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
            if [ -f .gitignore ]; then
              grep -q "^\.direnv" .gitignore || echo ".direnv/" >> .gitignore
            else
              echo ".direnv/" > .gitignore
            fi
            direnv allow
            echo "Development environment for $@ is ready!"
    '')
    alejandra
    android-studio
    antigravity-ide
    gh
    git-lfs
    flutter
    lazygit
    nil
    nixd
    nixfmt
    vite
    (pkgs.writeShellScriptBin "mirror-display" (builtins.readFile ../../dotfiles/scripts/mirror-display.sh))
  ];
}
