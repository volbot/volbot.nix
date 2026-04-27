{
universal = {
home-shortcut = 
{ pkgs, ... }:
{
programs.micro.enable = true;
home.packages = with pkgs; [
vim
neovim
kakoune
helix
];
};
};
}
