# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).
# NixOS-WSL specific options are documented on the NixOS-WSL repository:
# https://github.com/nix-community/NixOS-WSL
{
  inputs,
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ../../modules/general
    ../../modules/graphical
  ];
  nix = {
    package = pkgs.nixVersions.stable;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  environment.systemPackages = with pkgs; [
    cifs-utils
    keyutils
  ];
  
  programs.dconf.enable = true;

  programs.fish.enable = true;

  users.users.allie = {
    isNormalUser = true;
    description = "allomyrina volbot";
    extraGroups = ["networkmanager" "wheel"];
    packages = with pkgs; [];
    shell = pkgs.fish;
  };

  services.openssh = {
    enable = true;
  };

  time.timeZone = "America/Detroit";

  system.stateVersion = "25.05";
}
