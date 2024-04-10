{ options, config, lib, ... }:

with lib;
with lib.my;
let
  cfg = config.modules.desktop.high-dpi;
  configDir = config.dotfiles.configDir;
in
{
  options.modules.desktop.high-dpi = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    services.xserver.dpi = 192;
    environment.variables = {
      GDK_SCALE = "2";
      GDK_DPI_SCALE = "0.5";
      QT_AUTO_SCREEN_SCALE_FACTOR = "1";
      _JAVA_OPTIONS = "-Dsun.java2d.uiScale=2";
    };

    # link recursively so other modules can link files in their folders
    home.configFile."xtheme/80-high-dpi".text = ''
      Xcursor.size: 48
      Xft.dpi: 192
    '';
  };
}