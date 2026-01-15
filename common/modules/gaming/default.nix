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
  cfg = config.${moduleNamespace}.gaming;
in
{
  _file = ./default.nix;
  options = {
    ${moduleNamespace}.gaming = with lib.types; {
      enable = lib.mkEnableOption "gaming configurations";
    };
  };
  config = lib.mkIf cfg.enable (
    if homeManager then
      {
        programs.mangohud = {
          enable = true;
          enableSessionWide = true;
          settings = {
            preset = 2;
          };
        };

        xdg.configFile."MangoHud/presets/conf" = {
          source = ./presets.conf;
          force = true;
        };
      }
    else
      {
        environment.systemPackages = with pkgs; [
          protonup-qt
          gamescope-wsi
          protontricks
        ];

        programs.steam = {
          enable = true;
          extraPackages = with pkgs; [
            gamescope
            xwayland-run
            gamescope-wsi
          ];
          extraCompatPackages = with pkgs; [
            proton-ge-bin
          ];
        };

        programs.gamescope.enable = true;

        programs.gamemode.enable = true;
      }
  );
}
