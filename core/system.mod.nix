{
  universal = {
    system.stateVersion = "23.11";
    nixpkgs.config.allowUnfree = true;
                 environment.pathsToLink = [ "/share/applications" "/share/xdg-desktop-portal" ];
  };
}
