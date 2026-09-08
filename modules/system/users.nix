{ pkgs, inputs, ... }:

{
  users.users.sho = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "networkmanager"
      "docker"
      "input"
      "libvirtd"
    ];

    shell = pkgs.zsh;
  };

  programs.zsh.enable = true;
}
