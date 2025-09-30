{
  pkgs,
    ...
}:
{
  environment.systemPackages = with pkgs; [
      steam
  ];
  programs.steam = {
    enable = true;
    extraPackages = with pkgs; [
      gamescope
        xwayland-run
    ];
    extraCompatPackages = with pkgs; [
      proton-ge-bin
    ];
  };

}
