{
	universal = {pkgs, ...}: {
		system.stateVersion = "25.11";
		nixpkgs.config.allowUnfree = true;
		nix.settings.experimental-features = [ "nix-command" "flakes" ];
		environment.systemPackages = with pkgs; [
			wget
				yazi
		];
	};
}
