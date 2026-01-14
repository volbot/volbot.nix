{
  moduleNamespace,
  homeManager,
  inputs,
  ...
}:
{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.${moduleNamespace}.niri;
in
{
  imports = [
    (if homeManager then inputs.niri.homeModules.niri else inputs.niri.nixosModules.niri)
    (if homeManager then inputs.niri.homeModules.stylix else inputs.niri.nixosModules.stylix)
  ];

  options = {
    ${moduleNamespace}.niri = with lib.types; {
      enable = lib.mkEnableOption "niri configuration";
      background = lib.mkOption {
        default = ./misc/animegirl_wallpaper_blue.jpg;
        type = nullOr path;
      };
    };
  };

  _file = ./default.nix;

  config = lib.mkIf cfg.enable (
    let

      niriSettings = import ./settings.nix {
        inherit pkgs lib config;
      };

      waybarSettings = import ./waybar.nix {
        inherit pkgs lib config;
      };

      niriPackages = with pkgs; [
        alacritty
        fuzzel
        mako
        swaybg
        swaylock
        xwayland-satellite
        wl-clipboard
        wayland-utils
      ];

    in
    (
      if homeManager then
        {
          programs.niri.enable = true;
          programs.niri.settings = niriSettings;
          programs.waybar = waybarSettings;

          home.packages = niriPackages;
        }
      else
        {
          programs.niri.enable = true;
          programs.niri.settings = niriSettings;
          programs.waybar = waybarSettings;

          environment.systemPackages = niriPackages;
        }
    )
  );
}
