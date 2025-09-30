{
  description = "font management flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      defaultPackage = pkgs.symlinkJoin {
        name = "myfonts-0.0.1";
        paths =
          builtins.attrValues
          self.packages.${system};
      };
      packages.greybeard = pkgs.stdenvNoCC.mkDerivation {
        name = "greybeard-font";
        dontConfigue = true;
        src = pkgs.fetchzip {
          url = "https://github.com/flowchartsman/greybeard/releases/download/v1.0.0/Greybeard-v1.0.0-ttf.zip";
          hash = "sha256-fiZshFQ3DADrw6tEQsBHnli4hWrwUl7UxyoslvEeWsg=";
          stripRoot = false;
        };
        installPhase = ''
          mkdir -p $out/share/fonts
          cp -R $src $out/share/fonts/opentype/
        '';
        meta.description = "A Greybeard (UW ttyp0) derivation.";
      };
    });
}
