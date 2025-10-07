{
  pkgs, 
  settings,
    ...
}: {
  imports = if settings.hostname == "allomyrina" then [
    ./fish
      ./nvim
      ./stylix.nix
      ./starship
  ] else [
  ./fish
    ./nvim
    ./stylix.nix
      ./starship
  ];
  home.packages = with pkgs; [
    lf
      unzip
      yazi
      lazygit
      vesktop
      fastfetch
      libsixel

      pnpm
      nodejs_24
  ];
}
