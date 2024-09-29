# modules.hardware.nvidia --- lipstick on a pig
#
# I use NVIDIA cards on all my machines, largely because I'm locked into CUDA
# for work. Fortunately, my NVIDIA GPUs are recent/latest gen (680gtx, 960gtx,
# 1080, 1660S, 3080ti) so no cludge is needed to get them to work on NixOS.

{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.hardware.nvidia;
in {
  options.modules.hardware.nvidia = {
    enable = mkBoolOpt false;
    cuda.enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable (mkMerge [
    {
      hardware.graphics = {
        enable = true;
        enable32Bit = true;
      };

      services.xserver.videoDrivers = [ "nvidia" ];

      environment.systemPackages = with pkgs; [
        # Respect XDG conventions, damn it!
        (writeScriptBin "nvidia-settings" ''
          #!${stdenv.shell}
          mkdir -p "$XDG_CONFIG_HOME/nvidia"
          exec ${config.boot.kernelPackages.nvidia_x11.settings}/bin/nvidia-settings --config="$XDG_CONFIG_HOME/nvidia/settings"
        '')
      ];
    }

    (mkIf cfg.cuda.enable {
      environment = {
        variables = {
          CUDA_PATH="${pkgs.cudatoolkit}";
          CUDA_CACHE_PATH = "$XDG_CACHE_HOME/nv";
        };
        systemPackages = [ pkgs.cudatoolkit ];
      };

      # $EXTRA_LDFLAGS and $EXTRA_CCFLAGS are sometimes necessary too, but I set
      # those in nix-shells instead.
    })

    (mkIf (config.modules.desktop.type == "wayland") {
    # see NixOS/nixos-hardware#348
    # TODO: Try these!
    environment.systemPackages = with pkgs; [
      libva
      # Fixes crashes in Electron-based apps?
      # libsForQt5.qt5ct
      # libsForQt5.qt5-wayland
    ];

    environment.sessionVariables = {
      LIBVA_DRIVER_NAME = "nvidia";
      WLR_NO_HARDWARE_CURSORS = "1";

      # May cause Firefox crashes
      GBM_BACKEND = "nvidia-drm";

        # If you face problems with Discord windows not displaying or screen
        # sharing not working in Zoom, remove or comment this:
        __GLX_VENDOR_LIBRARY_NAME = "nvidia";
      };
    })
  ]);
}