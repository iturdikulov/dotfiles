{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.hardware.wacom;
in
{
  options.modules.hardware.wacom = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    # For my intuos4
    hardware.opentabletdriver.enable = true;
  };
}