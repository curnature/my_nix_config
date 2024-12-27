#
{ config, pkgs, options, ... }:

{
    # Install firefox.
    programs.firefox.enable = true;

    # Allow unfree packages
    nixpkgs.config.allowUnfree = true;

    # List packages installed in system profile. To search, run:
    # $ nix search wget
    environment.systemPackages = with pkgs; [
        nano
        vim
        wget
        git
        tree
        home-manager
        lshw 
        # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    ];


}
