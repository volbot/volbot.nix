{
	universal = {pkgs, ...}: {
		services.openssh = {
			enable = true;
			settings = {
				AuthenticationMethods = "publickey";
				PermitRootLogin = "no";
				PasswordAuthentication = false;
				KbdInteractiveAuthentication = false;
			};

			authorizedKeysInHomedir = false;
		};

		programs.gnupg.agent = {
			enable = true;
			pinentryPackage = pkgs.pinentry-curses;
			enableSSHSupport = true;
		};
	};
}
