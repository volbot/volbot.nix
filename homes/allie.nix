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
		./allie_minimal.nix
			floorp
			niri
			theme
			gaming
			audio
			#volvim
	];
	volbotMods = {
		floorp.enable = true;
		niri = {
			enable = true;
			background = config.stylix.image;
		};
		audio.enable = true;
		gaming.enable = true;
		theme.enable = true;
		/*
		volvim.base16colors = {
			name = "stylix";
			translucent = config.stylix.targets.neovim.transparentBackground.main;
			base16 = pkgs.lib.filterAttr (
					k: v: builtins.match "base0[0-9A-F]" k!= null
					) config.lib.stylix.colors.withHashtag;
		};
		*/

	};

	programs.foot.enable = true;

	home.packages = with pkgs; [

		thunar

#GAMING PACKAGES
			prismlauncher
			minecraft-server

#MULTIMEDIA PACKAGES
			ffmpeg-full
			imagemagick
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

#GENERAL PURPOSE GRAPHICAL PROGRAMS
		firefox
		chromium
		ladybird

		spotify

		zoom-us

		vesktop

		nicotine-plus

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
}
