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
    ./volbot_dot_org_node2nix_test
#     ./stylix.nix
  ];
  home.packages = with pkgs; [
    lf
      unzip
      yazi
      lazygit
      vesktop
      fastfetch

      pnpm
      nodejs
      node2nix
  ];
}
