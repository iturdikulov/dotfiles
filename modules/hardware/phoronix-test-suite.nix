{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.hardware.phoronix-test-suite;
in {
  options.modules.hardware.phoronix-test-suite = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      phoronix-test-suite
    ];
  };
}