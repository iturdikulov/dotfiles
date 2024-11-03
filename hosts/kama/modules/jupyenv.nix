{ config, lib, pkgs, ... }:

{
  networking = {
    firewall = {
      allowedTCPPorts = [ 8888 ];
    };
  };

  system.activationScripts."jupyenv-secret" = ''
    ${pkgs.coreutils-full}/bin/cat "${config.age.secrets.jupyenv.path}" > ${config.user.home}/.jupyenv-secret
  '';

  systemd.services."jupyenv" = {
    description = "Start jupyter labs";
    wantedBy = [ "multi-user.target" ];
    requires = [ "multi-user.target" ];
    after = [ "multi-user.target" ];
    script = ''
    export JPASSWORD=$(${pkgs.coreutils-full}/bin/cat ${config.user.home}/.jupyenv-secret)
    ${pkgs.nix}/bin/nix run .#apps.x86_64-linux.default -- --no-browser --ip=0.0.0.0 --NotebookApp.password=$JPASSWORD
    '';
    serviceConfig = {
      User="${config.user.name}";
      Group="${config.user.group}";
      Type = "simple";
      WorkingDirectory="${config.user.home}/jupyenv";
      Restart = "always";
      RestartSec = 10;
    };
  };
}