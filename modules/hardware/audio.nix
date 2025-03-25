{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.hardware.audio;
in {
  options.modules.hardware.audio = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      wireplumber.enable = true;  # for screencasting support
    };

    security.rtkit.enable = true;

    user.packages = with pkgs; [
      pavucontrol
    ];

    user.extraGroups = [ "audio" ];
  };
}