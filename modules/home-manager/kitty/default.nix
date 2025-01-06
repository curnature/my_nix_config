{ config, pkgs, lib, ... }:

{
    programs.kitty = lib.mkForce {
        enable = true;
        term = "xterm-256color";
        font = {
            name = "nerd-fonts.cousine";
            size = 14;
        };
        settings = {
            confirm_os_window_close = 0;
            dynamic_background_opacity = true;
            background_opacity = "0.5";
            background_blur = 0;
            mouse_hide_wait = "-1.0";
            enable_audio_bell = false;
        };
    };

}
