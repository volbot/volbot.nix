{
  pkgs, 
    ...
}: {
  imports = [
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
  ];
}
