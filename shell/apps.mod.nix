inputs: {
  universal.home-shortcut =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        fastfetch
        fm-go
        dig
        whois
        libqalculate
cloudflared
      ];

      programs = {
        btop.enable = true;
        btop.settings.theme_background = false;
      };
    };
}
