{ config, lib, ... }:

with builtins;
with lib;
{
  networking.extraHosts = ''
    192.168.0.1   router.home

    # Hosts
    ${optionalString (config.time.timeZone == "Europe/Moscow") ''
        192.168.0.190  kama.local
        192.168.0.191  volga.local
        192.168.0.192  ob.local
      ''}
    '';

  ## Location config -- since Toronto is my 127.0.0.1
  time.timeZone = mkDefault "Europe/Moscow";
  i18n.defaultLocale = mkDefault "en_US.UTF-8";
  # For redshift, mainly
  location = (if config.time.timeZone == "Asia/Bishkek" then {
    latitude = 43.238949;
    longitude = 76.889709;
  } else if config.time.timeZone == "Europe/Moscow" then {
    latitude = 53.20066;
    longitude = 45.00464;
  } else {});

  # So the vaultwarden CLI knows where to find my server.
  # TODO: add own server?
  # modules.shell.vaultwarden.config.server = "vault.lissner.net";
}