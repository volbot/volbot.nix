{
  moduleNamespace,
  inputs,
  homeManager,
  ...
}:
{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.${moduleNamespace}.theme;
in
{

  imports = [
    inputs.stylix.homeModules.stylix

    inputs.noctalia.homeModules.default
  ];
  _file = ./default.nix;
  options = {
    ${moduleNamespace}.theme = with lib.types; {
      enable = lib.mkEnableOption "theming configurations";
      image = lib.mkOption {
        default = ./animegirl_wallpaper_blue.jpg;
        type = nullOr path;
      };
    };
  };
  config = lib.mkIf cfg.enable (
    let
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
    in
    {
      home.packages = with pkgs; [
        miku-cursor-linux
      ];

      stylix.targets = {
        floorp = {
          enable = true;
          colorTheme.enable = true;
          profileNames = [ "allomyrina" ];
        };

        starship.enable = false;

        waybar.enable = true;
      };

      programs.noctalia-shell = {
        enable = true;
        settings = {
          settingsVersion = 1;
          wallpaper = {
            enabled = true;
            directory = "/home/allie/Imagenes/Wallpapers";
            overviewEnabled = true;
          };
          location = {
            name = "Detroit";
          };
        };
      };

      home.file.".cache/noctalia/wallpapers.json" = {
        text = builtins.toJSON {
          defaultWallpaper = "/home/allie/Imagenes/Wallpapers/animegirl_wallpaper_blue.jpg";
        };
      };

      stylix = {
        enable = true;
                                #image = animegirl_wallpaper;
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
            name = "Mononoki Nerd Font";
          };
          emoji = {
            package = pkgs.noto-fonts-color-emoji;
            name = "Noto Color Emoji";
          };
          sizes = {
            applications = 13;
            popups = 12;
            desktop = 12;
            terminal = 13;
          };
        };
      };
    }
  );
}
