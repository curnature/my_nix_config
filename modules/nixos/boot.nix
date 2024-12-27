# configure boot options

{ config, pkgs, options, ... }:

{

    boot.loader = {
        efi = {
            canTouchEfiVariables = true;
        };
        grub = {
            enable = true;
            devices = ["nodev"];
            efiSupport = true;
            useOSProber = true; # turn it on if any changes different from the list below
            #devices = ["/dev/nvme1n1p1" "/dev/nvme1n1p5"]; # failed
            timeout = 60;
            configurationLimit = 10;
            theme = pkgs.fetchFromGitHub {
                owner = "tsssni";
                repo = "plana.grub";
                rev = "31272f17529ae693eba311ac556e91a2660242f1";
                sha256 =  "sha256-N9uyk88QtIlG15kveiOF/Yh8E/frEwWbT3kB5PEvq3M=";
            };
        };
    };

  # Bootloader.
  # boot.loader.systemd-boot.enable = true;
  # boot.loader.efi.canTouchEfiVariables = true;
  # boot.loader.grub.enable = true;
  # boot.loader.grub.device = "nodev";
  # boot.loader.grub.useOSProber = true;



}

