{ pkgs, ... }:
{
  home.packages = with pkgs; [
    ffmpeg-full
    imagemagick
#    pandoc

gpick

    gimp3
    inkscape
    krita
    #aseprite
    #libresprite

    (pkgs.wrapOBS {
      plugins = with pkgs.obs-studio-plugins; [
        wlrobs
        obs-pipewire-audio-capture
        obs-gstreamer
        obs-vkcapture
      ];
    })

mesa-demos
vulkan-tools

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
