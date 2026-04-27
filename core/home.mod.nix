{ home-manager, ... }:
{
  universal =
    {
      config,
      lib,
      ...
    }:
    {
      imports = [ home-manager.nixosModules.home-manager ];

      options.home-shortcut = lib.mkOption {
        description = ''
          This is a shortcut to `home-manager.users.allie`.

          It is only used for brevity throughout the configuration, and so that my username is not hardcoded absolutely everywhere.
        '';

        type = lib.mkOptionType {
          name = "home-manager module";
          check = _: true;
          merge =
            loc:
            map (def: {
              _file = def.file;
              imports = [ def.value ];
            });
        };
      };

      config = {
        users.mutableUsers = false;
        sops.secrets."user/allie/password".neededForUsers = true;
        users.users.allie = {
          isNormalUser = true;
          description = "allie";
          extraGroups = [ "wheel" ];
          hashedPasswordFile = config.sops.secrets."user/allie/password".path;
        };

        home-manager.backupFileExtension = "bak";
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.users.allie = {
          home.username = "allie";
          home.homeDirectory = "/home/allie";

          home.stateVersion = "22.11";
          imports = config.home-shortcut;
        };
      };
    };
}
