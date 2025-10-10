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
      unzip
      lazygit
      vesktop
      fastfetch
      libsixel

      yazi
      ripdrag

      pnpm
      nodejs_24
    ];
  };
}
