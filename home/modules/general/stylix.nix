{
  pkgs,
  config,
  lib,
  inputs,
  home,
  ...
}: let
  animegirl_wallpaper = ./animegirl_wallpaper_blue.jpg;
  miku-cursor-linux = pkgs.stdenv.mkDerivation {
    pname = "miku-cursor-derivation";
    version = "master";
    src = "${inputs.miku-cursor}/miku-cursor-linux";
    dontPatch = true;
    dontConfigure = true;
    dontBuild = true;
    dontFixup = true;
    installPhase = ''
      mkdir -p $out/share/icons/miku-cursor-linux
      mv ./* $out/share/icons/miku-cursor-linux
    '';
  };
in {
  imports = [
    inputs.stylix.homeModules.stylix
  ];

  home.packages = with pkgs; [
    miku-cursor-linux
  ];

  stylix = {
    enable = true;
    image = animegirl_wallpaper;
    cursor = {
      name = "miku-cursor-linux";
      size = 32;
      package = miku-cursor-linux;
    };
    base16Scheme = "${inputs.voltrix}/build/base16/voltrix.yaml";
    opacity = {
      terminal = 0.85;
      desktop = 0.85;
      popups = 0.85;
      applications = 0.85;
    };
    fonts = {
      sansSerif = {
        package = pkgs.aileron;
        name = "Aileron";
      };
      serif = config.stylix.fonts.sansSerif;
      monospace = {
        #package = inputs.font-flake.packages.x86_64-linux.greybeard;
        #name = "Greybeard 22px";
        package = pkgs.nerd-fonts.mononoki;
        name = "Mononoki Nerd Font Mono";
      };
      emoji = {
        package = pkgs.noto-fonts-emoji;
        name = "Noto Color Emoji";
      };
      sizes = {
        applications = 13;
        popups = 12;
        desktop = 12;
        terminal = 13;
      };
    };
    targets.neovim.transparentBackground.main = true;
  };
}
