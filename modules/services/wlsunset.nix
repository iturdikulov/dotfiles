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
      unitConfig = {
        PartOf = [ "graphical-session.target" ];
      };
      environment = {
        WAYLAND_DISPLAY = "wayland-1";
        DISPLAY = ":0";
      };
      serviceConfig = {
        ExecStart =
          let lat = toString config.location.latitude;
              lng = toString config.location.longitude;
          in "${pkgs.wlsunset}/bin/wlsunset -l ${lat} -L ${lng}";
      };
      wantedBy = [ "graphical-session.target" ];
    };
  };
}