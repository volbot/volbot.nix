{
  pkgs, 
    ...
}: {
  imports = [
    ./fish
      ./nvim
      ./stylix.nix
      ./rice.nix
  ];
  home.packages = with pkgs; [
    lf
      unzip
      yazi
      lazygit
      vesktop
  ];
}
