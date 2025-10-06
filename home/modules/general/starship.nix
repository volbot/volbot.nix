{
  pkgs,
  lib,
  ...
}: {
  home.packages = with pkgs; [
    starship
  ];

  programs.starship = {
    enable = true;
    settings = let
      readTOML = fn: builtins.fromTOML (builtins.readFile fn);
      mkPreset = name:
        readTOML (
          pkgs.runCommand "starship-preset-${name}.toml" {}
          "${pkgs.starship}/bin/starship preset ${name} --output $out"
        );
    in
      (lib.foldl lib.attrsets.recursiveUpdate {}) [
        (mkPreset "no-empty-icons")
        (mkPreset "nerd-font-symbols")
        #(mkPreset "pastel-powerline")
        (mkPreset "tokyo-night")
        {opa.format = "'(via [$symbol($version )]($style))'";} #fix a typo in no-empty-icons
      ];
  };
}
