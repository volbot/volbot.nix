{
  description = "font management flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    nixCats.url = "github:BirdeeHub/nixCats-nvim";

    tomlua = {
      # url = "git+file:/home/birdee/Projects/tomlua";
      url = "github:BirdeeHub/tomlua";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # nixCats.url = "git+file:/home/birdee/Projects/nixCats-nvim";
    # neovim-src = { url = "github:BirdeeHub/neovim/pack_add_spec_passthru"; flake = false; };
    plugins-argmark = {
      url = "github:BirdeeHub/argmark";
      # url = "git+file:/home/birdee/Projects/argmark";
      flake = false;
    };
    plugins-lze = {
      url = "github:BirdeeHub/lze";
      # url = "git+file:/home/birdee/Projects/lze";
      flake = false;
    };
    plugins-lzextras = {
      url = "github:BirdeeHub/lzextras";
      # url = "git+file:/home/birdee/Projects/lzextras";
      flake = false;
    };
    "plugins-nvim-lspconfig" = {
      url = "github:neovim/nvim-lspconfig";
      flake = false;
    };
    "plugins-nvim-luaref" = {
      url = "github:milisims/nvim-luaref";
      flake = false;
    };

    "plugins-snacks.nvim" = {
      url = "github:folke/snacks.nvim";
      # url = "git+file:/home/birdee/Projects/snacks.nvim";
      flake = false;
    };

    neovim-nightly-overlay = {
      url = "github:nix-community/neovim-nightly-overlay";
      # inputs.neovim-src.follows = "neovim-src";
      # inputs.nixpkgs.follows = "nixpkgs";
    };
    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    plugins-rustaceanvim = {
      url = "github:mrcjkb/rustaceanvim";
      flake = false;
    };
  };

  # see :help nixCats.flake.outputs
  outputs =
    {
      self,
      nixpkgs,
      nixCats,
      ...
    }@inputs:
    let
      inherit (nixCats) utils;
      luaPath = ./.;
      forEachSystem = utils.eachSystem nixpkgs.lib.platforms.all;
      extra_pkg_config = {
        allowUnfree = true;
        doCheck = false; # <- seriously, python stuff runs 10 years of tests its not worth it.
      };
      enable = true;
      dependencyOverlays = import ./misc_nix/overlays inputs;
      categoryDefinitions = import ./cats.nix inputs;
      packageDefinitions = import ./nvims.nix inputs;
      defaultPackageName = "volvim";

      module_args = {
        moduleNamespace = [ defaultPackageName ];
        inherit
          nixpkgs
          defaultPackageName
          dependencyOverlays
          luaPath
          categoryDefinitions
          packageDefinitions
          ;
      };
      nixosModule = utils.mkNixosModules module_args;
      homeModule = utils.mkHomeModules module_args;
      overlays = utils.makeOverlaysWithMultiDefault luaPath {
        inherit nixpkgs dependencyOverlays extra_pkg_config;
      } categoryDefinitions packageDefinitions defaultPackageName;
    in
    forEachSystem (
      system:
      let
        nixCatsBuilder = utils.baseBuilder luaPath {
          inherit
            nixpkgs
            system
            dependencyOverlays
            extra_pkg_config
            ;
        } categoryDefinitions packageDefinitions;
        defaultPackage = nixCatsBuilder defaultPackageName;
      in
      {
        packages = utils.mkAllWithDefault defaultPackage;
        # legacyPackages = utils.mkAllWithDefault (defaultPackage.overrideAttrs { nativeBuildInputs = [ (inputs.nixpkgs.legacyPackages.${system}.callPackage inputs.makeBinWrap {}) ];});
        app-images =
          let
            bundler = inputs.nix-appimage.bundlers.${system}.default;
          in
          {
            portableVim = bundler (nixCatsBuilder "portableVim");
          };
      }
    )
    // {
      inherit
        utils
        overlays
        nixosModule
        homeModule
        ;
      nixosModules.default = nixosModule;
      homeModules.default = homeModule;
    };
}
