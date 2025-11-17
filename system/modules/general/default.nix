{
  pkgs,
  settings,
  ...
}:
{
  imports =
    if settings.hostname == "allomyrina" then
      [
      ]
    else
      [
        #      ./stylix.nix
        ./wsl
        #./volbot_dot_org_node2nix_test
      ];

  environment.systemPackages = with pkgs; [
    wget
    neovim
    dconf
    fish
    pkgs.man-pages
    gnumake
    gcc
  ];

  environment.pathsToLink = [
    "/share/applications"
    "/share/xdg-desktop-portal"
  ];

  programs.fish.enable = true;

  documentation.dev.enable = true;

  programs.git = {
    enable = true;
    lfs.enable = true;
  };
}
