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

    # Ths is not dictd related package, but very useful to transalate
    # full sentences/text good companion to dictd
    user.packages = [pkgs.translate-shell];

    services.dictd.DBs = with pkgs.dictdDBs; [
      wordnet
      wiktionary
      eng2rus
    ];
  };
}
