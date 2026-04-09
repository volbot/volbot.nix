{
  moduleNamespace,
  inputs,
  homeManager,
  ...
}:
{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.${moduleNamespace}.homelab;
in
{
  _file = ./default.nix;
  options = {
    ${moduleNamespace}.homelab = with lib.types; {
      enable = lib.mkEnableOption "homelab setup for atlas";
    };
  };
  config = lib.mkIf cfg.enable (
    if homeManager then
      {
      }
    else
      {
        environment.systemPackages = with pkgs; [
          jellyfin
          jellyfin-ffmpeg
          jellyfin-web
          jellyfin-tui

          qbittorrent
          qbittorrent-cli

          cloudflared
        ];

        services.qbittorrent = {
          enable = true;
          openFirewall = true;
          webuiPort = 58080;
        };

        services.jellyfin = {
          enable = true;
          openFirewall = true;
        };

        services.sonarr = {
          enable = true;
          openFirewall = true;
        };

        services.radarr = {
          enable = true;
          openFirewall = true;
        };

        services.recyclarr = {
          enable = true;
        };

        services.prowlarr = {
          enable = true;
          openFirewall = true;
        };

        services.seerr = {
          enable = true;
          openFirewall = true;
        };

        services.bazarr = {
          enable = true;
          openFirewall = true;
        };

        services.cloudflared = {
          enable = true;
          tunnels = {
            "14fc4080-e2b1-4328-b111-55ca2b37cab8" = {
              credentialsFile = "/home/allie/.cloudflared/14fc4080-e2b1-4328-b111-55ca2b37cab8.json";
              ingress = {
                "seerr.volbot.org" = {
                  service = "http://10.0.0.225:5055";
                };
                "jellyfin.volbot.org" = {
                  service = "http://10.0.0.225:8096";
                };
                "ssh.volbot.org" = {
                  service = "ssh://10.0.0.225:22";
                };
              };
              default = "http_status:404";
            };
          };
        };

        services.openssh.settings.Macs = [
          # Current defaults:
          "hmac-sha2-512-etm@openssh.com"
          "hmac-sha2-256-etm@openssh.com"
          "umac-128-etm@openssh.com"
          # Added:
          "hmac-sha2-256"
        ];
      }
  );
}
