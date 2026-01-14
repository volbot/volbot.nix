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
  cfg = config.${moduleNamespace}.volvim;
  inherit (config.volvim) utils;
in
{
  _file = ./default.nix;
  imports = if homeManager then [ inputs.volvim.homeModule ] else [ inputs.volvim.nixosModule ];
  options = {
    ${moduleNamespace}.volvim = with lib.types; {
      enable = lib.mkEnableOption "allie's nvim config";
      packageNames = lib.mkOption {
        default = [ ];
        type = listOf str;
      };
      base16colors = lib.mkOption {
        default = { };
        type = attrs;
      };
    };
  };
  config = lib.mkIf cfg.enable ({
    volvim =
      let
        replacements = builtins.mapAttrs (
          n: _:
          { pkgs, ... }:
          {
            settings = {
              moduleNamespace = [
                moduleNamespace
                n
              ];
            };
            extra = {
              base16colors = cfg.base16colors;
              nixdExtras = {
                # flake-path = ''${inputs.self.outPath}'';
              };
            };
            categories = lib.mkIf (n == "volvim") {
              kotlin = true;
            };
          }
        ) inputs.volvim.packages.${pkgs.stdenv.hostPlatform.system}.default.packageDefinitions;
      in
      {
        inherit (cfg) enable packageNames;
        packageDefinitions.replace = replacements;
        # packageDefinitions.merge = merges;
        # dontInstall = true;
      };
  });
  # // (let
  #   finalpkgs = lib.pipe (config.volvim.out.packages or {}) [
  #     builtins.attrValues
  #     (map (p: p.overrideAttrs { nativeBuildInputs = [ pkgs.makeBinaryWrapper ]; }))
  #   ];
  # in if homeManager then {
  #   home.packages = finalpkgs;
  # } else {
  #   environment.systemPackages = finalpkgs;
  # }));
}
