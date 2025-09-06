{ 
    config,
    lib, 
    pkgs,
    ...
}:

let
    refreshAllScript = pkgs.writeShellScript "refresh-externals-after-resume" ''
      set -eu
      ${pkgs.kdePackages.kscreen}/bin/kscreen-doctor -o | ${pkgs.gawk}/bin/awk '{print $1}' | while read -r out; do
        case "$out" in eDP*|LVDS*|DSI*) continue ;; esac
        ${pkgs.kdePackages.kscreen}/bin/kscreen-doctor output.$out.disable
        ${pkgs.coreutils}/bin/sleep 1
        ${pkgs.kdePackages.kscreen}/bin/kscreen-doctor output.$out.enable
      done
   '';

in

{

    # Enable OpenGL
    hardware.graphics = {
        enable = true;
    };

    # Load nvidia driver for Xorg and Wayland
    services.xserver.videoDrivers = ["nvidia"];

    hardware.nvidia = {

        # Modesetting is required.
        modesetting.enable = true;

        # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
        # Enable this if you have graphical corruption issues or application crashes after waking
        # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead 
        # of just the bare essentials.
        powerManagement.enable = true;

        # Fine-grained power management. Turns off GPU when not in use.
        # Experimental and only works on modern Nvidia GPUs (Turing or newer).
        powerManagement.finegrained = true;

        # Use the NVidia open source kernel module (not to be confused with the
        # independent third-party "nouveau" open source driver).
        # Support is limited to the Turing and later architectures. Full list of 
        # supported GPUs is at: 
        # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus 
        # Only available from driver 515.43.04+
        # Currently alpha-quality/buggy, so false is currently the recommended setting.
        open = false;

        # Enable the Nvidia settings menu,
	# accessible via `nvidia-settings`.
        nvidiaSettings = true;

        # Optionally, you may need to select the appropriate driver version for your specific GPU.
        package = config.boot.kernelPackages.nvidiaPackages.stable;
    };

    # Setting Nvidia Optimus https://nixos.wiki/wiki/Nvidia
    hardware.nvidia.prime = {
        # offload mode--Nvidia Gpu sleep
        offload = {
            enable = true;
            enableOffloadCmd = true;
        };
        
        # sync.enable = true; # Sync Mode
        
        # Make sure to use the correct Bus ID values for your system!
        intelBusId = "PCI:0:2:0";
        nvidiaBusId = "PCI:1:0:0";
        # amdgpuBusId = "PCI:54:0:0"; For AMD GPU
    };
    # Fix wake up external screen freeze problem
    boot.kernelParams = [
        "nvidia.NVreg_PreserveVideoMemoryAllocations=1"
        "nvidia.NVreg_TemporaryFilePath=/var/tmp"
    ];

    environment.sessionVariables = {
      __GLX_VENDOR_LIBRARY_NAME = "nvidia";
      GBM_BACKEND = "nvidia-drm";
      WLR_NO_HARDWARE_CURSORS = "1";
    };
    
    # make sure kscreen-doctor is available
    environment.systemPackages = [ pkgs.kdePackages.kscreen pkgs.gawk ];
    
    systemd.user.services."refresh-externals-after-resume" = {
        Unit = {
            Description = "Re-enable external displays after suspend (Plasma)";
            After = [ "suspend.target" "hibernate.target" "hybrid-sleep.target" ];
        };
        Service = {
            Type = "oneshot";
            ExecStart = refreshAllScript;
        };
        Install = {
            WantedBy = [ "suspend.target" "hibernate.target" "hybrid-sleep.target" ];
        };
    };

}

