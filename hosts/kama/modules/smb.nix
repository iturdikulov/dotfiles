{ options, config, pkgs, ... }:

{
  services.samba = {
    enable = true;
    securityType = "user";
    openFirewall = true;
    extraConfig = ''
      workgroup = WORKGROUP
      server string = ${config.networking.hostName}
      netbios name = ${config.networking.hostName}
      security = user
      hosts allow = 100.87.0. 192.168.0. 127.0.0.1 localhost
      hosts deny = 0.0.0.0/0
      guest account = nobody
      map to guest = bad user
      '';
    shares = {
      public = {
        path = "/media/public/";
        browseable = "yes";
        "read only" = "no";
        "guest ok" = "no";
        "create mask" = "0644";
        "directory mask" = "0755";
        "force user" = "inom"; # smbpasswd -a <user>
        "force group" = "users";
      };
      torrent = {
        path = "/media/torrent/";
        browseable = "yes";
        "read only" = "no";
        "guest ok" = "no";
        "create mask" = "0644";
        "directory mask" = "0755";
        "force user" = "qbittorrent"; # smbpasswd -a <user>
        "force group" = "qbittorrent";
      };
    };
  };
}