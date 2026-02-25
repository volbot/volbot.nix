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
  cfg = config.${moduleNamespace}.fish;
in
{
  options = {
    ${moduleNamespace}.fish = with lib.types; {
      enable = lib.mkEnableOption "fish config with starship";
    };
  };

  _file = ./default.nix;

  config = lib.mkIf cfg.enable (
    let

      starshipSettings = import ./starship.nix {
        inherit pkgs lib cfg;
      };

      readDirRecursive =
        path:
        lib.mapAttrsRecursive (
          name: value:
          if value == "directory" then
            readDirRecursive (path + "/${builtins.concatStringsSep "" name}")
          else
            builtins.readFile (path + "/${builtins.concatStringsSep "" name}")
        ) (builtins.readDir path);
      fileContents = readDirRecursive ./fish_files;
      attrs = [
        (builtins.readFile "${inputs.fish-ssh-agent}/functions/fish_ssh_agent.fish")
        (builtins.readFile "${inputs.voltrix}/build/fish/voltrix.fish")
        fileContents.functions."fish_right_prompt.fish"
        fileContents.functions."fish_mode_prompt.fish"
        fileContents.functions."fish_prompt.fish"
        fileContents.functions."fish_greeting.fish"
        fileContents."config.fish"
      ];
    in
    (
      if homeManager then
        {
          programs.fish = {
            enable = true;
            interactiveShellInit = builtins.concatStringsSep "" attrs;
            functions = {
              cd = "z $argv";
            };
          };
          programs.starship = starshipSettings;
        }
      else
        {
          programs.fish.enable = true;
        }
    )
  );
}
