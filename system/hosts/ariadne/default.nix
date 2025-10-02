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
    git
    wget
    neovim
    fish
    cifs-utils
    keyutils
  ];

  programs.fish.enable = true;

  users.users.alli = {
    isNormalUser = true;
    description = "allomyrina volbot";
    extraGroups = ["networkmanager" "wheel"];
    packages = with pkgs; [];
    shell = pkgs.fish;
  };

  services.openssh = {
    enable = true;
  };

  system.stateVersion = "25.05";
}
