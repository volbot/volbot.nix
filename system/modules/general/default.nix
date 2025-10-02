{
settings,
...
}: {
  imports =
    if settings.hostname == "allomyrina"
    then []
    else [
      ./stylix.nix
      ./wsl
    ];
}
