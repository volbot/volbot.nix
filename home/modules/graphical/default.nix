{
  settings,
  pkgs,
  ...
}:
{
  imports =
      [
        ./mangohud
        ./wm/niri.nix
        ./floorp.nix
        ./multimedia.nix
        ./games.nix
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

        slurp
        grim

        sublime

        ladybird

        zoom-us

        firefox
        chromium

        gnome-tweaks

        gnome-font-viewer

        cooper
        besley

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
