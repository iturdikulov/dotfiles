{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.services.dictd;
in {
  options.modules.services.dictd = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    services.dictd.enable = true;
    services.dictd.DBs = with pkgs.dictdDBs; [
      wordnet
      wiktionary
      eng2rus
    ];
  };
}
