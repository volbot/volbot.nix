{
  config,
  pkgs,
  lib,
  inputs,
  flake-path,
  users,
  username,
  stateVersion,
  monitorCFG,
  osConfig ? null,
  ...
}@args:
let
in
{
  imports = with inputs.self.homeModules; [
    volvim
    floorp
    niri
    theme
    gaming
    fish
    audio
  ];
  volbotMods = {
    floorp.enable = true;
    niri = {
      enable = true;
      background = config.stylix.image;
    };
    audio.enable = true;
    fish.enable = true;
    gaming.enable = true;
    theme.enable = true;
    volvim = {
      enable = true;
      packageNames = [ "volvim" ];
      base16colors = {
        name = "stylix";
        translucent = config.stylix.targets.neovim.transparentBackground.main;
        base16 = pkgs.lib.filterAttrs (
          k: v: builtins.match "base0[0-9A-F]" k != null
        ) config.lib.stylix.colors.withHashtag;
      };
    };
  };
  home.sessionVariables =
    let
      nvimpkg = config.volvim.out.packages.volvim;
      nvimpath = "${nvimpkg}/bin/${nvimpkg.nixCats_packageName}";
    in
    {
      EDITOR = nvimpath;
      MANPAGER = "${nvimpath} +Man!";
      XDG_DATA_DIRS = "$XDG_DATA_DIRS:/usr/share:/var/lib/flatpak/exports/share:$HOME/.local/share/flatpak/exports/share";
      JAVA_HOME = "${pkgs.jdk}";
    };
  nix.settings = {
    # bash-prompt-prefix = "✓";
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    auto-optimise-store = true;
    flake-registry = "";
    show-trace = true;
    extra-trusted-substituters = [
      "https://nix-community.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };
  nix.nixPath = [
    "nixpkgs=${builtins.path { path = inputs.nixpkgs; }}"
  ];
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "-d";
  };

  nix.registry = {
    nixpkgs.flake = inputs.nixpkgs;
    nixCats.flake = inputs.volvim.inputs.nixCats;
    #wrappers.flake = inputs.wrappers;
    home-manager.flake = inputs.home-manager;
    #birdeeSystems.flake = inputs.self;
    gomod2nix.to = {
      type = "github";
      owner = "nix-community";
      repo = "gomod2nix";
    };
  };

  programs.foot.enable = true;

  programs.yazi = {
    enable = true;
    shellWrapperName = "y";
    keymap = {
      mgr.prepend_keymap = [
        # ripdrag (drag-n-drop) capabilities
        {
          on = [ "<C-o>" ];
          run = "shell -- ripdrag --no-click --and-exit --icon-size 64 --target --all \"$@\" | while read filepath; do cp -nR \"$filepath\" .; done";
          #desc = "drag-n-drop files to and from Yazi";
        }
        {
          on = [ "<C-O>" ];
          run = "shell -- ripdrag --no-click --and-exit --icon-size 64 --target --all \"$@\" | while read filepath; do cp -fR \"$filepath\" .; done";
          #desc = "drag-n-drop files to and from Yazi (with clobber)";
        }
      ];
    };
  };

  programs.git = {
    settings = {
      user = {
        name = "allomyrina volbot";
        email = "volbot.tech@gmail.com";
      };
      init.defaultBranch = "main";
    };
  };

  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
  };

  xdg.enable = true;
  xdg.mime.enable = true;
  xdg.mimeApps.enable = true;

  xdg.userDirs = {
    enable = true;
    desktop = "${config.home.homeDirectory}/Desktop";
    documents = "${config.home.homeDirectory}/Documents";
    download = "${config.home.homeDirectory}/Downloads";
    music = "${config.home.homeDirectory}/Music";
    pictures = "${config.home.homeDirectory}/Imagenes";
    publicShare = "${config.home.homeDirectory}/Public";
    templates = "${config.home.homeDirectory}/Templates";
    videos = "${config.home.homeDirectory}/Videos";
    extraConfig = {
      XDG_MISC_DIR = "${config.home.homeDirectory}/Misc";
    };
  };
  xdg.mimeApps.defaultApplications = {
    "inode/directory" = [ "yazi.desktop" ];
    "application/pdf" = [
      "floorp.desktop"
      "gimp.desktop"
    ];
    "image/png" = "gimp.desktop";
    "image/jpeg" = "gimp.desktop";
    "image/webp" = "gimp.desktop";
  };
  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = stateVersion; # Please read the comment before changing.

  home.shell.enableFishIntegration = true;

  home.packages = with pkgs; [
    inputs.font-flake.packages.x86_64-linux.greybeard

    #CLI PROGRAMS
    lf
    yazi
    lazygit
    fastfetch
    jq

    #NETWORK STUFF
    speedtest-cli
    gof5
    wireguard-tools

    #LINUX COMPAT STUFF
    ripdrag
    gnome-tweaks
    libsixel
    slurp
    grim

    thunar

    #GAMING PACKAGES
    prismlauncher
    minecraft-server

    #MULTIMEDIA PACKAGES
    ffmpeg-full
    imagemagick
    pandoc
    pastel
    gpick

    gimp3
    inkscape
    #krita
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

    #DEV STUFF
    pnpm
    nodejs_24

    #GENERAL PURPOSE GRAPHICAL PROGRAMS
    firefox
    chromium
    ladybird

    spotify

    zoom-us

    vesktop

    #FONTS
    freetype

    font-manager

    font-manager
    cooper
    besley

    noto-fonts
    noto-fonts-color-emoji

    liberation_ttf
    aileron
    montserrat

    nerd-fonts.mononoki
    nerd-fonts.fantasque-sans-mono

  ];

  programs.home-manager.enable = true;
}
