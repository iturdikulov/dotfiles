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
      taskwarrior3 # my daily tasks
      timewarrior # time tracking
      taskwarrior-tui
    ];

    home.configFile."task/taskrc".source = "${configDir}/task/taskrc";
    modules.shell.zsh.rcFiles = [ "${configDir}/task/aliases.zsh" ];
  };
}