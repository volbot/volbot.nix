{ inputs, ... }:
let
  mkMods =
    homeManager:
    let
      homeOnly = path: (if homeManager then path else builtins.throw "no system module with that name");
      systemOnly =
        path: (if homeManager then builtins.throw "no home-manager module with that name" else path);
      moduleNamespace = "volbotMods";
      args = {
        inherit
          inputs
          moduleNamespace
          homeManager
          ;
      };
      shell = import ./shell args;
    in
    {
      volvim = import ./volvim args;
      #LD = import (systemOnly ./LD) args;
      #firefox = import (homeOnly ./firefox) args;
      #i3 = import ./i3 args;
      #i3MonMemory = import ./i3MonMemory args;
      #lightdm = import (systemOnly ./lightdm) args;
      inherit (shell)
        zsh
        bash
        fish
        ;
      #aliasNetwork = import (systemOnly ./aliasNetwork) args;
      #old_modules_compat = import ./old_modules_compat args;
    };
in
{
  flake.nixosModules = mkMods false;
  flake.homeModules = mkMods true;
}
