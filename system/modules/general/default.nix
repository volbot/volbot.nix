{
settings,
...
}: {
  imports =
    if settings.hostname == "allomyrina"
    then []
    else [
      ./wsl
    ];
}
