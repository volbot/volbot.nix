{ moduleNamespace, inputs, ... }:
{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.${moduleNamespace}.floorp;
in
{
  _file = ./default.nix;

  options = {
    ${moduleNamespace}.floorp.enable = lib.mkEnableOption "floorp";
  };

  imports = [ inputs.textfox.homeManagerModules.default ];

  config = lib.mkIf cfg.enable {

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
        wrapTextfox = pkgs.callPackage "${inputs.textfox}/nix/pkgs/wrapTextfox.nix" { };
      in
      {

        enable = true;

        #package = wrapTextfox pkgs.floorp-bin-unwrapped { pname = "floorp"; };
        package = pkgs.floorp-bin;

        profiles = {
          allomyrina = {
            extensions = {
              force = true;
              packages = with inputs.firefox-addons.packages.x86_64-linux; [
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
              school = {
                id = 2;
                name = "school";
                icon = "fruit";
                color = "yellow";
              };
            };

            /*
                    bookmarks = {
                      force = true;
                      settings = [
                        {
                          toolbar = true;
                          bookmarks = [
                            {
                              name = "Canvas";
                              url = "https://sso.mtu.edu/cas/login?service=https%3A%2F%2Fmtu.instructure.com%2Flogin%2Fcas";
                            }
                            {
                              name = "School Calendar";
                              url = "https://calendar.google.com/calendar/u/1/r";
                            }
                          ];
                        }
                      ];
                    };
            */

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

              # new tab page settings
              #"floorp.newtab.configs" =
              #  ''{"components":{"topSites":false,"clock":false,"searchBar":false},"background":{"type":"random","customImage":null,"fileName":null,"folderPath":null,"selectedFloorp":null,"slideshowEnabled":false,"slideshowInterval":30},"searchBar":{"searchEngine":"default"},"topSites":{"pinned":[],"blocked":[]}}'';

              # this is the state of that whole top bar, just copy paste it from
              # about:config after editing it manually, maybe some day i will find a
              # more nixy way? but nixing of the sake of nix is a fools endevour
              #"browser.uiCustomization.state" =
              #  ''{"placements":{"widget-overflow-fixed-list":[],"unified-extensions-area":["sponsorblocker_ajay_app-browser-action","firefoxcolor_mozilla_com-browser-action","_f209234a-76f0-4735-9920-eb62507a54cd_-browser-action","enhancerforyoutube_maximerf_addons_mozilla_org-browser-action","jid1-oy8xu5bskzqa6a_jetpack-browser-action","syrup_extension-browser-action","_2662ff67-b302-4363-95f3-b050218bd72c_-browser-action"],"nav-bar":["back-button","forward-button","vertical-spacer","customizableui-special-spring1","customizableui-special-spring2","vpn_proton_ch-browser-action","clipper_obsidian_md-browser-action","urlbar-container","_446900e4-71c2-419f-a6a7-df9c091e268b_-browser-action","ublock0_raymondhill_net-browser-action","_d07ccf11-c0cd-4938-a265-2a4d6ad01189_-browser-action","_7a7a4a92-a2a0-41d1-9fd7-1e92480d612d_-browser-action","unified-extensions-button","downloads-button"],"toolbar-menubar":["menubar-items"],"TabsToolbar":["tabbrowser-tabs"],"vertical-tabs":[],"PersonalToolbar":["personal-bookmarks"],"nora-statusbar":["screenshot-button","fullscreen-button","status-text"],"statusBar":["screenshot-button","fullscreen-button","status-text"]},"seen":["developer-button","sidebar-reverse-position-toolbar","undo-closed-tab","profile-manager","workspaces-toolbar-button","_446900e4-71c2-419f-a6a7-df9c091e268b_-browser-action","firefoxcolor_mozilla_com-browser-action","ublock0_raymondhill_net-browser-action","_f209234a-76f0-4735-9920-eb62507a54cd_-browser-action","enhancerforyoutube_maximerf_addons_mozilla_org-browser-action","jid1-oy8xu5bskzqa6a_jetpack-browser-action","vpn_proton_ch-browser-action","_7a7a4a92-a2a0-41d1-9fd7-1e92480d612d_-browser-action","_d07ccf11-c0cd-4938-a265-2a4d6ad01189_-browser-action","clipper_obsidian_md-browser-action","sponsorblocker_ajay_app-browser-action","syrup_extension-browser-action","_2662ff67-b302-4363-95f3-b050218bd72c_-browser-action","screenshot-button"],"dirtyAreaCache":["nav-bar","statusBar","TabsToolbar","toolbar-menubar","PersonalToolbar","unified-extensions-area","vertical-tabs","nora-statusbar"],"currentVersion":23,"newElementCount":4}'';
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

    xdg.mimeApps = {
      defaultApplications = {
        "text/html" = "floorp.desktop";
        "application/pdf" = "floorp.desktop";
        "x-scheme-handler/http" = "floorp.desktop";
        "x-scheme-handler/https" = "floorp.desktop";
        "x-scheme-handler/about" = "floorp.desktop";
        "x-scheme-handler/unknown" = "floorp.desktop";
      };
    };
  };
}
