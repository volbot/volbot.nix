{
  settings,
  pkgs,
  ...
}:
{
  imports =
      [
        ./greetd.nix
        ./pipewire.nix
        ./nvidia.nix
        ./games.nix
        #./wm/niri.nix
      ];
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
