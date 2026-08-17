{ pkgs, inputs, ... }:

let
  spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.hostPlatform.system};
in
{
  programs.spicetify = {
    enable = true;
    theme = {
      name = "SpicetifyCat";
      src = pkgs.fetchgit {
        url = "https://github.com/Adrien5902/SpicetifyCat.git";
        rev = "c0e4c14e4ad705091cf8f45637ad94dd816fa228";
        hash = "sha256-BRYJmeAmEwCYVJxXiclYymljhog7lW2xEtBeMTpPcOg=";
      };
    };
    colorScheme = "Purple";

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
