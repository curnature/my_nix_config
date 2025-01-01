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
        # text editor
	nano
        vim
	# downloads
        wget
        git
	# CLI tools
        file
        tree
        lshw
        # home-manager
        home-manager 
        # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    ];


}
