# modules/shell/task.nix
#

{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.shell.task;
    configDir = config.dotfiles.configDir;
in {
  options.modules.shell.task = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      taskwarrior # my daily tasks
      timewarrior # time tracking
      taskwarrior-tui # TUI to rare clean taskwarrior tasks
    ];

    home.configFile."task/taskrc".source = "${configDir}/task/taskrc";
    modules.shell.zsh.rcFiles = [ "${configDir}/task/aliases.zsh" ];

    systemd.timers."timew_track" = {
      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnBootSec = "25m";
        OnUnitActiveSec = "25m";
        Unit = "timew_track.service";
      };
    };

    systemd.services."timew_track" = {
      script = ''
          # DBUS is optimized for dwm-desktop, you need to tune it for your DE
          export DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/$(id -u $USER)/bus
          export DISPLAY=:0
          ${pkgs.timewarrior}/bin/timew|grep Tracking && ${pkgs.libnotify}/bin/notify-send --expire-time=1000 "Timewarrior" "Tracking is active"
      '';
      serviceConfig = {
        Type = "oneshot";
        User = config.user.name;
      };
    };
  };
}