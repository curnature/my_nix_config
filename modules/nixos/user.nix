#
{ config, pkgs, options, ... }:

{
    # Define a user account. Don't forget to set a password with ‘passwd’.
    users.users.curvature = {
        isNormalUser = true;
        description = "curvature";
        extraGroups = [ "networkmanager" "wheel" ];
        packages = with pkgs; [
            kdePackages.kate
            #  thunderbird
        ];
    };

    # Enable automatic login for the user.
    services.xserver.displayManager.autoLogin.enable = false;
    # services.xserver.displayManager.autoLogin.user = "curvature";


}
