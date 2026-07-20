{
  personal =
    { pkgs, ... }:
    {
      home-shortcut = {
        programs.mangohud = {
          enable = true;
          enableSessionWide = true;
          settings = {
            preset = 2;
          };
        };

        /*
          xdg.configFile."MangoHud/presets/conf" = {
            source = ./presets.conf;
            force = true;
          };
        */
      };
      environment.systemPackages = with pkgs; [
        protonup-qt
        gamescope-wsi
        protontricks
        mesa-demos
        vulkan-tools
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
    };
}
