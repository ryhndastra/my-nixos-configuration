{ pkgs, ... }:

{
  # Nix-LD: Allows generic precompiled dynamically linked ELF binaries (like Android SDK adb, aapt2, emulator) to run on NixOS
  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      stdenv.cc.cc
      zlib
      fuse3
      alsa-lib
      at-spi2-atk
      at-spi2-core
      atk
      cairo
      cups
      curl
      dbus
      expat
      fontconfig
      freetype
      gdk-pixbuf
      glib
      gtk3
      icu
      libGL
      libappindicator-gtk3
      libdrm
      libglvnd
      libnotify
      libpulseaudio
      libunwind
      libusb1
      libuuid
      libxkbcommon
      libxml2
      mesa
      nspr
      nss
      openssl
      pango
      pipewire
      systemd
      vulkan-loader
      xorg.libX11
      xorg.libXScrnSaver
      xorg.libXcomposite
      xorg.libXcursor
      xorg.libXdamage
      xorg.libXext
      xorg.libXfixes
      xorg.libXi
      xorg.libXrandr
      xorg.libXrender
      xorg.libXtst
      xorg.libxcb
      xorg.libxkbfile
      xorg.libxshmfence
    ];
  };

  # Development tools for Flutter & Android
  environment.systemPackages = with pkgs; [
    jdk17
  ];

  # Environment variables for Flutter / Android toolchain
  environment.sessionVariables = {
    JAVA_HOME = "${pkgs.jdk17}";
    ANDROID_HOME = "/home/sho/Android/Sdk";
  };
}
