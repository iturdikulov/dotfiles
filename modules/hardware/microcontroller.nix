{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;

let cfg = config.modules.hardware.microcontroller;
in
{
  options.modules.hardware.microcontroller = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      arduino
      fritzing
      qucs-s # not only for microcontrollers
    ];
  };
}