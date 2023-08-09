{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.media.useless;
    configDir = config.dotfiles.configDir;
in {
  options.modules.desktop.media.useless = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      cmatrix     # Simulates the falling characters theme from The Matrix movie
      neo-cowsay  # Generates ASCII pictures of a cow with a message
      fortune     # Displays a pseudorandom message from a database of quotations
      lolcat      # Rainbows and unicorns
      figlet      # Program for making large letters out of ordinary text
      boxes       # Command line ASCII boxes unlimited!
      sl          # Steam Locomotive runs across your terminal when you type 'sl'
      doge        # WoW very terminal doge
      linux_logo  # Prints an ASCII logo and some system info
    ];
  };
}
