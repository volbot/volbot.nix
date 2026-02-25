inputs:
let
  overlay =
    self: super:
    (
      let
        pkgs = import inputs.xwayland-satellite-pin {
          inherit (self.stdenv.hostPlatform) system;
          config.allowUnfree = true;
        };
      in
      {
        # virtualbox = pkgs.virtualbox;
        xwayland-satellite = pkgs.xwayland-satellite;
        protontricks = pkgs.protontricks;
      }
    );
in
overlay
