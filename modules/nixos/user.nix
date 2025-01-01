#
{ config, pkgs, options, user, ... }:

let
    systemVariables = import ./../../systemVariables.nix;
    user = systemVariables.username;
in
{
    
    # Define a user account. Don't forget to set a password with ‘passwd’.
    users.users.${user} = {
        isNormalUser = true;
        description = "${user}";
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
