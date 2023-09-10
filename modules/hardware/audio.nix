{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.hardware.audio;
in {
  options.modules.hardware.audio = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    programs.noisetorch.enable = true;  # Echo cancelation

    systemd.user.services.noisetorch = {
      after = [ "default.target" ];
      wantedBy = [ "default.target" ];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.noisetorch}/bin/noisetorch -i";
        Restart = "on-failure";
        RestartSec = 5;
      };
      environment = {
        PULSE_SERVER = "/run/user/1000/pulse/native";
      };
    };

    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };

    security.rtkit.enable = true;

    user.packages = with pkgs; [
      pavucontrol
    ];

    user.extraGroups = [ "audio" ];
  };
}