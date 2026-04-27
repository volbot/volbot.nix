{
  description = "my nix system :3";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware.url = "github:NixOS/nixos-hardware";

    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-utils.url = "github:numtide/flake-utils";

    xwayland-satellite-pin.url = "github:NixOS/nixpkgs/2fad6eac6077f03fe109c4d4eb171cf96791faa4";

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    nix-appimage.url = "github:ralismark/nix-appimage";

    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    plugins-rustaceanvim = {
      url = "github:mrcjkb/rustaceanvim";
      flake = false;
    };

    nixpkgs-wayland.url = "github:nix-community/nixpkgs-wayland";
    nixpkgs-wayland.inputs.nixpkgs.follows = "nixpkgs";

    zen-browser.url = "github:0xc000022070/zen-browser-flake";
    zen-browser.inputs.nixpkgs.follows = "nixpkgs";

    niri-flake = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

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

    #textfox.url = "github:adriankarlen/textfox";
    textfox.url = "github:volbot/textfox";

    /*
      font-flake.url = "path:./fonts";
      volvim = {
        url = "path:./nixcats";
        inputs.nixpkgs.follows = "nixpkgs";
        inputs.nixCats.follows = "nixCats";
      };
    */

    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    vpn-confinement.url = "github:Maroka-chan/VPN-Confinement";

    wrappers.url = "github:BirdeeHub/nix-wrapper-modules";
    wrappers.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    raw-inputs:
    let
      inputs = builtins.mapAttrs (
        input-name: raw-input:
        builtins.foldl'
          (
            input: module-class:
            if input ? ${module-class} then
              input
              // {
                ${module-class} = builtins.mapAttrs (
                  module-name:
                  raw-inputs.nixpkgs.lib.setDefaultModuleLocation "${input-name}.${module-class}.${module-name}"
                ) input.${module-class};
              }
            else
              input
          )
          raw-input
          [
            "nixosModules"
            "homeModules"
          ]
      ) raw-inputs;
    in
    let
      inherit (inputs) self nixpkgs;

      inherit (nixpkgs.lib.attrsets) filterAttrs mapAttrs zipAttrs;
      inherit (nixpkgs.lib.strings) hasSuffix;
      inherit (nixpkgs.lib.lists) filter map;

      inherit (nixpkgs.lib.trivial) const toFunction;
      inherit (nixpkgs.lib.filesystem) listFilesRecursive;
      inherit (nixpkgs.lib.modules) setDefaultModuleLocation;

      params = inputs // {
        profiles = raw-configs;
        systems = mapAttrs (const (system: system.config)) configs // {
          # ew what a hack. fix this
          plutonium = configs.iridium.config.containers.plutonium.config;
        };
      };

      # It is important to note, that when adding a new `.mod.nix` file, you need to run `git add` on the file.
      # If you don't, the file will not be included in the flake, and the modules defined within will not be loaded.
      all-modules =
        map (
          path:
          mapAttrs (profile: setDefaultModuleLocation "${path}#${profile}") (toFunction (import path) params)
        ) (filter (hasSuffix ".mod.nix") (listFilesRecursive "${self}"))
        ++ [
          {
            universal.options.id = nixpkgs.lib.mkOption {
              type = nixpkgs.lib.types.int;
            };
          }
          insects
        ];

      insects = {
        # used as an identifier for ip addresses, etc.
        # and this set defines what systems are exported
        scarab.id = 7;
        allomyrina.id = 11;
        atlas.id = 77;
      };

      raw-configs = mapAttrs (const (
        modules:
        nixpkgs.lib.nixosSystem {
          inherit modules;
        }
        // {
          inherit modules; # expose this next to e.g. `config`, `option`, etc.
        }
      )) (zipAttrs all-modules);

      configs = filterAttrs (name: config: insects ? ${name}) raw-configs;

      systems = [
        "x86_64-linux"
        "aarch64-linux" # i don't have such a machine, but might as well make the devtooling in this flake work out of the box.
      ];

      forAllSystems = nixpkgs.lib.genAttrs systems;
    in
    {
      # for use in nix repl
      p = s: builtins.trace "\n\n${s}\n" "---";

      devShells = forAllSystems (
        system:
        import ./shell.nix {
          inherit system;
          flake = self;
        }
      );

      formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.nixfmt-tree);

      nixosConfigurations = configs;

      apps.x86_64-linux = mapAttrs (
        name: script: {
          type = "app";
          program = "${script}";
        }
      );

      # This is useful to rebuild all systems at once, for substitution
      all-systems = nixpkgs.legacyPackages.x86_64-linux.runCommand "all-systems" { } (
        ''
          mkdir $out
        ''
        + (builtins.concatStringsSep "\n" (
          nixpkgs.lib.attrsets.mapAttrsToList (name: config: ''
            ln -s ${config.config.system.build.toplevel} $out/${name}
          '') self.nixosConfigurations
        ))
      );
    };
}
