{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.services.msmtp;
in {
  options.modules.services.msmtp = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    programs.msmtp.enable = true;
    environment.etc."msmtprc".enable = false;

    # NEXT: propably better to use ... agenix.secrets.msmtprc = {
    # pat = ... mode = "0644" ..., but it's not working
    system.activationScripts."msmtprc" = ''
      if [ ! -f /etc/msmtprc ]; then
        exit 0
      fi
      ${pkgs.coreutils-full}/bin/cat "${config.age.secrets.msmtprc.path}" > /etc/msmtprc
      ${pkgs.coreutils-full}/bin/chmod 0600 /etc/msmtprc
    '';
  };
}