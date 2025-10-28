{
  inputs,
    ...
}: {
  imports = [
    inputs.nixos-wsl.nixosModules.wsl
    ./wsl_openssh_passthrough.nix
  ];

  wsl = {
    enable = true;
    defaultUser = "allie";
    useWindowsDriver = true;
    interop.register = true;
  };
}
