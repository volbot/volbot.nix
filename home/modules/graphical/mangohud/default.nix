{
  ...
}:
{
  programs.mangohud = {
    enable = true;
    settings = {
      preset = 2;
    };
  };

  xdg.configFile."MangoHud/presets/conf" = {
    source = ./presets.conf;
    force = true;
  };
}
