{ fish-ssh-agent, ... }:
{
  universal =
    { pkgs, ... }:
    {
      programs.fish = {
        enable = true;
        interactiveShellInit = builtins.concatStringsSep "\n" [
          (builtins.readFile "${fish-ssh-agent}/functions/fish_ssh_agent.fish")
          ''
            set fish_greeting

            set machines "allomyrina" "scarab" "atlas"

            fish_ssh_agent
          ''
        ];
      };
      users.defaultUserShell = pkgs.fish;

      home-shortcut = {

        programs.fish = {
          enable = true;
          shellAliases = {
            /*
              nix-shell = "nix-shell --run fish";
              eza = "eza --long --all --icons --time-style long-iso";
              "@" = "kitten ssh";
            */
          };
          functions = {
            cd = "z $argv";
          };

          plugins = [
            {
              name = "fish-completions-sync";
              src = pkgs.fetchFromGitHub {
                owner = "pfgray";
                repo = "fish-completion-sync";
                rev = "4f058ad2986727a5f510e757bc82cbbfca4596f0";
                sha256 = "sha256-kHpdCQdYcpvi9EFM/uZXv93mZqlk1zCi2DRhWaDyK5g=";
              };
            }
          ];
        };
      };
    };

  personal.home-shortcut = {
    programs.fish.shellAliases = {
      bwsh = "BW_SESSION=$(bw unlock --raw) fish; bw lock";
      pki-pass = "bw list items | jq -r '.[] | select(.name == \"PKI '$(hostname)'\") | .notes'";
    };
  };
}
