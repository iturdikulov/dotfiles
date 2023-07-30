{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.shell.wget;
    configDir = config.dotfiles.configDir;
in {
  options.modules.shell.wget = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.wget ];
    home.configFile."wgetrc".source = "${configDir}/wget/wgetrc";
  };
}
