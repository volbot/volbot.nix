inputs:
let
  inherit (inputs.nixCats) utils;
  volvim_settings =
    { pkgs, name, ... }@misc:
    {
      # so that it finds my ai auths in ~/.cache/volvim
      extraName = "volvim";
      configDirName = "volvim";
      wrapRc = true;
      useBinaryWrapper = true;
      hosts.node.enable = true;
      hosts.python3.enable = true;
      hosts.python3.path = depfn: {
        value =
          ((pkgs.python3.withPackages (p: depfn p ++ [ p.pynvim ])).overrideAttrs {
            doCheck = false;
            doInstallCheck = false;
            pytestCheckPhase = "";
            installCheckPhase = "";
          }).interpreter;
        args = [
          "--unset"
          "PYTHONPATH"
        ];
      };
      /*
        hosts.perl.enable = false;
        hosts.ruby.enable = true;
        hosts.ruby.path =
          let
            rubyEnv = pkgs.bundlerEnv {
              name = "neovim-ruby-env";
              postBuild = "ln -sf ${pkgs.ruby}/bin/* $out/bin";
              gemdir = ./misc_nix/ruby_provider;
            };
          in
          {
            value = "${rubyEnv}/bin/neovim-ruby-host";
            nvimArgs = [
              "--set"
              "GEM_HOME"
              "${rubyEnv}/${rubyEnv.ruby.gemPath}"
              "--suffix"
              "PATH"
              ":"
              "${rubyEnv}/bin"
            ];
          };
      */
      unwrappedCfgPath = utils.n2l.types.inline-unsafe.mk {
        body = /* lua */ ''(os.getenv("HOME") or "/home/allie") .. "/.volvim"'';
      };
      # moduleNamespace = [ defaultPackageName ];
      /*
        hosts.neovide.path = {
          value = "${pkgs.neovide}/bin/neovide";
          args = [
            "--add-flags"
            "--neovim-bin ${placeholder "out"}/bin/${name}"
          ];
        };
      */
    };
  volvim_categories =
    { pkgs, ... }@misc:
    {
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
      rust = true;
      java = true;
      markdown = true;

      debug = true;
      editor = true;
      format = true;
      ui = true;
      git = true;
      lint = true;

other = true;
    };
  volvim_extra =
    { pkgs, ... }@misc:
    {
      colorscheme = "moonfly";
      javaExtras = {

        #jdtls = "${pkgs.jdt-language-server}/share/java/jdtls";
        #lombok = "${pkgs.lombok}/share/java/lombok.jar";
        java-debug_adapter = "${pkgs.vscode-extensions.vscjava.vscode-java-debug}/share/vscode/extensions/vscjava.vscode-java-debug";
        java-test = "${pkgs.vscode-extensions.vscjava.vscode-java-test}/share/vscode/extensions/vscjava.vscode-java-test";
        gradle-ls = pkgs.vscode-extensions.vscjava.vscode-gradle;
      };

      nixExtras.nixpkgs = ''import ${pkgs.path} {}'';
      nixdExtras = {
        nixpkgs = "import ${builtins.path { path = pkgs.path; }} {}";
        get_configs = utils.n2l.types.function-unsafe.mk {
          args = [
            "type"
            "path"
          ];
          body = ''return [[import ${./misc_nix/nixd.nix} ${
            builtins.path { path = pkgs.path; }
          } "]] .. type .. [[" ]] .. (path or "./.")'';
        };
      };
      /*
        bitwarden_uuids = {
          gemini = [
            "notes"
            "bcd197b5-ba11-4c86-8969-b2bd01506654"
          ];
          windsurf = [
            "notes"
            "d9124a28-89ad-4335-b84f-b0c20135b048"
          ];
        };
      */

      /*
            base16colors = {
              name = "stylix";
              translucent = config.stylix.targets.neovim.transparentBackground.main;
              base16 = pkgs.lib.filterAttrs (
                k: v: builtins.match "base0[0-9A-F]" k != null
              ) config.lib.stylix.colors.withHashtag;
            };
      */
    };
in
{
  volvim = args: {
    settings = volvim_settings args // {
      wrapRc = true;
      aliases = [
        "vi"
        "nvim"
      ];
    };
    categories = volvim_categories args // {
    general = true;
    };
    extra = volvim_extra args // {
    };
  };
  /*
    tempvim =
      { pkgs, ... }@args:
      {
        settings = volvim_settings args // {
          aliases = [ "vi" ];
        };
        categories = {
          portableExtras = true;
          lspDebugMode = false;
          other = true;
          theme = true;
          debug = true;
          customPlugins = true;
          general = true;
          markdown = true;
          bash = true;
          C = false;
          rust = true;
          go = false;
        };
        extra = volvim_extra args // {
          javaExtras = null;
          bitwarden_uuids = null;
        };
      };
  */
  testvim = args: {
    settings = volvim_settings args // {
      wrapRc = false;
      aliases = [ "vim" ];
    };
    categories = volvim_categories args // {
      test = true;
      lspDebugMode = true;
    };
    extra = volvim_extra args // {
    };
  };
  portableVim =
    { pkgs, ... }@args:
    {
      settings = volvim_settings args // {
        extraName = "portableVim";
        aliases = [
          "vi"
          "vim"
          "nvim"
        ];
      };
      /*
        categories = volvim_categories args // {
          portableExtras = true;
          AI = false;
        };
        extra = volvim_extra args // {
          AIextras = null;
        };
      */
    };
  minimalVim =
    { pkgs, ... }@args:
    {
      settings = volvim_settings args // {
        wrapRc = false;
        aliases = null;
        extraName = "minimalVim";
        hosts.python3.enable = false;
      };
      categories = { };
      extra = { };
    };
}
