{
	inputs,
		pkgs,
		settings,
		...
}: {
	imports = [
		../../modules/general
			../../modules/graphical
	];

	home = {
		username = "allie";
		homeDirectory = "/home/allie";
		stateVersion = "25.05";

		preferXdgDirectories = true;
		shell.enableFishIntegration = true;
	};

	programs.home-manager.enable = true;

	programs.foot.enable = true;


	programs.git = {
		userName = "volbot";
		userEmail = "volbot.tech@gmail.com";
	};

	xdg = {
		enable = true;
		userDirs = {
			enable = true;
			download = "$HOME/Downloads";
			documents = "$HOME/Documents";
			pictures = "$HOME/Media/Imagenes";
			videos = "$HOME/Media/Videos";
			music = "$HOME/Media/Music";
			publicShare = "$HOME/Public";
		};
	};
}
