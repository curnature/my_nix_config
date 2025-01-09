{ pkgs, inputs, ... }:
{
    nixpkgs.config.allowUnfree = true;

    home.packages = with pkgs; [
        #
        curl
        nurl
        #
        # zellij # check programs.zellij
        #
        ffmpeg 
        ffmpegthumbnailer
        imagemagick

        git-graph
        showmethekey
        unzip
        zip
        ripgrep # for file content searching
      
        # CLI tools
        thefuck # corrects console command
        fzf # for quick file subtree navigation
        zoxide # for historical directories navigation
        bat # syntax highlighting
        eza # replacement of ls
        delta # syntax highlighting
        tldr # man
        fd # replacement of find
        # prefetch
        nix-prefetch
        nix-prefetch-scripts
        nix-prefetch-github
        # gitHub
        gh
        # chrome for specific extensions
        google-chrome
        # fonts
        nerd-fonts.cousine
        nerd-fonts.commit-mono
        # nixvim
        inputs.nixvim.packages.${pkgs.system}.default # redyf
    ];

}
