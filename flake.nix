{
  description = "my nix system :3";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";

    home-manager.url = "github:nix-community/home-manager";

    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-utils.url = "github:numtide/flake-utils";
    flake-parts.url = "github:hercules-ci/flake-parts";
    nix-appimage.url = "github:ralismark/nix-appimage";

    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    plugins-rustaceanvim = {
      url = "github:mrcjkb/rustaceanvim";
      flake = false;
    };

    niri.url = "github:sodiboo/niri-flake";

    nixCats.url = "github:BirdeeHub/nixCats-nvim";

    nix-ld = {
      url = "github:Mic92/nix-ld";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    firefox-addons.url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";

    "plugins-voltrix-nvim" = {
      url = "github:volbot/voltrix.nvim";
      flake = false;
    };

    miku-cursor = {
      url = "github:supermariofps/hatsune-miku-windows-linux-cursors";
      flake = false;
    };

    voltrix = {
      url = "github:volbot/voltrix";
      flake = false;
    };

    fish-ssh-agent = {
      url = "gitlab:kyb/fish_ssh_agent";
      flake = false;
    };

    textfox.url = "github:adriankarlen/textfox";

    font-flake.url = "path:./fonts";
    volvim.url = "path:./nixcats";

    wrappers.url = "github:BirdeeHub/nix-wrapper-modules";
    wrappers.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs: import ./. inputs;
}
