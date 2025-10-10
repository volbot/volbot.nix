{
  pkgs,
  settings,
  ...
}:
{
  imports =
    if settings.hostname == "allomyrina" then
      [ ]
    else
      [
        #      ./stylix.nix
        ./wsl
        #./volbot_dot_org_node2nix_test
      ];

  environment.systemPackages = with pkgs; [
    git
    wget
    neovim
    dconf
    fish
    pkgs.man-pages
    gnumake
    gcc
  ];

  programs.fish.enable = true;

  documentation.dev.enable = true;
}
