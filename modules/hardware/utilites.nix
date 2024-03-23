{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.hardware.utilites;
in {
  options.modules.hardware.utilites = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      dmidecode
      lshw
      pciutils
      usbutils
    ];
  };
}