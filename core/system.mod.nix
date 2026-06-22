{
	universal = {pkgs, ...}: {
		system.stateVersion = "23.11";
		nixpkgs.config.allowUnfree = true;
		nix.settings.experimental-features = [ "nix-command" "flakes" ];
		environment.systemPackages = with pkgs; [
			wget
				yazi
		];
	};
}
