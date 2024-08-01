{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.hardware.qmk;
in {
  options.modules.hardware.qmk = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      qmk
      hidapi  # To interact with the keyboard
    ];

    hardware.keyboard.qmk.enable = true;

    user.extraGroups = [ "plugdev" ];

    home.configFile."qmk/qmk.ini" = {
      text = ''
        [user]
        keyboard = kbdfans/kbd75/rev2
        keymap = inomoz
      '';
    };
  };
}