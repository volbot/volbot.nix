{
  self,
  nixpkgs,
  home-manager,
  nix-appimage,
  flake-parts,
  ...
}@inputs:
let
  # NOTE: setup
  flake-path = "/home/allie/nixos-config";
  stateVersion = "25.11";
  # factor out declaring home manager as a module for configs that do that
  HMasModule =
    { lib, ... }:
    {
      home-manager.backupFileExtension = "hm-bkp";
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.verbose = true;
      services.displayManager.defaultSession = lib.mkDefault "none+fake";
    };
  HMmain =
    module:
    { username, ... }:
    {
      home-manager.users.${username} = module;
    };
in
# NOTE: flake parts definitions
# https://flake.parts/options/flake-parts
# https://devenv.sh/reference/options
flake-parts.lib.mkFlake { inherit inputs; } (
  { config, ... }:
  let
    #overlayList = config.flake.overlist;
    userdata = pkgs: {
      allie = {
        name = "allie";
        shell = pkgs.fish;
        isNormalUser = true;
        description = "";
        extraGroups = [
          "networkmanager"
          "wheel"
          "gamemode"
        ];
        # this is packages for nixOS user config.
        # packages = []; # empty because that is managed by home-manager
      };
    };
  in
  {
    systems = nixpkgs.lib.platforms.all;
    imports = [
      # inputs.flake-parts.flakeModules.easyOverlay
      # inputs.devenv.flakeModule
      # e.g. treefmt-nix.flakeModule
      (nixpkgs.lib.modules.importApply ./common inputs)
    ];
    perSystem =
      let
        flakeCfg = config.flake;
      in
      {
        config,
        self',
        inputs',
        lib,
        pkgs,
        system,
        # final, # Only with easyOverlay imported
        ...
      }:
      {
        _module.args.pkgs = import inputs.nixpkgs {
          inherit system;
          #overlays = overlayList;
          config = {
            allowUnfree = true;
          };
        };

        # overlayAttrs = { outname = config.packages.packagename; }; # Only with easyOverlay imported

        # Make sure the exported wrapper module packages
        # don't get a pkgs with the items already imported
        # This is because we also added our wrapper modules
        # into our overlayList
        /*
        wrapperPkgs = import inputs.nixpkgs {
          inherit system;
          config = {
            allowUnfree = true;
          };
        };
        */
        packages = {
          /*
            inherit (pkgs) dep-tree minesweeper nops manix antifennel gac libvma;
            wezshterm = config.packages.wezterm.wrap {
              withLauncher = lib.mkDefault true;
              wrapZSH = lib.mkDefault true;
            };
          */
        }
        // self.legacyPackages.${system}.homeConfigurations."allie@allomyrina".config.volvim.out.packages;

        /*
            app-images = let
              bundle = nix-appimage.bundlers.${system}.default;
            in {
              minesweeper = bundle pkgs.minesweeper;
            };
        */

        # NOTE: outputs to legacyPackages.${system}.homeConfigurations.<name>
        homeConfigurations =
          let
            defaultSpecialArgs = {
              users = userdata pkgs;
              inherit
                stateVersion
                inputs
                flake-path
                ;
            };
          in
          {
            "allie@allomyrina" = {
              inherit home-manager;
              extraSpecialArgs = defaultSpecialArgs;
              modules = [
                ./homes/allie.nix
                (
                  { pkgs, ... }:
                  {
                    nix.package = pkgs.nix;
                  }
                )
              ];
            };
          };

        # NOTE: outputs to legacyPackages.${system}.nixosConfigurations.<name>
        nixosConfigurations =
          let
            defaultSpecialArgs = {
              users = userdata pkgs;
              inherit
                stateVersion
                inputs
                flake-path
                ;
            };
          in
          {
            "allie@allomyrina" = {
              nixpkgs = inputs.nixpkgs;
              inherit home-manager;
              #disko.diskoModule = flakeCfg.diskoConfigurations.sda_swap;
              specialArgs = defaultSpecialArgs;
              /*
                extraSpecialArgs = {
                  monitorCFG = ./homes/monitors_by_hostname/allomyrina;
                };
              */
              #module.nixpkgs.overlays = overlayList;
              modules = [
                ./systems/PCs/allomyrina
                (HMmain (import ./homes/allie.nix))
                HMasModule
              ];
            };
            "allomyrina" = {
              nixpkgs = inputs.nixpkgs;
              #disko.diskoModule = flakeCfg.diskoConfigurations.sda_swap;
              specialArgs = defaultSpecialArgs;
              #module.nixpkgs.overlays = overlayList;
              modules = [
                ./systems/PCs/allomyrina
              ];
            };
          };
      };
  }
)
