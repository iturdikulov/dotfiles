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
      (retroarch.overrideAttrs (old: {
        cores = with libretro; [
          genesis-plus-gx  # SG-1000, Master System, Genesis, Sega CD, Game Gear
          mesen            # NES
          bsnes            # SNES - Higan
          swanstation      # PS1
          pcsx-rearmed     # PS1
          pcsx2            # PS2
          ppsspp           # PSP
        ];
      }))
    ];
  };
}