{
  universal = {
    services.openssh = {
      enable = true;
      settings = {
        AuthenticationMethods = "publickey";
        PermitRootLogin = "no";
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
      };

      authorizedKeysInHomedir = false;
    };
  };
}
