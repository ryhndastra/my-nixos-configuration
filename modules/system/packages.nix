{ pkgs, lib, ... }:

let
  qmlSearchPath = lib.makeSearchPath "lib/qt-6/qml" [
    pkgs.qt6.qt5compat
    pkgs.qt6.qtpositioning
    pkgs.qt6.qtlocation
    pkgs.qt6.qtmultimedia
    pkgs.qt6.qtsensors
    pkgs.qt6.qtsvg
    pkgs.qt6.qtimageformats
    pkgs.qt6.qtdeclarative
    pkgs.kdePackages.kirigami
    pkgs.kdePackages.syntax-highlighting
    pkgs.kdePackages.kdialog
  ];

  iconSearchPath = lib.makeSearchPath "share" [
    pkgs.kdePackages.breeze-icons
    pkgs.papirus-icon-theme
    pkgs.adwaita-icon-theme
    pkgs.hicolor-icon-theme
  ];

  quickshellWrapped = pkgs.symlinkJoin {
    name = "quickshell-wrapped";
    paths = [ pkgs.quickshell ];
    buildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/quickshell \
        --prefix QML2_IMPORT_PATH : "${qmlSearchPath}" \
        --prefix QML_IMPORT_PATH : "${qmlSearchPath}" \
        --prefix XDG_DATA_DIRS : "${iconSearchPath}"
      ln -sf $out/bin/quickshell $out/bin/qs
    '';
  };
in
{
  fonts.packages = with pkgs; [
    material-symbols
    google-fonts
    rubik
    inter
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
    psmisc
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
    quickshellWrapped
    matugen
    hyprlock
    hypridle
    hyprpicker
    hyprcursor
    awww
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
    kdePackages.breeze-icons
    adwaita-icon-theme
    hicolor-icon-theme
    foot
    libsecret
    libqalculate
    ddcutil
  ];
}
