{ profiles, ... }:
{
  atlas.imports = profiles.universal.modules/* ++ profiles.physical.modules*/;

  allomyrina.imports =
    profiles.universal.modules /*++ profiles.physical.modules*/ ++ profiles.personal.modules;

  scarab.imports =
    profiles.universal.modules /*++ profiles.physical.modules*/ /*++ profiles.personal.modules*/;
}
