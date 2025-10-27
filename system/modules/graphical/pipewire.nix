{ pkgs, ... }:
{
  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  # boot.blacklistedKernelModules = [ "snd_aloop" ];

  services.pipewire.wireplumber.extraConfig."51-mitigate-annoying-profile-switch" = {
    "wireplumber.settings" = {
      "bluetooth.autoswitch-to-headset-profile" = false;
    };
  };

  services.pipewire.wireplumber.extraConfig."51-stop-restoring-shit-you-cunt" = {
    "wireplumber.settings" = {
      "device.restore-profile" = false;
      "device.restore-routes" = false;
      "node.stream.restore-props" = false;
      "node.stream.restore-target" = false;
      "node.restore-default-targets" = false;
    };
  };

  services.pipewire.extraConfig.pipewire-pulse."51-STOP-FUCKING-WITH-MY-SHIT" = {
    "pulse.rules" = [
    {
      "match" = [
      { "application.process.binary" = "vesktop"; }
      ];
      "actions" = {
        "quirks" = [ "block-source-volume" ];
      };
    }
    ];
  };

}

