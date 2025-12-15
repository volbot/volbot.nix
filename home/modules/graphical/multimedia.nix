{ pkgs, ... }:
{
  home.packages = with pkgs; [
    ffmpeg-full
    imagemagick
    pandoc

    gimp3
    inkscape
    krita
    aseprite
    #libresprite

    (pkgs.wrapOBS {
      plugins = with pkgs.obs-studio-plugins; [
        wlrobs
        obs-pipewire-audio-capture
        obs-gstreamer
        obs-vkcapture
      ];
    })

    vlc
    audacity
    reaper

    blender
    unityhub

    libreoffice
  ];

  xdg.mimeApps = {
    defaultApplications = {
      "image/png" = "gimp.desktop";
      "image/jpeg" = "gimp.desktop";
      "image/webp" = "gimp.desktop";
    };
  };
}
