# modules/dev/formatters.nix
#
# My various formatters utilites

{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let devCfg = config.modules.dev;
    cfg = devCfg.formatters;
in {
  options.modules.dev.formatters = {
    enable = mkBoolOpt false;
  };

  config = {
    user.packages = with pkgs; [
      ruff
      deno
      prettierd
      nixpkgs-fmt
      djlint
    ];
  };
}