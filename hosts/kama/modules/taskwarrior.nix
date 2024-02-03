{ options, config, pkgs, ... }:

{
  services.taskserver = {
    enable = true;
    listenHost = "0.0.0.0";
    listenPort = 43289;
    fqdn = "task.home.arpa";
    openFirewall = true;
    organisations.home.users = [ "${config.user.name}" ];
  };
}