{
  universal.home-shortcut =
    { pkgs, ... }:
    {
      programs.git.enable = true;
      programs.git.settings.user.name = "allomyrina volbot";
      programs.git.settings.user.email = "tech@volbot.org";
      programs.gh.enable = true;
      programs.gh.gitCredentialHelper.enable = true;

      programs.lazygit.enable = true;

      programs.git.ignores = [ "**/.vscode" ];
    };
}
