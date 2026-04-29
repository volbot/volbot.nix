{
  universal =
    { pkgs, ... }:
    {
      services.openssh = {
        enable = true;
        settings = {
          AuthenticationMethods = "publickey";
          PermitRootLogin = "no";
          PasswordAuthentication = true;
          X11Forwarding = true;
        };
      };

      programs.gnupg.agent = {
        enable = true;
        pinentryPackage = pkgs.pinentry-curses;
        enableSSHSupport = true;
      };
    };
}
