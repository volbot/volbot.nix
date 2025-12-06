{
  pkgs,
  settings,
  ...
}:
{
  imports =
    if settings.hostname == "allomyrina" then
      [
        ./fish
        ./nvim
        ./stylix.nix
        ./yazi.nix
        ./starship
      ]
    else
      [
        ./fish
        ./nvim
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

      speedtest-cli

      gof5
      wireguard-tools

      yazi
      ripdrag

      pnpm
      nodejs_24

pastel
jq
    ];
  };
  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
  };
}
