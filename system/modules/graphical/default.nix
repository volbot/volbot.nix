{
  settings,
  pkgs,
  ...
}:
{
  imports =
    if settings.hostname == "allomyrina" then
      [
        ./greetd.nix
        ./pipewire.nix
        ./nvidia.nix
        ./games.nix
      ]
    else
      [ ];
  services.blueman.enable = true;
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        Experimental = true;
        FastConnectible = true;
      };
      Policy = {
        AutoEnable = true;
      };
    };
  };
  services.joycond.enable = true;
  services.dbus.packages = with pkgs; [ blueman ];
}
