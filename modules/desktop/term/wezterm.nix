# modules/desktop/term/wezterm.nix
#

{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.term.wezterm;
in {
  options.modules.desktop.term.wezterm = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      unstable.wezterm
    ];
  };
}