{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let
  devCfg = config.modules.dev;
  cfg = devCfg.dbeaver;
in
{
  options.modules.dev.dbeaver = {
    enable = mkBoolOpt false;
  };

  config = {
    user.packages = with pkgs; [
      (writeShellScriptBin "dbeaver" ''
        env GDK_BACKEND=x11 ${getExe' dbeaver-bin "dbeaver"}
      '')

      (makeDesktopItem {
        name = "dbeaver";
        desktopName = "dbeaver";
        genericName = "Database SQL Client";
        icon = "dbeaver";
        exec = "env GDK_BACKEND=x11 ${getExe' dbeaver-bin "dbeaver"}";
      })
    ];
  };
}