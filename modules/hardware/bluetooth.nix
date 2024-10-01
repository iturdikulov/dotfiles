{ config, lib, ... }:

with lib;
with lib.my;
let hwCfg = config.modules.hardware;
    cfg = hwCfg.bluetooth;
in {
  options.modules.hardware.bluetooth = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    hardware.bluetooth = {
      enable = true;
      powerOnBoot = true;
      settings = {
        General = {
          Experimental = true;  # Enable Battery level reporting
        };
      };
    };
  };
}