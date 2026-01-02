{
pkgs,
  ...
}:
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
