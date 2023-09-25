{ options, config, lib, ... }:

with lib;
with lib.my;
let cfg = config.modules.services.ssh;
in {
  options.modules.services.ssh = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    services.openssh = {
      enable = true;
      settings = {
        PasswordAuthentication = false;  # NOTE: use it only for testing
      };
    };

    user.openssh.authorizedKeys.keys =
      if config.user.name == "inom"
      then [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMZ+98UauMXllELyhSNhTTJPITI2OmJSNf1HUXxjiv6V Inom M. Turdikulov inom@iturdikulov.org" ]
      else [];
  };
}