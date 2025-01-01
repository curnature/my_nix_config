{ pkgs, ... }:

{
    # set zsh as default shell
    programs.zsh.enable = true;
    users.defaultUserShell = pkgs.zsh;


}
