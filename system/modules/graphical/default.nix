{
  settings, 
    ...
}: {
  imports =
    if settings.hostname == "allomyrina"
      then [
      ./greetd.nix
        ./pipewire.nix
          ./games.nix
      ]
    else [];
}
