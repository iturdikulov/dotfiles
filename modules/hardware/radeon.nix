{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.hardware.radeon;
in {
  options.modules.hardware.radeon = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    hardware.opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
    };

    environment.systemPackages = with pkgs; [
      vulkan-headers
      vulkan-loader
      vulkan-tools
      corectrl
    ];

    hardware.opengl.extraPackages = [
      pkgs.rocm-opencl-icd
      pkgs.rocm-opencl-runtime
    ];
  };
}