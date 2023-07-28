{ config, lib, ... }:

with builtins;
with lib;
let blocklist = fetchurl https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts;
in {
  networking.extraHosts = ''
    192.168.1.1   router.home

    # Hosts
    ${optionalString (config.time.timeZone == "Europe/Moscow") ''
        192.168.1.10  volga.home
      ''}
    ${optionalString (config.time.timeZone == "Asia/Almaty") ''
        192.168.1.10  volga.home
      ''}

    # Block garbage
    ${optionalString config.services.xserver.enable (readFile blocklist)}
  '';

  ## Location config -- since Toronto is my 127.0.0.1
  time.timeZone = mkDefault "Asia/Almaty";
  i18n.defaultLocale = mkDefault "en_US.UTF-8";
  # For redshift, mainly
  location = (if config.time.timeZone == "Asia/Almaty" then {
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
