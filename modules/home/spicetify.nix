{ pkgs, inputs, ... }:

let
  spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.hostPlatform.system};
in
{
  programs.spicetify = {
    enable = true;
    theme = {
      name = "SpicetifyCat";
      src = pkgs.fetchFromGitHub {
        owner = "Adrien5902";
        repo = "SpicetifyCat";
        rev = "c0e4c14e4ad705091cf8f45637ad94dd816fa228";
        sha256 = "sha256-9oqR78lf6rQtzGHHuPz/3kmLv+upJUzZ6UDEEjGexvU=";
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
