{ config, lib, pkgs, ... }:

{
  networking = {
    firewall = {
      allowedTCPPorts = [ 8888 ];
    };
  };

  # TODO: switch to agenix
  system.activationScripts."jupyenv-secret" = ''
    ${pkgs.coreutils-full}/bin/cat "${config.age.secrets.jupyenv.path}" > /home/${config.user.name}/.jupyenv-secret
  '';

  systemd.services."jupyenv" = {
    description = "Start jupyter labs";
    wantedBy = [ "multi-user.target" ];
    requires = [ "multi-user.target" ];
    after = [ "multi-user.target" ];
    script = ''
    export JPASSWORD=$(${pkgs.coreutils-full}/bin/cat /home/${config.user.name}/.jupyenv-secret)
    ${pkgs.nix}/bin/nix run .#apps.x86_64-linux.default -- --no-browser --ip=0.0.0.0 --NotebookApp.password=$JPASSWORD
    '';
    serviceConfig = {
      User="${config.user.name}";
      Group="${config.user.group}";
      Type = "simple";
      WorkingDirectory="/home/${config.user.name}/jupyenv";
      Restart = "always";
      RestartSec = 10;
    };
  };
}