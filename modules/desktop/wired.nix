{ options, config, lib, pkgs, inputs, ... }:

with lib;
with lib.my;
let
  cfg = config.modules.desktop.wired;
  configDir = config.dotfiles.configDir;
  nix_system = builtins.getEnv "NIX_SYSTEM";
in
{
  options.modules.desktop.wired = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    nixpkgs.overlays = [ inputs.wired.overlays.default ];
    user.packages = [ pkgs.wired ];

    systemd.user.services."wired" = {
      description = "Wired Notification Daemon";

      wantedBy = [ "graphical-session.target" ];
      wants = [ "graphical-session.target" ];
      after = [ "graphical-session.target" ];

      unitConfig = {
          ConditionEnvironment = "DISPLAY=:0";
      };

      serviceConfig = {
          Type = "dbus";
          ExecStart = "${pkgs.wired}/bin/wired";
          BusName = "org.freedesktop.Notifications";
          Restart = "always";
          RestartSec = 10;
      };
    };

    home.configFile."wired/wired.ron".source = "${configDir}/wired/wired.ron";
  };
}