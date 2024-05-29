{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.apps.rustdesk;
in {
  options.modules.desktop.apps.rustdesk = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      unstable.rustdesk

      # Custom scrcpy desktop item
      (makeDesktopItem {
        name = "rustdesk";
        desktopName = "Rustdesk";
        genericName = "Open Source Remote Desktop";
        icon = "rustdesk";
        exec = "${unstable.rustdesk}/bin/rustdesk";
        categories = [ "Network" ];
      })
    ];
  };
}