{
  config,
  lib,
  inputs,
  ...
}:
let
  utils = inputs.nixCats.utils;
  cfg = config.modules.editors.nixCats;
in
{
  imports = [
    inputs.nixCats.homeModule
  ];
  config = {
    stylix.targets.neovim.transparentBackground.main = true;
    home.sessionVariables = {
      EDITOR = "volvim";
    };
    nixCats = {
      enable = true;
      addOverlays =
        # (import ./overlays inputs) ++
        [
          (utils.standardPluginOverlay inputs)
        ];
      packageNames = [ "volvim" ];

      luaPath = "${./.}";

      categoryDefinitions.replace =
        {
          pkgs,
          settings,
          categories,
          extra,
          name,
          mkPlugin,
          ...
        }@packageDef:
        {
          lspsAndRuntimeDeps = {
            general = with pkgs; [
              lazygit
              universal-ctags
            ];
            lua = with pkgs; [
              lua-language-server
              luajitPackages.luacheck
              stylua
            ];
            nix = with pkgs; [
              nixd
              #alejandra
              nixfmt-rfc-style
              statix
              nix-doc
            ];
            c = with pkgs; [
              clang-tools
            ];
            cs = with pkgs; [
              omnisharp-roslyn
              csharpier
            ];
            html = with pkgs; [
              htmlhint
              rubyPackages_3_4.htmlbeautifier
              htmx-lsp
              vscode-langservers-extracted
              svelte-language-server
            ];
            css = with pkgs; [
              stylelint
              prettierd
              rustywind
              tailwindcss-language-server
            ];
            toml = with pkgs; [ taplo ];
            typescript = with pkgs; [
              typescript-language-server
              eslint
            ];
            python = with pkgs; [
              isort
              black
              pyright
            ];
            yaml = with pkgs; [
              yamlfmt
              yamllint
              yaml-language-server
            ];
            go = with pkgs; [
              gopls
              delve
              golangci-lint
              gotools
              go-tools
              gotestsum
              go
            ];
            json = with pkgs; [ nodePackages_latest.vscode-json-languageserver ];
          };

          startupPlugins = {
            general = with pkgs.vimPlugins; [
              lze
              lzextras
              snacks-nvim
              onedark-nvim
              vim-sleuth
            ];
          };

          optionalPlugins = {
            go = with pkgs.vimPlugins; [
              nvim-dap-go
            ];
            lua = with pkgs.vimPlugins; [
              lazydev-nvim
            ];
            general = with pkgs.vimPlugins; [
              mini-nvim
              mini-base16
              transparent-nvim
              nvim-lspconfig
              vim-startuptime
              blink-cmp
              nvim-treesitter.withAllGrammars
              lualine-nvim
              lualine-lsp-progress
              gitsigns-nvim
              which-key-nvim
              nvim-lint
              conform-nvim
              nvim-dap
              nvim-dap-ui
              nvim-dap-virtual-text
            ];
          };

          sharedLibraries = {
            general = with pkgs; [ ];
          };

          environmentVariables = {
            general.core = {
              EDITOR = "volvim";
            };
          };

          python3.libraries = {
          };

          # If you know what these are, you can provide custom ones by category here.
          # If you dont, check this link out:
          # https://github.com/NixOS/nixpkgs/blob/master/pkgs/build-support/setup-hooks/make-wrapper.sh
          extraWrapperArgs = {
            # test = [
            #   '' --set CATTESTVAR2 "It worked again!"''
            # ];
          };
        };

      packageDefinitions.replace = {
        volvim =
          {
            pkgs,
            name,
            ...
          }:
          {
            settings = {
              suffix-path = true;
              suffix-LD = true;
              wrapRc = true;
              aliases = [
                "nvim"
                "vim"
                "homeVim"
              ];
              hosts.python3.enable = true;
              hosts.node.enable = true;
            };
            # and a set of categories that you want
            # (and other information to pass to lua)
            # and a set of categories that you want
            categories = {
              general = true;

              c = true;
              cs = true;
              css = true;
              html = true;
              json = true;
              ts = true;
              typescript = true;
              toml = true;
              yaml = true;
              python = true;
              lua = true;
              nix = true;
              go = true;

              debug = true;
              editor = true;
              format = true;
              ui = true;
              git = true;
              lint = true;
            };
            extra = {
              nixExtras.nixpkgs = ''import ${pkgs.path} {}'';
              base16colors = {
                name = "stylix";
                translucent = config.stylix.targets.neovim.transparentBackground.main;
                base16 = pkgs.lib.filterAttrs (
                  k: v: builtins.match "base0[0-9A-F]" k != null
                ) config.lib.stylix.colors.withHashtag;
              };
            };
          };
      };
    };
  };
}
