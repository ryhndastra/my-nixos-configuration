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
        rev = "main";
        sha256 = "1s3h9wx32pnh2aqnv59vi234jsfab34qjmwwajc004r6w2cqj705";
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
