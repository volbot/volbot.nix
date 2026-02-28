{ inputs, util, ... }:
let
  combinepkgs =
    fromPrev: final: prev:
    final
    // (builtins.listToAttrs (
      map (name: {
        inherit name;
        value = prev.${name};
      }) fromPrev
    ));
  wrapmod = extrasFromPrev: {
    data = name: final: prev: {
      ${name} = inputs.self.wrappedModules.${name}.wrap {
        pkgs = combinepkgs ([ name ] ++ extrasFromPrev) final prev;
      };
    };
    call-data-with-name = true;
  };
in
{
  overlays = {
    pinnedVersions = import ./pinnedVersions.nix inputs;
    niri = inputs.niri-flake.overlays.niri;
    pythonFix = (
      final: prev: {
        pythonPackagesExtensions = prev.pythonPackagesExtensions ++ [
          (python-final: python-prev: {
            picosvg = python-prev.picosvg.overridePythonAttrs (oldAttrs: {
              doCheck = false;
            });
          })
        ];
      }
    );
  };
}
