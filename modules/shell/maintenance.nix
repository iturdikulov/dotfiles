{ config, options, pkgs, lib, ... }:

with lib;
with lib.my;
let cfg = config.modules.shell.maintenance;
    configDir = config.dotfiles.configDir;
in {
  options.modules.shell.maintenance = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      htop
      # Otpional packages
      lm_sensors  # show CPU temperature
      lsof        # show open files
      strace      # attach to running process

      btop        # A monitor of resources
      sysz        # A fzf terminal UI for systemctl
      ps_mem      # A utility to accurately report the in core memory usage for a program
    ];

    home.configFile."maintenance/htoprc".source = "${configDir}/htop/htoprc";
  };
}
