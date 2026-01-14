inputs:
let
  inherit (inputs.nixCats) utils;
in
{
  pkgs,
  settings,
  categories,
  name,
  extra,
  mkPlugin,
  ...
}@packageDef:
{

  extraCats = {
    kotlin = [
      [ "java" ]
    ];
  };

  environmentVariables = {
    test = {
      BIRDTVAR = "It worked!";
    };
    general.core = {
      EDITOR = "volvim";
    };
  };
  sharedLibraries = { };
  # https://github.com/NixOS/nixpkgs/blob/master/pkgs/build-support/setup-hooks/make-wrapper.sh
  extraWrapperArgs = { };

  # python.withPackages or lua.withPackages
  # vim.g.python3_host_prog
  # :!nvim-python3
  python3.libraries = {
    python = (
      py: [
        # NOTE: check disabled globally for nvim because they take SO LONG OMG
        (py.debugpy.overrideAttrs {
          doCheck = false;
          doInstallCheck = false;
          pytestCheckPhase = "";
          installCheckPhase = "";
        })
        (py.pylsp-mypy.overrideAttrs {
          doCheck = false;
          doInstallCheck = false;
          pytestCheckPhase = "";
          installCheckPhase = "";
        })
        (py.pyls-isort.overrideAttrs {
          doCheck = false;
          doInstallCheck = false;
          pytestCheckPhase = "";
          installCheckPhase = "";
        })
        # py.python-lsp-server
        # py.python-lsp-black
        (py.pytest.overrideAttrs {
          doCheck = false;
          doInstallCheck = false;
          pytestCheckPhase = "";
          installCheckPhase = "";
        })
        # py.pylint
        # python-lsp-ruff
        # pyls-flake8
        # pylsp-rope
        # yapf
        # autopep8
        # py.google-generativeai
      ]
    );
  };

  # populates $LUA_PATH and $LUA_CPATH
  extraLuaPackages = {
    #fennel = [ (lp: with lp; [ fennel ]) ];
     other = [ (lp: with lp; [ tomlua ]) ];
  };

  lspsAndRuntimeDeps = with pkgs; {
    general = {
      core = [
        universal-ctags
        ripgrep
        fd
        ast-grep
        lazygit
        jq
      ];
    };
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
    java = with pkgs; [
      jdt-language-server
      lombok
      vscode-extensions.vscjava.vscode-java-debug
      vscode-extensions.vscjava.vscode-java-test
    ];
    kotlin = [
      # kotlin-lsp
      kotlin-language-server
      ktlint
    ];
    markdown = [
      marksman
      python311Packages.pylatexenc
      harper
    ];
    rust = with pkgs; [
      inputs.fenix.packages.${stdenv.hostPlatform.system}.latest.toolchain
      rustup
      llvmPackages.bintools
      lldb
    ];
    json = with pkgs; [ nodePackages_latest.vscode-json-languageserver ];
  };

  startupPlugins = with pkgs.vimPlugins; {
    theme = builtins.getAttr (extra.colorscheme or "onedark") {
      "onedark" = onedarkpro-nvim;
      "onedark_dark" = onedarkpro-nvim;
      "onedark_vivid" = onedarkpro-nvim;
      "onelight" = onedarkpro-nvim;
      "catppuccin" = catppuccin-nvim;
      "catppuccin-mocha" = catppuccin-nvim;
      "moonfly" = vim-moonfly-colors;
      "tokyonight" = tokyonight-nvim;
      "tokyonight-day" = tokyonight-nvim;
    };
    general = [
      pkgs.neovimPlugins.lze
      pkgs.neovimPlugins.lzextras
      oil-nvim
      vim-repeat
      pkgs.neovimPlugins.nvim-luaref
      nvim-nio
      nui-nvim
      nvim-web-devicons
      plenary-nvim
      mini-nvim
      pkgs.neovimPlugins.snacks-nvim
      nvim-ts-autotag
      pkgs.neovimPlugins.argmark
    ];
    other = [
      tomlua
      #pkgs.neovimPlugins.shelua
      # (pkgs.neovimUtils.grammarToPlugin (pkgs.tree-sitter-grammars.tree-sitter-nu.overrideAttrs (p: { installQueries = true; })))
    ];
    lua = [
      luvit-meta
      lazydev-nvim
    ];
    rust = [
      pkgs.neovimPlugins.rustaceanvim
    ];
  };

  optionalPlugins = with pkgs.vimPlugins; {
    SQL = [
      vim-dadbod
      vim-dadbod-ui
      vim-dadbod-completion
    ];
    vimagePreview = [
      image-nvim
    ];
    C = [
      vim-cmake
      clangd_extensions-nvim
    ];
    python = [
      nvim-dap-python
    ];
    otter = [
      otter-nvim
    ];
    go = [
      nvim-dap-go
    ];
    fennel = [
      (conjure.overrideAttrs { doCheck = false; })
      cmp-conjure
    ];
    java = [
      nvim-jdtls
    ];
    debug = [
      nvim-dap
      nvim-dap-ui
      nvim-dap-virtual-text
    ];
    other = [
      img-clip-nvim
      nvim-highlight-colors
      which-key-nvim
      eyeliner-nvim
      todo-comments-nvim
      vim-startuptime
      pkgs.neovimPlugins.visual-whitespace
    ];
    markdown = [
      render-markdown-nvim
      markdown-preview-nvim
    ];
    general = with pkgs.neovimPlugins; {
      blink = with pkgs.vimPlugins; [
        luasnip
        cmp-cmdline
        blink-cmp
        blink-compat
        colorful-menu-nvim
      ];
      core = [
        nvim-treesitter-textobjects
        nvim-treesitter.withAllGrammars
        vim-rhubarb
        vim-fugitive
        pkgs.neovimPlugins.nvim-lspconfig
        lualine-lsp-progress
        lualine-nvim
        gitsigns-nvim
        grapple-nvim
        # marks-nvim
        nvim-lint
        conform-nvim
        undotree
        nvim-surround
        treesj
        dial-nvim
        vim-sleuth
        mini-base16
        transparent-nvim
      ];
    };
    /*
    general = with pkgs.vimPlugins; [
        luasnip
        cmp-cmdline
        blink-cmp
        blink-compat
        colorful-menu-nvim

        pkgs.neovimPlugins.nvim-treesitter-textobjects
        pkgs.neovimPlugins.nvim-treesitter.withAllGrammars
        vim-rhubarb
        vim-fugitive
        pkgs.neovimPlugins.nvim-lspconfig
        lualine-lsp-progress
        lualine-nvim
        gitsigns-nvim
        grapple-nvim
        # marks-nvim
        nvim-lint
        conform-nvim
        undotree
        nvim-surround
        treesj
        dial-nvim
        vim-sleuth
        mini-base16
    ];
    */
  };
}
