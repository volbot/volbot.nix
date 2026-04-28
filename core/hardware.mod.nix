{
  nixos-hardware,
  nixos-wsl,
  ...
}:
let
  config = name: system: additional: {
    inherit name;
    value = {
      imports = [
        {
          networking.hostName = name;
          nixpkgs.hostPlatform = system;
        }
      ]
      ++ additional;
    };
  };

  filesystem = fsType: path: device: options: {
    fileSystems.${path} = {
      inherit device fsType;
    }
    // (if options == null then { } else { inherit options; });
  };

  fs.btrfs = filesystem "btrfs";
  fs.ntfs = filesystem "ntfs-3g";
  fs.ext4 = filesystem "ext4";
  fs.vfat = filesystem "vfat";
  swap = device: { swapDevices = [ { inherit device; } ]; };

  cpu = brand: { hardware.cpu.${brand}.updateMicrocode = true; };

  /*
    qemu =
      { modulesPath, ... }:
      {
        imports = [ "${modulesPath}/profiles/qemu-guest.nix" ];
      };
  */
in
{
  universal =
    {
      pkgs,
      lib,
      ...
    }:
    {
      hardware.enableRedistributableFirmware = true;
      networking.useDHCP = lib.mkDefault true;
    };

  personal =
    { pkgs, ... }:
    {
    };
}
# Main PC (untested)
// builtins.listToAttrs [
  (config "allomyrina" "x86_64-linux" [
    (cpu "intel")
    (fs.ext4 "/" "/dev/disk/by-uuid/7b48ae56-21cc-4fa2-8a45-b26f945453b3" null)
    (fs.vfat "/boot" "/dev/disk/by-uuid/5BFE-6EFC" [
      "fmask=0077"
      "dmask=0077"
    ])
    (swap "/dev/disk/by-uuid/9de3a981-268a-44b6-b8b2-71456ff0f825")
    {
      boot.initrd.availableKernelModules = [
        "ata_piix"
        "ohci_pci"
        "ehci_pci"
        "sd_mod"
        "sr_mod"
      ];
      boot.initrd.kernelModules = [ ];
      boot.kernelModules = [ "hid_nintendo" ];
      boot.extraModulePackages = [ ];
      boot.supportedFilesystems = [ "ntfs" ];

      #NVIDIA STUFF
      hardware.graphics.enable = true;
      services.xserver.videoDrivers = [ "nvidia" ];
      hardware.nvidia = {
        modesetting.enable = true;
        powerManagement = {
          enable = false;
          finegrained = false;
        };
        open = true;
        nvidiaSettings = true;

        package = config.boot.kernelPackages.nvidiaPackages.stable;
      };
    }
    #nixos-hardware.nixosModules.common-gpu-amd-southern-islands
  ])
  # WSL for work
  (config "scarab" "x86_64-linux" [
    {
      imports = [
        nixos-wsl.nixosModules.wsl
      ];
      services.dbus.enable = true;
      wsl = {
        enable = true;
        defaultUser = "allie";
        useWindowsDriver = true;
        interop.register = true;
      };
    }
  ])

  # Contabo VPS
  (config "atlas" "x86_64-linux" [
    #qemu
    (fs.ext4 "/" "/dev/sda3" null)
    {
      boot.tmp.cleanOnBoot = true;
      zramSwap.enable = true;
      boot.loader.grub.device = "/dev/sda";
      boot.initrd.availableKernelModules = [
        "ata_piix"
        "uhci_hcd"
        "xen_blkfront"
        "vmw_pvscsi"
      ];
      boot.initrd.kernelModules = [ "nvme" ];
    }
  ])
]
