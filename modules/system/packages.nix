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
  ];
}
