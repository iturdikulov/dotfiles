#
# Gitea is essentially a self-hosted github. This modules configures it with the
# expectation that it will be served over an SSL-secured reverse proxy (best
# paired with my modules.services.nginx module).
#
# Resources
#   Config: https://docs.gitea.io/en-us/config-cheat-sheet/
#   API:    https://docs.gitea.io/en-us/api-usage/

{ options, config, pkgs, ... }:

{
    # Allows git@... clone addresses rather than gitea@...
    users.users.git = {
      useDefaultShell = true;
      home = "/var/lib/gitea";
      group = "gitea";
      isSystemUser = true;
    };

    user.extraGroups = [ "gitea" ];

    services.gitea = {
      enable = true;
      lfs.enable = true;
      user = "git";
      database.user = "git";
      # Only log what's important, but Info is necessary for fail2ban to work
      settings = {
        server.SSH_DOMAIN = "git.home.arpa";
        server.DISABLE_ROUTER_LOG = true;
        server.HTTP_PORT = 3001;
        database.LOG_SQL = false;
        service.ENABLE_BASIC_AUTHENTICATION = false;
        log.LEVEL = "Info";
        session = {
          COOKIE_SECURE = false; # set to true to assume SSL-only connectivity
        };
      };

      dump.interval = "daily";
    };

    services.nginx.virtualHosts."git.home.arpa" = {
      http2 = true;
      locations."/".proxyPass = "http://127.0.0.1:3001";
    };

    services.fail2ban.jails.gitea = ''
      enabled = true
      filter = gitea
      banaction = %(banaction_allports)s
      maxretry = 5
    '';
    networking.firewall.allowedTCPPorts = [ 3001 ];
}