inputs: {
  personal =
    { pkgs, lib, ... }:
    let
      niriSettings = import ./settings.nix {
        inherit pkgs lib;
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
    {
      home-shortcut = {
        imports = [
          inputs.niri-flake.homeModules.niri
        ];
        home.packages = niriPackages;
        programs.fuzzel.enable = true;

      programs.niri = {
        enable = true;
        package = pkgs.niri;
        #settings = niriSettings;
        config = builtins.readFile ./config_temp.kdl;
      };

      };
      #programs.niri.settings = niriSettings;

    };
}
