{ firefox-addons, textfox, ... }:
{
  personal.home-shortcut =
    { pkgs, ... }:
    {
      imports = [ textfox.homeManagerModules.default ];

      /*
        textfox = {
          enable = true;
          profiles = [ "allomyrina" ];
          config = {
            displayNavButtons = true;
            bookmarks = {
              alignment = "left";
            };
            tabs = {
              vertical.enable = true;
            };
          };
        };
      */

      home.packages = with pkgs; [
        pywalfox-native
      ];

      programs.floorp =
        let
          wrapTextfox = pkgs.callPackage "${textfox}/nix/pkgs/wrapTextfox.nix" { };
        in
        {

          enable = true;

          #package = wrapTextfox pkgs.floorp-bin-unwrapped { pname = "floorp"; };
          package = pkgs.floorp-bin;

          profiles = {
            allomyrina = {
              extensions = {
                force = true;
                packages = with firefox-addons.packages.x86_64-linux; [
                  firefox-color
                  ublock-origin
                  sidebery
                  vimium
                  tabliss
                  pywalfox
                ];
              };

              containersForce = true;
              containers = {
                general = {
                  id = 1;
                  name = "general";
                  icon = "chill";
                  color = "toolbar";
                };
              };

              settings = {
                #automatically enable extensions
                "extensions.autoDisableScopes" = 0;

                "browser.tabs.loadInBackground" = true;
                #"startup.homepage_override_url" = "";

                # enable scrolling using the middle mouse button
                "general.autoScroll" = true;

                # vertical tabs
                "floorp.tabbar.style" = 2;
                "sidebar.verticalTabs" = true;

                #remove close button
                "browser.tabs.inTitlebar" = 0;
              };
            };
          };

          policies = {
            DisableTelemetry = true;
            DisableProfileImport = true;
            FirefoxHome = {
              SponsoredTopSites = false;
              SponsoredPocket = false;
            };
          };
        };

      #stylix.targets.floorp.profileNames = [ "allomyrina" ];
    };
}
