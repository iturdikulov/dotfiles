{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.apps.rofi;
    rofiPkg = if config.modules.desktop.type == "wayland"
                then pkgs.rofi-wayland-unwrapped
                else pkgs.rofi-unwrapped;
    rofiCalcPkg = pkgs.rofi-calc.override { rofi-unwrapped = rofiPkg; };
    rofiFBPkg = pkgs.rofi-file-browser.override { rofi = rofiPkg; };
    configDir = config.dotfiles.configDir;
in {
  options.modules.desktop.apps.rofi = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    programs.gdk-pixbuf.modulePackages = [ pkgs.librsvg ];

    environment.variables.ROFI_PLUGIN_PATH = [
      "$XDG_CONFIG_HOME/rofi/plugins"  # for local development
      "${rofiCalcPkg}/lib/rofi"
      "${rofiFBPkg}/lib/rofi"
    ];

    home.configFile = {
       "rofi/theme" = { source = "${configDir}/rofi"; recursive = true; };
       "rofi/config.rasi".source = "${configDir}/rofi_config.rasi";
    };

    user.packages = with pkgs; [
      rofiPkg
      (makeDesktopItem {
        name = "rofi-open-file";
        desktopName = "Open File ->";
        icon = "folder";
        exec = "${rofiPkg}/bin/rofi -show filebrowser";
      })
      # Fake rofi dmenu entries
      (makeDesktopItem {
        name = "rofi-browsermenu";
        desktopName = "Open Bookmark in Browser";
        icon = "bookmark-new-symbolic";
        exec = "${config.dotfiles.binDir}/rofi/browsermenu";
      })
      (makeDesktopItem {
        name = "rofi-browsermenu-history";
        desktopName = "Open Browser History";
        icon = "accessories-clock";
        exec = "${config.dotfiles.binDir}/rofi/browsermenu history";
      })
      (makeDesktopItem {
        name = "lock-display";
        desktopName = "Lock screen";
        icon = "system-lock-screen";
        exec = "${config.dotfiles.binDir}/zzz";
      })
    ];
  };
}