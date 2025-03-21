{ lib, config, options, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.services.wlsunset;
in {
  options.modules.services.wlsunset = with types; {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = config.modules.desktop.type == "wayland";
        message = "wlsunset requires a wayland desktop";
      }
      {
        assertion = config.location.latitude != null && config.location.longitude != null;
        message = "Coordinations not set";
      }
    ];

    systemd.user.services.wlsunset = {
      serviceConfig = {
        ExecStart =
          let lat = toString config.location.latitude;
              lng = toString config.location.longitude;
          in "${pkgs.wlsunset}/bin/wlsunset -l ${lat} -L ${lng}";
        Restart = "always";
        RestartSec = 5;
      };
      bindsTo = [ "graphical-session.target" ];
      partOf = [ "graphical-session.target" ];
      after = [ "graphical-session.target" ];
      wantedBy = [ "graphical-session.target" ];
    };
  };
}