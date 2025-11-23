{
  pkgs,
  config,
  lib,
  inputs,
  ...
}:
let
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
{
  programs.fish = {
    enable = true;
    interactiveShellInit = builtins.concatStringsSep "" attrs;
    functions = {
      cd = "z $argv";
    };
    /*
      interactiveShellInit = fileContents."config.fish";
      functions = {
        voltrix = fileContents.functions."voltrix.fish";
        fish_ssh_agent = builtins.readFile "${inputs.fish-ssh-agent}/functions/fish_ssh_agent.fish";
        fish_greeting = fileContents.functions."fish_greeting.fish";
        fish_right_prompt = fileContents.functions."fish_right_prompt.fish";
        fish_prompt = fileContents.functions."fish_prompt.fish";
      };
    */
  };
}
