{ vpn-confinement, sops-nix, ... }:
{
  atlas =
    {
      lib,
      config,
      pkgs,
      ...
    }:
    let
      qbt_port = 58080;
      sonarr_port = 8989;
      radarr_port = 7878;
      prowlarr_port = 9696;
      bazarr_port = 6767;
      navidrome_port = 4533;
      slskd_port = 5030;
      lidarr_port = 8686;
      seerr_port = 5055;
      jellyfin_port = 8096;
    in
    {
      imports = [
        sops-nix.nixosModules.sops
        vpn-confinement.nixosModules.default
      ];
      sops.secrets."wireguard_config" = { };
      sops.secrets."slskd_env" = { };
      sops.secrets."tunnel_cred" = { };
      sops.secrets."lastfm/api_key" = { };
      sops.secrets."lastfm/secret" = { };
      sops.templates."navidrome.env" = {
        owner = config.services.navidrome.user;
        content = ''
          ND_LASTFM_APIKEY=${config.sops.placeholder."lastfm/api_key"}
          ND_LASTFM_SECRET=${config.sops.placeholder."lastfm/secret"}
        '';
      };

      vpnNamespaces."wg-qbt" = {
        enable = true;
        wireguardConfigFile = config.sops.secrets."wireguard_config".path;
        namespaceAddress = "192.168.15.1";
        accessibleFrom = [
          "127.0.0.1"
          "::1"
        ];
        portMappings = [
          {
            from = 58080;
            to = 58080;
            protocol = "tcp";
          }
        ];
      };

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

      security.acme.acceptTerms = true;
      services.nginx = {
        enable = true;
        recommendedProxySettings = true;
        recommendedTlsSettings = true;
        virtualHosts."atlas.volbot.org" = {
          enableACME = true;
          forceSSL = true;
          locations."/" = {
            return = ''
              						200
              						'<html>
              						<body>
              						<h1>welcome to Atlas</h1>
              						<h2>main links</h2>
              						<h3><a href="./stream">stream</a></h2>
              						<h3><a href="http://request.volbot.org">seerr</a></h2>
              						<h3><a href="./music">music</a></h2>
              						<h3><a href="./soulseek">soulseek</a></h2>
              						<h2>advanced</h2>
              						<h3><a href="http://qbt.volbot.org">qbittorrent</a></h2>
              						<h3><a href="./sonarr">sonarr</a></h2>
              						<h3><a href="./radarr">radarr</a></h2>
              						<h3><a href="./lidarr">lidarr</a></h2>
              						<h3><a href="./prowlarr">prowlarr</a></h2>
              						<h3><a href="./bazarr">bazarr</a></h2>
              						</body>
              						</html>'
              						'';
            extraConfig = ''
              						default_type text/html;
              					'';
          };
          locations."/stream" = {
            proxyPass = "http://localhost:${toString jellyfin_port}";
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
          locations."/seerr" = {
            proxyPass = "http://localhost:${toString seerr_port}";
            proxyWebsockets = true;
            extraConfig = ''
              						set $app 'seerr';

              # Remove /seerr path to pass to the app
              					rewrite ^/seerr/?(.*)$ /$1 break;

              # Redirect location headers
              					proxy_redirect ^ /$app;
              					proxy_redirect /setup /$app/setup;
              					proxy_redirect /login /$app/login;

              # Sub filters to replace hardcoded paths
              					proxy_set_header Accept-Encoding "";
              					sub_filter_once off;
              					sub_filter_types *;
              					sub_filter 'href="/"' 'href="/$app"';
              					sub_filter 'href="/login"' 'href="/$app/login"';
              					sub_filter 'href:"/"' 'href:"/$app"';
              					sub_filter '\/_next' '\/$app\/_next';
              					sub_filter '/_next' '/$app/_next';
              					sub_filter '/api/v1' '/$app/api/v1';
              					sub_filter '/login/plex/loading' '/$app/login/plex/loading';
              					sub_filter '/images/' '/$app/images/';
              					sub_filter '/imageproxy/' '/$app/imageproxy/';
              					sub_filter '/avatarproxy/' '/$app/avatarproxy/';
              					sub_filter '/android-' '/$app/android-';
              					sub_filter '/apple-' '/$app/apple-';
              					sub_filter '/favicon' '/$app/favicon';
              					sub_filter '/logo_' '/$app/logo_';
              					sub_filter '/site.webmanifest' '/$app/site.webmanifest';
              					'';
          };
          locations."/music" = {
            proxyPass = "http://localhost:${toString navidrome_port}";
            proxyWebsockets = true;
          };
          locations."/soulseek" = {
            proxyPass = "http://localhost:${toString slskd_port}";
            proxyWebsockets = true;
          };
          locations."/sonarr" = {
            proxyPass = "http://localhost:${toString sonarr_port}";
            proxyWebsockets = true;
          };
          locations."/radarr" = {
            proxyPass = "http://localhost:${toString radarr_port}";
            proxyWebsockets = true;
          };
          locations."/prowlarr" = {
            proxyPass = "http://localhost:${toString prowlarr_port}";
            proxyWebsockets = true;
          };
          locations."/bazarr" = {
            proxyPass = "http://localhost:${toString bazarr_port}";
            proxyWebsockets = true;
          };
          locations."/lidarr" = {
            proxyPass = "http://localhost:${toString lidarr_port}";
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
                service = "https://localhost";
              };
              "qbt.volbot.org" = {
                service = "http://${config.vpnNamespaces.wg-qbt.namespaceAddress}:${toString qbt_port}";
              };
              "request.volbot.org" = {
                service = "http://127.0.0.1:${toString seerr_port}";
              };
              "ssh.volbot.org" = {
                service = "ssh://127.0.0.1:22";
              };
              "smb.volbot.org" = {
                service = "smb://127.0.0.1";
              };
            };
            default = "http_status:404";
          };
        };
      };

      services.openssh = {
        openFirewall = true;
        settings.Macs = [
          # Current defaults:
          "hmac-sha2-512-etm@openssh.com"
          "hmac-sha2-256-etm@openssh.com"
          "umac-128-etm@openssh.com"
          # Added:
          "hmac-sha2-256"
        ];
      };

      services.navidrome = {
        enable = true;
        openFirewall = true;
        settings = {
          BaseURL = "/music";
          Address = "0.0.0.0";
          Port = navidrome_port;
          MusicFolder = "/mnt/media/music";
          EnableSharing = true;
          CoverJpegQuality = 100;
          EnableUserEditing = true;
          ScanExclude = [ "lost+found" ];
          LastFM.Enabled = true;
          LastFM.Language = "en";
        };
        environmentFile = config.sops.templates."navidrome.env".path;
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
          soulseek = {
            description = ''
              						electronic dance music
              						'';
          };
          remote_access = true;
          shares.directories = [
            "/mnt/media/music/"
          ];
        };
      };

      systemd.services.qbittorrent.vpnConfinement = {
        enable = true;
        vpnNamespace = "wg-qbt";
      };

      services.qbittorrent = {
        enable = true;
        openFirewall = false;
        webuiPort = qbt_port;
      };

      services.jellyfin = {
        enable = true;
        openFirewall = true;
      };

      services.sonarr = {
        enable = true;
        openFirewall = true;
        settings = {
          server.port = sonarr_port;
        };
      };

      services.radarr = {
        enable = true;
        openFirewall = true;
        settings = {
          server.port = radarr_port;
        };
      };

      services.recyclarr = {
        enable = true;
      };

      services.prowlarr = {
        enable = true;
        openFirewall = true;
        settings = {
          server.port = prowlarr_port;
        };
      };

      services.seerr = {
        enable = true;
        openFirewall = true;
        port = seerr_port;
      };

      services.bazarr = {
        enable = true;
        openFirewall = true;
        listenPort = bazarr_port;
      };

      services.lidarr = {
        enable = true;
        openFirewall = true;
        settings = {
          server.port = lidarr_port;
        };
      };

      services.samba = {
        enable = true;
        securityType = "user";
        openFirewall = true;
        settings = {
          global = {
            "workgroup" = "WORKGROUP";
            "server string" = "smbnix";
            "netbios name" = "smbnix";
            "security" = "user";
            #"use sendfile" = "yes";
            #"max protocol" = "smb2";
            # note: localhost is the ipv6 localhost ::1
            "hosts allow" = "10.0.0. 127.0.0.1 localhost";
            "hosts deny" = "0.0.0.0/0";
            "guest account" = "nobody";
            "map to guest" = "bad user";
          };
          "public" = {
            "path" = "/mnt/media/music";
            "browseable" = "yes";
            "read only" = "no";
            "guest ok" = "yes";
            "create mask" = "0644";
            "directory mask" = "0755";
            #"force user" = "username";
            #"force group" = "groupname";
          };
        };
      };

      services.samba-wsdd = {
        enable = true;
        openFirewall = true;
      };

      networking.firewall.enable = true;
      networking.firewall.allowPing = true;
    };
}
