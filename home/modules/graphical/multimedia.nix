{ pkgs, ... }:
{
  home.packages = with pkgs; [
    #ffmpeg-full
      #imagemagick
      #pandoc

      #gimp3
      #krita
      #vlc
  ];
}
