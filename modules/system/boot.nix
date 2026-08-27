{ pkgs, ... }:

{
  boot.loader.grub = {
    enable = true;
    device = "nodev";
    efiSupport = true;
    efiInstallAsRemovable = true;
    useOSProber = true;
  };
  boot.loader.efi.canTouchEfiVariables = false;

  # Silent Boot / Shutdown (Hide systemd text but keep GRUB menu)
  boot.kernelParams = [
    "quiet"
    "boot.shell_on_fail"
    "loglevel=3"
    "rd.systemd.show_status=false"
    "rd.udev.log_level=3"
    "udev.log_priority=3"
  ];
  boot.consoleLogLevel = 0;

  # Use latest kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;

  zramSwap.enable = true;
}
