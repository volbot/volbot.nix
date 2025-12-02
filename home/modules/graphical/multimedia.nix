{ pkgs, ... }:
{
  home.packages = with pkgs; [
    ffmpeg-full
    imagemagick
#    pandoc

    gimp3
    inkscape
    krita
    aseprite
    #libresprite

    vlc

    blender
    unityhub

    libreoffice
  ];
}
