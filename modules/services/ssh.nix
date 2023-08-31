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
        PasswordAuthentication = true;  # TODO: DISABLE THIS IN FUTURE, used for testing
      };
    };

    user.openssh.authorizedKeys.keys =
      if config.user.name == "inom"
      then [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMAuq7AMP3tGbkgRpdb0MX4JHT9NeUiif0w8xF00iqjq Inom M. Turdikulov inom@iturdikulov.org" ]
      else [];
  };
}
