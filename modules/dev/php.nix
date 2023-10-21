{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let devCfg = config.modules.dev;
    cfg = devCfg.php;
in {
  options.modules.dev.php = {
    enable = mkBoolOpt false;
  };

  config = mkMerge [
    (mkIf cfg.enable {
      user.packages = with pkgs; [
        (pkgs.php.buildEnv {
           extensions = ({ enabled, all }: enabled ++ (with all; [
             xdebug
           ]));
           extraConfig = ''
             xdebug.mode=debug
           '';
         })
      ];
    })
  ];
}