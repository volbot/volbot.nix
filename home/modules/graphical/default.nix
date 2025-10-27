{
  settings,
  pkgs,
  ...
}:
{
  imports =
    if settings.hostname == "allomyrina" then
      [
        ./wm/niri.nix
        ./floorp.nix
        ./multimedia.nix
      ]
    else
      [
        ./floorp.nix
      ];

  home.packages =
    if settings.hostname == "allomyrina" then
      with pkgs;
      [
        spotify

        #TODO: integrate the next 3 lines into a single pipewire module
        qpwgraph
        helvum
        pavucontrol

        chromium

        gnome-tweaks

        gnome-font-viewer

        noto-fonts
        noto-fonts-color-emoji

        liberation_ttf
        aileron
        montserrat

        nerd-fonts.mononoki
        nerd-fonts.fantasque-sans-mono

      ]
    else
      [ ];

  xdg = {
    mime.enable = true;
    mimeApps.enable = true;
  };
}
