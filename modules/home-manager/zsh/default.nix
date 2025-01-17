{ pkgs, ... }:
{
    programs.zsh = {
        enable = true;
        initExtra = ''
            # Lines configured by zsh-newuser-install
            HISTFILE=~/.histfile
            HISTSIZE=1000
            SAVEHIST=1000
            setopt autocd extendedglob nomatch notify
            unsetopt beep
            bindkey -v
            # End of lines configured by zsh-newuser-install
            # The following lines were added by compinstall
            zstyle :compinstall filename '/home/curvature/.zshrc'

            autoload -Uz compinit
            compinit
            # End of lines added by compinstall
            
            # Alias settings
            alias ksshlongleaf="kitty +kitten ssh -X tnwang@longleaf.unc.edu"
        '';
    };

}
