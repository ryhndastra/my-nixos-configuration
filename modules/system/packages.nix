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

    # KDE Plasma Utilities & Aesthetic Tools
    catppuccin-kde
    kde-rounded-corners
    plasma-panel-colorizer
    papirus-icon-theme
    polonium
    quickshell
    kdePackages.plasma-systemmonitor
    kdePackages.spectacle
    kdePackages.dolphin
    kdePackages.kdegraphics-thumbnailers
    kdePackages.ffmpegthumbs
    kdePackages.kcalc
    kdePackages.ark
    kdePackages.plasma-browser-integration
  ];
}
