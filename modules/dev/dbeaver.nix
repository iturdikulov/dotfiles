{ config, options, inputs, lib, pkgs, ... }:

with lib;
with lib.my;
let devCfg = config.modules.dev;
    cfg = devCfg.dbeaver;
in {
  options.modules.dev.dbeaver = {
    enable = mkBoolOpt false;
  };

  config = {
      user.packages = with pkgs; [
        # TODO: replace this with dbeaver-bin, temporary workaround to avoid launch error
        inputs.dbeaver-last.legacyPackages.x86_64-linux.pkgs.dbeaver-bin

        mariadb # allowing dump database
      ];
  };
}