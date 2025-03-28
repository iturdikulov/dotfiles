{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.gaming.emulators;
in {
  options.modules.desktop.gaming.emulators = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      rpcs3 # PS3
      (retroarch.withCores (cores: with cores; [
        beetle-psx-hw # playstation
        gambatte # game boy / gbc
        genesis-plus-gx # genesis
        mesen # nes
        mgba # gba
        mupen64plus # n64
        snes9x # snes
      ]))
      flips # Patcher for IPS and BPS files
    ];
  };
}