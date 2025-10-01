{
  settings,
    pkgs,
    ...
}: {
  imports =
    if settings.hostname == "allomyrina"
      then [
        ./wm/niri.nix
          ./floorp.nix
          ./multimedia.nix
      ]
    else [
      ./floorp.nix
    ];

  home.packages = if settings.hostname == "allomyrina"
    then with pkgs; [
    kitty
      spotify

      gnome-tweaks

      gnome-font-viewer

      noto-fonts
      noto-fonts-color-emoji

      liberation_ttf
      aileron
      montserrat

      nerd-fonts.mononoki
      nerd-fonts.fantasque-sans-mono

    ] else [];
}
