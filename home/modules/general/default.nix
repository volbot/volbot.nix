{
  pkgs, 
  settings,
    ...
}: {
  imports = if settings.hostname == "allomyrina" then [
    ./fish
      ./nvim
      ./stylix.nix
  ] else [
  ./fish
    ./nvim
    ./stylix.nix
  ];
  home.packages = with pkgs; [
    lf
      unzip
      yazi
      lazygit
      vesktop
      fastfetch

      pnpm
      nodejs_24
  ];
}
