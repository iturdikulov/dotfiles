{ options, config, pkgs, ... }:

{
  # Client
  # NOTE: For mount.cifs required pkgs.cifs-utils, required unless domain name resolution is not needed.
  environment.systemPackages = [ pkgs.cifs-utils ];
  fileSystems."/mnt/share/kama/torrent" = {
    device = "//kama/torrent";
    fsType = "cifs";
    options = let
      # this line prevents hanging on network split
      automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s";

    in ["${automount_opts},credentials=${config.age.secrets.samba.path},uid=1000,gid=100"];
  };
  fileSystems."/mnt/share/kama/public" = {
    device = "//kama/public";
    fsType = "cifs";
    options = let
      automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s";

    in ["${automount_opts},credentials=${config.age.secrets.samba.path},uid=1000,gid=100"];
  };

  # Server
  services.samba = {
    enable = true;
    securityType = "user";
    openFirewall = true;
    extraConfig = ''
      workgroup = WORKGROUP
      server string = ${config.networking.hostName}
      netbios name = ${config.networking.hostName}
      security = user
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