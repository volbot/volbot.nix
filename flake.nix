{
  description = "nixos flake :3";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";

    home-manager.url = "github:nix-community/home-manager";

    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

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
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      home-manager,
      nix-ld,
      ...
    }:
    let
      hosts = [
        {
          hostname = "allomyrina";
          usernames = [ "allie" ];
          system = "x86_64-linux";
        }
        {
          hostname = "ariadne";
          usernames = [ "allie" ];
          system = "x86_64-linux";
        }
      ];

      mapListToAttrs = list: f: builtins.listToAttrs (map f list);
    in
    {
      nixosConfigurations = mapListToAttrs hosts (
        settings@{
          hostname,
          usernames,
          system,
        }:
        let
          lib = nixpkgs.lib.extend (
            _: _: {
              mine =
                import ./lib {
                  inherit (nixpkgs) lib;
                  inherit inputs system;
                }
                // {
                  inherit mapListToAttrs;
                };
            }
          );
          specialArgs = { inherit inputs settings; };
        in
        lib.nameValuePair hostname (
          lib.nixosSystem {
            inherit specialArgs system;
            modules = [
              ./system/hosts/${hostname}
              #import ./overlays
              home-manager.nixosModules.default

              nix-ld.nixosModules.nix-ld

              # The module in this repository defines a new module under (programs.nix-ld.dev) instead of (programs.nix-ld)
              # to not collide with the nixpkgs version.
              { programs.nix-ld.dev.enable = true; }

              {
                home-manager = {
                  useGlobalPkgs = true;
                  useUserPackages = true;
                  extraSpecialArgs = specialArgs;
                  users = mapListToAttrs usernames (uname: lib.nameValuePair uname (import ./home/users/${uname}));
                };
              }
            ];
          }
        )
      );
    };
}
