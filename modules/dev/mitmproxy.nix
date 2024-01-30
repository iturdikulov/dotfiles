{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let configDir = config.dotfiles.configDir;
in {
  options.modules.dev.mitmproxy = {
    enable = mkBoolOpt false;
  };

  config = {
   user.packages = with pkgs; [
    mitmproxy
   ];
  };
}