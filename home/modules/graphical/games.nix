{
  settings,
  pkgs,
  ...
}:
{

  home.packages = with pkgs; [
    prismlauncher
    minecraft-server
  ];
}
