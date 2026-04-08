# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{
  config,
  pkgs,
  inputs,
  ...
}:

{
  imports = with inputs.self.nixosModules; [
        inputs.nixos-wsl.nixosModules.wsl
	../WSL.nix
  ];

/*
  volbotMods = {

  };
  */

  wsl = {
    enable = true;
    defaultUser = "allie";
    useWindowsDriver = true;
    interop.register = true;
  };

  hardware.enableRedistributableFirmware = true;

  security.polkit.enable = true;

  programs.dconf.enable = true;

  # networking.hostName = "allomyrina";

  boot.kernelPackages = pkgs.linuxPackages_latest;

  services.openssh = {
    enable = true;
    settings = {
      X11Forwarding = true;
      PermitRootLogin = "no";
      PasswordAuthentication = false;
    };
    openFirewall = true;
  };
}
