{
  universal = {
    home-shortcut =
      { pkgs, lib, ... }:
      {
        programs.micro.enable = true;
        home.packages = with pkgs; [
          vim
          neovim
          kakoune
        ];

        programs.helix = {
          enable = true;
          settings = {
            theme = "catppuccin_mocha_transparent";
            editor = {
              true-color = true;
            };
          };
          languages.language = [
            {
              name = "nix";
              auto-format = true;
              formatter.command = lib.getExe pkgs.nixfmt-rfc-style;
            }
          ];
          themes = {
            catppuccin_mocha_transparent = {
              "inherits" = "catppuccin_mocha";
              "ui.background" = { };
            };
          };
        };
      };
  };
}
