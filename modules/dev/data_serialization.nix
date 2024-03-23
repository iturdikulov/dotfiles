# modules/dev/data_serialization.nix --- https://en.wikipedia.org/wiki/Serialization
#
# Data structure or object state into a format that can be stored

{ config, options, lib, pkgs, my, ... }:

with lib;
with lib.my;
let devCfg = config.modules.dev;
    cfg = devCfg.data_serialization;
in {
  options.modules.dev.data_serialization = {
    enable = mkBoolOpt false;
  };

  config = mkMerge [
    (mkIf cfg.enable {
      user.packages = with pkgs; [
        dasel # Comparable to jq / yq, but supports JSON, YAML, TOML, XML and CSV
        jq    # Command-line JSON processor (fallback)
      ];
    })
  ];
}