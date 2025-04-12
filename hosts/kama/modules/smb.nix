{ options, config, pkgs, ... }:

{
  services.samba = {
    enable = true;
    securityType = "user";
    openFirewall = true;
    settings = {
      global = {
        "workgroup" = "WORKGROUP";
        "hosts allow" = "192.168.0. 127.0.0.1 localhost";
        "hosts deny" = "0.0.0.0/0";
      };
    };
    shares = {
      media = {
        path = "/media/";
        browseable = "yes";
        "read only" = "no";
        "guest ok" = "no";
        "create mask" = "0644";
        "directory mask" = "0755";
        "force user" = "inom"; # smbpasswd -a <user>
        "force group" = "users";
      };
    };
  };
}