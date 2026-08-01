{ pkgs, ... }:

{
  boot.loader.grub = {
    enable = true;
    device = "nodev";
    efiSupport = true;
  };
  boot.loader.efi.canTouchEfiVariables = true;

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

  swapDevices = [
    {
      device = "/swapfile";
      size = 25600;
    }
  ];

  fileSystems."/mnt/data" = {
    device = "/dev/disk/by-uuid/9ea5a392-65e2-4559-84a5-d46acaa09a50";
    fsType = "ext4";
    options = [ "nofail" ];
  };
}
