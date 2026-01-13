{
  pkgs,
  ...
}:
{
  imports =
      [
        ./fish
        ./stylix.nix
        ./yazi.nix
        ./starship
      ];
  home = {
    shell.enableFishIntegration = true;
    packages = with pkgs; [
      lf
      zip
      unzip
      lazygit
      vesktop
      fastfetch
      libsixel

      zoxide
      file

      speedtest-cli

      gof5
      wireguard-tools

      yazi
      ripdrag

      pnpm
      nodejs_24

      pandoc

pastel
jq
    ];
  };
  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
  };
}
