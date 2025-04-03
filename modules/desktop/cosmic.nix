{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;
let
  cfg = config.modules.desktop.cosmic;
in
{
  options.modules.desktop.cosmic = with types; {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    modules.desktop.type = "wayland";
    user.extraGroups = [ "video" ];

    environment.systemPackages = with pkgs; [
      gromit-mpx     # for drawing on the screen
      copyq           # clipboard manager
    ];

    # # Enable the gnome-keyring secrets vault.
    # # Will be exposed through DBus to programs willing to store secrets.
    # services.gnome.gnome-keyring.enable = true;

    services.gvfs.enable = true;

    services.desktopManager.cosmic.enable = true;
    services.displayManager.cosmic-greeter.enable = true;

    # Promt root password in GUI programs
    security.polkit.enable = true;

    # TODO: is still needed?
    systemd.user.services.polkit-gnome-authentication-agent-1 = {
      description = "polkit-gnome-authentication-agent-1";
      bindsTo = [ "graphical-session.target" ];
      after = [ "graphical-session.target" ];
      wantedBy = [ "graphical-session.target" ];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };
  };
}