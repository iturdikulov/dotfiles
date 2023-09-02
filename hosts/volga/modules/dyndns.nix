{ config, lib, pkgs, ... }:

{
  systemd = {
    services.dyndns = {
      description = "Update IP in DNS records";
      path = with pkgs; [ curl dig ];
      script = ''
        IP="$(dig +short myip.opendns.com @resolver1.opendns.com)"
      '';
      serviceConfig = {
        Type = "oneshot";
        EnvironmentFile = config.age.secrets.dns-env.path;
      };
    };
    timers.dyndns = {
      wantedBy = [ "timers.target" ];
      timerConfig = {
        Unit = "dyndns.service";
        OnCalendar = "*:0/5";
      };
    };
  };
}