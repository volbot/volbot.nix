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
  imports = (
    if homeManager then
      [
      ]
    else
      [
        inputs.sops-nix.nixosModules.sops
        inputs.vpn-confinement.nixosModules.default
      ]
  );
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
        sops.secrets."wireguard_config" = {
          sopsFile = ../../../secrets/wg-qbt.yaml;
          owner = "root";
          group = "root";
          mode = "0400";
        };
        sops.secrets."slskd_env" = {
          sopsFile = ../../../secrets/slskd.yaml;
          owner = "root";
          group = "root";
          mode = "0400";
        };
        sops.secrets."tunnel_cred" = {
          sopsFile = ../../../secrets/tunnel.yaml;
          owner = "root";
          group = "root";
          mode = "0400";
        };
        vpnNamespaces."wg-qbt" = {
          enable = true;
          wireguardConfigFile = config.sops.secrets."wireguard_config".path;
          namespaceAddress = "192.168.15.1";
          accessibleFrom = [
            "127.0.0.1"
            "10.0.0.225"
          ];
          portMappings = [
            {
              from = 58080;
              to = 58080;
              protocol = "tcp";
            }
          ];
        };

        security.acme.acceptTerms = true;
        environment.systemPackages = with pkgs; [
          jellyfin
          jellyfin-ffmpeg
          jellyfin-web
          jellyfin-tui

          qbittorrent
          qbittorrent-cli

          cloudflared
        ];

        networking.firewall.allowedTCPPorts = [
          80
          443
          58080
          5030
        ];

        services.nginx = {
          enable = true;
          recommendedProxySettings = true;
          recommendedTlsSettings = true;
          virtualHosts."atlas.volbot.org" = {
            #enableACME = true;
            #forceSSL = true;
            locations."/stream" = {
              proxyPass = "http://localhost:8096";
              proxyWebsockets = true;
              /*
                extraConfig =
                  # required when the target is also TLS server with multiple hosts
                  "proxy_ssl_server_name on;"
                  +
                    # required when the server wants to use HTTP Authentication
                    "proxy_pass_header Authorization;";
              */
            };
            locations."/music" = {
              proxyPass = "http://localhost:4533";
              proxyWebsockets = true;
            };
            locations."/soulseek" = {
              proxyPass = "http://localhost:5030";
              proxyWebsockets = true;
            };
            locations."/sonarr" = {
              proxyPass = "http://localhost:8989";
              proxyWebsockets = true;
            };
            locations."/radarr" = {
              proxyPass = "http://localhost:7878";
              proxyWebsockets = true;
            };
            locations."/prowlarr" = {
              proxyPass = "http://localhost:9696";
              proxyWebsockets = true;
            };
            locations."/bazarr" = {
              proxyPass = "http://localhost:6767";
              proxyWebsockets = true;
            };
            locations."/lidarr" = {
              proxyPass = "http://localhost:8686";
              proxyWebsockets = true;
            };
          };
        };

        services.cloudflared = {
          enable = true;
          tunnels = {
            "14fc4080-e2b1-4328-b111-55ca2b37cab8" = {
              credentialsFile = config.sops.secrets."tunnel_cred".path;
              originRequest.noTLSVerify = true;
              ingress = {
                "atlas.volbot.org" = {
                  service = "http://localhost";
                };
                "qbt.volbot.org" = {
                  service = "http://${config.vpnNamespaces.wg-qbt.namespaceAddress}:58080";
                };
                "request.volbot.org" = {
                  service = "http://10.0.0.225:5055";
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

        services.navidrome = {
          enable = true;
          openFirewall = true;
          settings = {
            BaseURL = "/music";
            Address = "0.0.0.0";
            Port = 4533;
            MusicFolder = "/mnt/media/music";
            EnableSharing = true;
            CoverJpegQuality = 100;
            EnableUserEditing = true;
            ScanExclude = [ "lost+found" ];
            /*
              LastFM.Enabled = true;
              LastFM.ApiKey = "LASTFMKEY";
              LastFM.Secret = "LASTFM SECRET";
              LastFM.Language = "en";
            */
          };
        };

        systemd.services.navidrome.serviceConfig = {
          User = lib.mkForce "allie";
          Group = lib.mkForce "users";
          ProtectHome = lib.mkForce false;
        };

        services.slskd = {
          enable = true;
          openFirewall = true;
          environmentFile = config.sops.secrets."slskd_env".path;
          settings = {
            web.authentication.disabled = false;
            web.url_base = "/soulseek";
            remote_access = true;
          };
        };

        systemd.services.qbittorrent.vpnConfinement = {
          enable = true;
          vpnNamespace = "wg-qbt";
        };

        services.qbittorrent = {
          enable = true;
          openFirewall = false;
          webuiPort = 58080;
          #torrentingPort = 55577;
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
          /*
            settings = {
              server.port = 8989;
            };
          */
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

        services.lidarr = {
          enable = true;
          openFirewall = true;
        };
      }
  );
}
