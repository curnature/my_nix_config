# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ 
    inputs,
    outputs,
    lib,
    config,
    pkgs,
    options,
    ... 
}:

let
    hostname = config.specialArgs.hostname;
    stateVersion = config.specialArgs.stateVersion;
    user = config.specialArgs.user;
in
{
    
    imports =
        [ 
            # Include the results of the hardware scan.
            ./hardware-configuration.nix
            ../../modules/nixos/boot.nix # grub + theme
            ../../modules/nixos/nix.nix #enable flakes and declare nixos version
            ../../modules/nixos/time_lang.nix # timezone + language
            ../../modules/nixos/NvidiaGpu.nix # enable/disable
            ../../modules/nixos/network.nix #
            ../../modules/nixos/graphics.nix # display-manager
            ../../modules/nixos/audio.nix # sound and other hardware
            ../../modules/nixos/user.nix # 
            ../../modules/nixos/packages.nix #


        ];


}


