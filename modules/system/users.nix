{ pkgs, inputs, ... }:

{
  users.users.sho = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "networkmanager"
      "docker"
      "input"
    ];

    shell = pkgs.zsh;
  };

  programs.zsh.enable = true;
}
