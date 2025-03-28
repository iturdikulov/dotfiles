# modules/desktop/term/foot.nix
#
# TODO

{ lib, config, options, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.term.foot;
    configDir = config.dotfiles.configDir;
in {
  options.modules.desktop.term.foot = with types; {
    enable = mkBoolOpt false;
    settings = mkOpt (attrsOf attrs) {};
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      foot
      libsixel  # image support in foot
    ];

    modules.shell.tmux.term = mkForce "foot";

    home.configFile = {
      "foot/foot.ini".text = ''
        # config/foot/foot.ini
        # This was automatically generated by NixOS and my dotfiles
        include=${config.user.home}/.config/foot/foot.global.ini
        include=${config.user.home}/.config/foot/foot.local.ini
      '';
      "foot/foot.global.ini".source = "${configDir}/foot/foot.ini";
      "foot/foot.local.ini".text = lib.generators.toINI {} cfg.settings;
    };
  };
}