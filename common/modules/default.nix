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
      floorp = import (homeOnly ./floorp) args;
      niri = import (homeOnly ./niri) args;
      gaming = import ./gaming args;
      theme = import (homeOnly ./theme) args;
      audio = import (systemOnly ./audio) args;
      inherit (shell)
        fish
        ;
    };
in
{
  flake.nixosModules = mkMods false;
  flake.homeModules = mkMods true;
}
