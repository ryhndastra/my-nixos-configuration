{ pkgs, ... }:

{
  fonts.packages = with pkgs; [
    adwaita-fonts
    corefonts
    dejavu_fonts
    nerd-fonts.jetbrains-mono
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
  ];

  environment.systemPackages = with pkgs; [
    (sddm-astronaut.override {
      embeddedTheme = "pixel_sakura";
    })
    acpi
    btop
    curl
    dnsutils
    efibootmgr
    fastfetch
    fd
    file
    wget
    git
    inetutils
    jq
    kitty
    libva-utils
    lshw
    mesa-demos
    nautilus
    neovim
    nh
    nvtopPackages.full
    openssh
    p7zip
    pciutils
    ripgrep
    rsync
    seahorse
    tree
    unzip
    usbutils
    vulkan-tools
    vscode
    cloudflared

    # Hyprland Ecosystem & Illogical-Impulse / end4-pC Dependencies
    quickshell
    matugen
    hyprlock
    hypridle
    hyprpicker
    hyprcursor
    swww
    fuzzel
    wlogout
    cliphist
    wl-clipboard
    grim
    slurp
    swappy
    tesseract
    playerctl
    brightnessctl
    pavucontrol
    cava
    dart-sass
    imagemagick
    socat
    bc
    bibata-cursors
    adw-gtk3
    papirus-icon-theme
    foot

    # Helper wrapper for `qs` -> `quickshell`
    (writeShellScriptBin "qs" ''
      exec ${quickshell}/bin/quickshell "$@"
    '')
  ];
}
