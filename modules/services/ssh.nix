{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.services.ssh;
in {
  options.modules.services.ssh = {
    enable = mkBoolOpt false;
    mosh.enable = mkBoolOpt true;
  };

  config = mkIf cfg.enable (mkMerge [
    {
      services.openssh = {
        enable = true;
        settings = {
          # Require keys over passwords. Ensure target machines are provisioned
          # with authorizedKeys!
          PasswordAuthentication = false;
        };
        # Suppress superfluous TCP traffic on new connections. Undo if using SSSD.
        extraConfig = ''GSSAPIAuthentication no'';
        # Deactive short moduli
        moduliFile = pkgs.runCommand "filterModuliFile" {} ''
          awk '$5 >= 3071' "${config.programs.ssh.package}/etc/ssh/moduli" >"$out"
        '';
      };

      user.openssh.authorizedKeys.keys =
        if config.user.name == "inom"
        then ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMZ+98UauMXllELyhSNhTTJPITI2OmJSNf1HUXxjiv6V Inom M. Turdikulov inom@iturdikulov.org"]
        else [];
    }

    (mkIf cfg.mosh.enable {
      programs.mosh.enable = true;
    })
  ]);
}