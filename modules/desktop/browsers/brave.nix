# modules/browser/brave.nix --- https://publishers.basicattentiontoken.org
#
# A FOSS and privacy-minded browser.

{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.browsers.brave;
    bravePkg =
  (if cfg.proxy.enable
    then
    (pkgs.brave.override {
      commandLineArgs = "--proxy-server=\"${config.networking.globalProxy.host}:${config.networking.globalProxy.port}\"";
    })
  else pkgs.brave );
in {
  options.modules.desktop.browsers.brave = {
    enable = mkBoolOpt false;
    proxy.enable = mkBoolOpt true;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [

      (makeDesktopItem {
        name = "brave-x11";
        desktopName = "Brave Web Browser x11";
        genericName = "Open a Brave window x11";
        icon = "brave";
        exec = "env XDG_SESSION_TYPE=x11 ${bravePkg}/bin/brave";
        categories = [ "Network" ];
      })

      (makeDesktopItem {
        name = "brave-private";
        desktopName = "Brave Web Browser";
        genericName = "Open a private Brave window";
        icon = "brave";
        exec = "${bravePkg}/bin/brave --incognito";
        categories = [ "Network" ];
      })
    ];
  };
}