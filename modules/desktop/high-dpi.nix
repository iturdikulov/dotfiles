{ options, config, lib, ... }:

with lib;
with lib.my;
let
  cfg = config.modules.desktop.high-dpi;
in
{
  options.modules.desktop.high-dpi = {
    scaleFactor = with types; mkOpt (nullOr str) null;
  };

  config = mkIf (cfg.scaleFactor != null) {
    environment.variables = {
      GDK_SCALE = cfg.scaleFactor;
    };
  };
}