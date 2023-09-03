{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.shell.files;
in {
  options.modules.shell.files = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      du-dust

      (nnn.override {withNerdIcons = true;})
      xdragon  # mainly for supporting dragdrop nnn plugin

      fd
      fasd
      ripgrep
    ];
  };
}