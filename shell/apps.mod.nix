inputs: {
  universal = {
    programs.zoxide = {
      enable = true;
      enableFishIntegration = true;
    };

      nixpkgs.overlays = [
        (final: prev: {
	spek-cli = final.callPackage ../spek-cli { };
        })
      ];

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
	cifs-utils
        zoxide
        tmux
	pnpm
	nodejs
        unzip
	spek-cli
      ];

      programs = {
        btop.enable = true;
        btop.settings.theme_background = false;
      };
    };
}
