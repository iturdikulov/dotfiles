{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let configDir = config.dotfiles.configDir;
in {
  options.modules.dev.zeal = {
    enable = mkBoolOpt false;
  };

  config = {
   user.packages = with pkgs; [
    zeal
   ];

   home.configFile."Zeal/Zeal.conf".source = "${configDir}/zeal/zeal.conf";
  };
}