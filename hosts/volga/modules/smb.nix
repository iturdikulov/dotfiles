{ options, config, pkgs, ... }:

{
  services.samba = {
    enable = true;
    securityType = "user";
    openFirewall = true;
    extraConfig = ''
      workgroup = WORKGROUP
      server string = smbnix
      netbios name = smbnix
      security = user
      #use sendfile = yes
      #max protocol = smb2
      # note: localhost is the ipv6 localhost ::1
      hosts allow = 100.87.0. 192.168.0. 127.0.0.1 localhost
      hosts deny = 0.0.0.0/0
      guest account = nobody
      map to guest = bad user
      '';
    shares = {
      downloads = {
        path = "/home/${config.user.name}/Downloads";
        browseable = "yes";
        "read only" = "no";
        "guest ok" = "no";
        "create mask" = "0644";
        "directory mask" = "0755";
        "force user" = "inom"; # smbpasswd -a <user>
        "force group" = "users";
      };

      videos = {
        path = "/home/${config.user.name}/Videos";
        browseable = "yes";
          "read only" = "yes";
          "guest ok" = "no";
          "force user" = "inom";
          "force group" = "users";
      };
    };
  };
}