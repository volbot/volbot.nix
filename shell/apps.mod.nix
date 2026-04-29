inputs: {
  universal = {
    programs.zoxide = {
      enable = true;
      enableFishIntegration = true;
    };
  };
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
        zoxide
        tmux
      ];

      programs = {
        btop.enable = true;
        btop.settings.theme_background = false;
      };
    };
}
