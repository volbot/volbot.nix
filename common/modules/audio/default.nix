{
  moduleNamespace,
  homeManager,
  inputs,
  ...
}:
{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.${moduleNamespace}.audio;
in
{
  options = {
    ${moduleNamespace}.audio = with lib.types; {
      enable = lib.mkEnableOption "pipewire configuration";
    };
  };

  _file = ./default.nix;

  config = lib.mkIf cfg.enable (
    if homeManager then
      {
        home.packages = with pkgs; [
          qpwgraph
          helvum
          pavucontrol
        ];
      }
    else
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

        # disable automatic headphone switch
        services.pipewire.wireplumber.extraConfig."51-mitigate-annoying-profile-switch" = {
          "wireplumber.settings" = {
            "bluetooth.autoswitch-to-headset-profile" = false;
          };
        };

        # stops applications from automatically restoring profile configuration, so that everything can be defined declaratively
        services.pipewire.wireplumber.extraConfig."51-disable-auto-configure" = {
          "wireplumber.settings" = {
            "device.restore-profile" = false;
            "device.restore-routes" = false;
            "node.stream.restore-props" = false;
            "node.stream.restore-target" = false;
            "node.restore-default-targets" = false;
          };
        };

        # stop discord from changing microphone volumes
        services.pipewire.extraConfig.pipewire-pulse."51-discord-stop-resetting-audio" = {
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

        # configure defaults
        services.pipewire.wireplumber.extraConfig."99-set-defaults" = {
          "monitor.alsa.rules" = [
            {
              matches = [
                {
                  # this one matches my mobo audio
                  "node.nick" = "ALC1220 Analog";
                  "media.class" = "Audio/Sink";
                }
                {
                  # this one matches my microphone source
                  "node.nick" = "Samson Q2U Microphone";
                  "media.class" = "Audio/Source";
                }
              ];
              actions = {
                update-props = {
                  "priority.driver" = 3000;
                  "priority.session" = 3000;
                };
              };
            }
          ];
        };
      }

  );
}
