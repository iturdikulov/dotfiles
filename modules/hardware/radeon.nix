{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.hardware.radeon;
in {
  options.modules.hardware.radeon = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };

    environment.systemPackages = with pkgs; [
      vulkan-headers
      vulkan-loader
      vulkan-tools
      corectrl
      clinfo  # OpenCL info
    ];

    services.xserver.videoDrivers = [ "amdgpu" ];
    services.xserver.deviceSection = ''Option "TearFree" "true"'';  # Fix tearing for amdgpu.

    hardware.graphics.extraPackages = with pkgs; [
      clinfo
      amdvlk
      rocmPackages.clr.icd
    ];

    # For 32 bit applications
    hardware.graphics.extraPackages32 = with pkgs; [
      driversi686Linux.amdvlk
    ];

    # Force radv
    environment.variables.AMD_VULKAN_ICD = "RADV";

    # Most software has the HIP libraries hard-coded. You can work around it on NixOS by using
    systemd.tmpfiles.rules = [
      "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages.clr}"
    ];
  };
}