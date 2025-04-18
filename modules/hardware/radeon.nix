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

    environment.systemPackages = with pkgs; [
      vulkan-loader

      vulkan-headers
      vulkan-tools  # vulkaninfo, vkcube, vkcubepp

      corectrl
      clinfo
      amdgpu_top
    ];

    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };

    # Most software has the HIP libraries hard-coded. You can work around it on NixOS by using
    systemd.tmpfiles.rules = [
      "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages.clr}"
    ];
  };
}