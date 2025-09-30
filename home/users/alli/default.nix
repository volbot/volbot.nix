{
  inputs,
  pkgs,
  settings,
  ...
}: {
  imports = [
    ../../modules/general
    ../../modules/graphical
  ];

  home = {
    username = "alli";
    homeDirectory = "/home/alli";
    stateVersion = "25.05";

    preferXdgDirectories = true;
    shell.enableFishIntegration = true;
  };

  programs.home-manager.enable = true;

  programs.foot.enable = true;

  xdg = {
    enable = true;
    userDirs = {
      enable = true;
      download = "$HOME/Downloads";
      documents = "$HOME/Documents";
      pictures = "$HOME/Media/Imagenes";
      videos = "$HOME/Media/Videos";
      music = "$HOME/Media/Music";
      publicShare = "$HOME/Public";
    };
  };
}
