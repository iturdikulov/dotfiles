{ options, config, pkgs, lib, ... }:

{

  # Allows git@... clone addresses rather than gitea@...
  users.users.photoprism = {
    group = "photoprism";
    isSystemUser = true;
    extraGroups = ["users"];
  };
  users.groups.photoprism = {};
  user.extraGroups = [ "photoprism" ];

  # Photoprism
  services.photoprism = {
    enable = true;
    port = 2342;
    originalsPath = "/media/photography/personal";
    address = "127.0.0.1";
    # TODO: replace with ageniex, require some fixes?
    passwordFile = "${config.user.home}/.secrets/photoprism";
    settings = {
      PHOTOPRISM_ADMIN_USER = "admin";
      PHOTOPRISM_DEFAULT_LOCALE = "en";
      PHOTOPRISM_DATABASE_DRIVER = "mysql";
      PHOTOPRISM_DATABASE_NAME = "photoprism";
      PHOTOPRISM_DATABASE_SERVER = "/run/mysqld/mysqld.sock";
      PHOTOPRISM_DATABASE_USER = "photoprism";
      PHOTOPRISM_SITE_URL = "http://photo.home.arpa";
      PHOTOPRISM_SITE_TITLE = "Photo Archive";
    };
  };

  # Set multimedia group to allow read synced originals
  systemd.services.photoprism.serviceConfig = {
    Group = lib.mkForce "multimedia";
  };

  services.nginx.virtualHosts."photo.home.arpa" = {
    http2 = true;
    locations."/" = {
      proxyPass = "http://127.0.0.1:2342";
      proxyWebsockets = true;
    };
  };
}