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
    else [];

  home.packages = if settings.hostname == "allomyrina"
    then with pkgs; [
    kitty
      spotify

      gnome-tweaks

      noto-fonts
      noto-fonts-color-emoji
      nerd-fonts.mononoki
      nerd-fonts.fantasque-sans-mono

      gnome-font-viewer
    ] else [];
}
