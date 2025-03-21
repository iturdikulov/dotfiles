{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.hardware.radeon;
in {
  options.modules.hardware.radeon = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    hardware.amdgpu = {
      initrd.enable = true;  #  enable loading amdgpu kernelModule in stage 1
      opencl.enable = true;
    };

    # Force enable RADV driver
    environment.variables.AMD_VULKAN_ICD = "RADV";

    environment.systemPackages = with pkgs; [
      vulkan-loader

      vulkan-headers
      vulkan-tools  # vulkaninfo, vkcube, vkcubepp

      corectrl
      clinfo
      amdgpu_top
    ];

    services.xserver.videoDrivers = [ "amdgpu" ];
    services.xserver.deviceSection = ''Option "TearFree" "true"'';  # Fix tearing for amdgpu.

    hardware.graphics.extraPackages = with pkgs; [
      rocmPackages.clr.icd
    ];

    # Most software has the HIP libraries hard-coded. You can work around it on NixOS by using
    systemd.tmpfiles.rules = [
      "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages.clr}"
    ];
  };
}