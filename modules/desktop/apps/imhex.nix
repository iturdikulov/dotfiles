# modules/dev/imhex.nix --- https://github.com/WerWolv/ImHex
#
# A Hex Editor for Reverse Engineers, Programmers and people who value their
# retinas when working at 3 AM.

{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.apps.imhex;
in {
  options.modules.desktop.apps.imhex = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      imhex
    ];
  };
}