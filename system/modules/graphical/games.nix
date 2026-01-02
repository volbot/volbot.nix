{
  pkgs,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    protonup-qt
    gamescope-wsi
  ];

  programs.steam = {
    enable = true;
    extraPackages = with pkgs; [
      gamescope
      xwayland-run
      gamescope-wsi
    ];
    extraCompatPackages = with pkgs; [
      proton-ge-bin
    ];
  };

  programs.gamescope = {
    enable = true;
    capSysNice = true;
  };

  programs.gamemode.enable = true;

  programs.mangohud = {
    enable = true;
    settings.preset = 2;
  };
}
