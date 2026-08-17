{ pkgs, inputs, ... }:

let
  spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.hostPlatform.system};
in
{
  programs.spicetify = {
    enable = false;


    enabledExtensions = with spicePkgs.extensions; [
      adblock
      hidePodcasts
      shuffle
      spicyLyrics
      romajiConvert
      oneko
      catJamSynced
    ];
  };
}
