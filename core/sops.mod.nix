{ sops-nix, ... }:
{
  universal =
    { pkgs, config, ... }:
    {
      imports = [ sops-nix.nixosModules.sops ];
      sops.age.sshKeyPaths =
                                /*
        if config.environment.persistence."/nix/persist".enable then
          # secrets are decrypted *before* persistence kicks in
          [ "/nix/persist/etc/ssh/ssh_host_ed25519_key" ]
        else
                                        */
          [ "/etc/ssh/ssh_host_ed25519_key" ];
      sops.defaultSopsFormat = "yaml";
      environment.systemPackages = [ pkgs.sops ];
    };

  scarab.sops.defaultSopsFile = ./secrets/scarab.yaml;
  allomyrina.sops.defaultSopsFile = ./secrets/allomyrina.yaml;
  atlas.sops.defaultSopsFile = ./secrets/atlas.yaml;
}
