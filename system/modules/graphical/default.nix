{
  settings, 
    ...
}: {
  imports =
    if settings.hostname == "allomyrina"
      then [
      ./greetd.nix
        ./pipewire.nix
        ./nvidia.nix
          ./games.nix
      ]
    else [];
}
