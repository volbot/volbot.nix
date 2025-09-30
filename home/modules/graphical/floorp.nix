{
  inputs,
    pkgs,
    ...
}: {

  programs.floorp = {
    enable = true;
    profiles = {
      allomyrina = {
        extensions = {
          force = true;
          packages = with inputs.firefox-addons.packages.x86_64-linux; [
            firefox-color
              ublock-origin
              sidebery
              vimium
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
          school = {
            id = 2;
            name = "school";
            icon = "fruit";
            color = "yellow";
          };
        };
      };
    };

    policies = {
      FirefoxHome = {
        SponsoredTopSites = false;
        SponsoredPocket = false;
      };
    };
  };

  stylix.targets = {
    floorp = {
      enable = true;
      colorTheme.enable = true;
      profileNames = ["allomyrina"];
    };
  };
}
