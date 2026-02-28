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
  imports = (
    if homeManager then
      [
        inputs.niri-flake.homeModules.niri
        #inputs.niri-flake.homeModules.stylix
      ]
    else
      [
        inputs.niri-flake.nixosModules.niri
      ]
  );
  options = {
    ${moduleNamespace}.niri = with lib.types; {
      enable = lib.mkEnableOption "niri configuration";
      background = lib.mkOption {
        default = ../theme/animegirl_wallpaper_blue.jpg;
        type = nullOr path;
      };
    };
  };

  _file = ./default.nix;

  config = lib.mkIf cfg.enable (
    let

      niriSettings = import ./settings.nix {
        inherit pkgs lib cfg;
      };

      waybarSettings = import ./waybar.nix { };

      niriPackages = with pkgs; [
        fuzzel
        alacritty
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
          programs.fuzzel.enable = true;

          programs.niri.enable = true;
          #programs.niri.settings = niriSettings;
          programs.niri.config = builtins.readFile ./config_temp.kdl;
          programs.waybar = waybarSettings;

          home.packages = niriPackages;
        }
      else
        { }
      # TODO: implement this
      # more: https://github.com/sodiboo/niri-flake/issues/278
      /*
        let
          niri-config =
            inputs.niri.lib.internal.validated-config-for pkgs config.programs.niri.package
              niriSettings.config.programs.niri.finalConfig;
        in
        {
          programs.niri.enable = true;
          programs.niri.config = niri-config;
          programs.waybar = waybarSettings;

          environment.systemPackages = niriPackages;
        }
      */
    )
  );
}
