{ config, pkgs, ... }:

{
    programs.yazi = {
        enable = true;
        enableBashIntegration = true;
        enableZshIntegration = true;
        #package = yazi.packages.${pkgs.system}.default;
    };

}
