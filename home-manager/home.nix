{ 
    inputs,
    outputs,
    lib,
    config,
    pkgs,
    ... 
}:

let
    systemVariables = import ./../systemVariables.nix;
    homeStateVersion = systemVariables.homeVersion;
    user = systemVariables.username;
    
in
{
    # Home Manager needs a bit of information about you and the paths it should
    # manage.
    home.username = user;
    home.homeDirectory = "/home/${user}";

    # This value determines the Home Manager release that your configuration is
    # compatible with. This helps avoid breakage when a new Home Manager release
    # introduces backwards incompatible changes.
    #
    # You should not change this value, even if you update Home Manager. If you do
    # want to update the value, then make sure to first check the Home Manager
    # release notes.
    home.stateVersion = homeStateVersion; # Please read the comment before changing.

    # The home.packages option allows you to install Nix packages into your
    # environment.
    imports = [
        ./home_pkgs.nix
        ./../modules/home-manager/yazi/default.nix
        ./../modules/home-manager/kitty/default.nix
        # inputs.nixvim.homeManagerModules.nixvim # load nixvim, url in flake.nix
        # ./../modules/home-manager/nixvim/default.nix # my own nixvim settings


    ];
    
    
    #home.packages = with pkgs; [
    #    tmux 

        # # Adds the 'hello' command to your environment. It prints a friendly
        # # "Hello, world!" when run.
        # pkgs.hello

        # # It is sometimes useful to fine-tune packages, for example, by applying
        # # overrides. You can do that directly here, just don't forget the
        # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
        # # fonts?
        # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

        # # You can also create simple shell scripts directly inside your
        # # configuration. For example, this adds a command 'my-hello' to your
        # # environment:
        # (pkgs.writeShellScriptBin "my-hello" ''
        #   echo "Hello, ${config.home.username}!"
        # '')
    #];

    # Home Manager is pretty good at managing dotfiles. The primary way to manage
    # plain files is through 'home.file'.
    home.file = {
        
        ".vimrc".source = ./../modules/home-manager/vim/.vimrc;
        
        # # Building this configuration will create a copy of 'dotfiles/screenrc' in
        # # the Nix store. Activating the configuration will then make '~/.screenrc' a
        # # symlink to the Nix store copy.
        # ".screenrc".source = dotfiles/screenrc;

        # # You can also set the file content immediately.
        # ".gradle/gradle.properties".text = ''
        #   org.gradle.console=verbose
        #   org.gradle.daemon.idletimeout=3600000
        # '';
    };
    

    #GitHub configuration
    programs.git = {
        enable = true;
        userName = "curnature";
        userEmail = "curnature00@gmail.com";
        extraConfig = {
            init.defaultBranch = "main";
        };
    };
    

    # Python312Shell
    #imports = [
    #    ../modules/home-manager/python/shell.nix
    #];

    # Home Manager can also manage your environment variables through
    # 'home.sessionVariables'. These will be explicitly sourced when using a
    # shell provided by Home Manager. If you don't want to manage your shell
    # through Home Manager then you have to manually source 'hm-session-vars.sh'
    # located at either
    #
    #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
    #
    # or
    #
    #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
    #
    # or
    #
    #  /etc/profiles/per-user/curvature/etc/profile.d/hm-session-vars.sh
    #
    home.sessionVariables = {
        EDITOR = "vim";
        VISUAL = "vim";
        TERMINAL = "kitty";
        LANG = "en_US.UTF-8";
    };

    # Enable custom fonts
    fonts.fontconfig.enable = true;

    # Let Home Manager install and manage itself.
    programs.home-manager.enable = true;
}
