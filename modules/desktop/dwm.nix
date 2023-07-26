{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.dwm;
    configDir = config.dotfiles.configDir;
in {
  options.modules.desktop.dwm = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    # modules.theme.onReload.bspwm = ''
    #   ${pkgs.bspwm}/bin/bspc wm -r
    #   source $XDG_CONFIG_HOME/bspwm/bspwmrc
    # '';

    home.dataFile."dwm/autostart.sh" = {
        text = ''
#!/bin/sh

# Load theme specific settings
[[ ! -f $XDG_CONFIG_HOME/xtheme.init ]] || $XDG_CONFIG_HOME/xtheme.init'';
        executable = true;
    };

    nixpkgs.overlays = [
      (self: super: {
        dwm = super.dwm.overrideAttrs (old: {
           src = pkgs.fetchFromGitHub {
             owner = "Inom-Turdikulov";
             repo = "dwm-flexipatch";
             rev = "926e24c2dadf8122e0a24acf748bff81b94873de";
             hash = "sha256-SHXUuNBk3pNBts3vDsE1d6vFC6LiGeB8DWH5OjvSo0Q=";
           };
        });
      })
    ];

    environment.systemPackages = with pkgs; [
      lightdm
      dunst
      libnotify
      dmenu
    ];

    services = {
      picom.enable = false;
      redshift.enable = true;
      xserver = {
        enable = true;

        # Configure keymap in X11
        layout = "us,ru";
        xkbVariant = "colemak_dh,";
        xkbOptions = "grp:menu_toggle";

        displayManager = {
          defaultSession = "none+dwm";
          lightdm.enable = true;
          lightdm.greeters.mini.enable = true;
        };
        windowManager.dwm = {
          enable = true;
        };
      };
      dwm-status = {
        enable = true;
        order = ["audio" "time"];
	extraConfig = ''
separator = " / "
[audio]
mute = "🔇"
template = "{ICO} {VOL}%"
icons = ["🔈", "🔉", "🔊"]

[time]
format = "%A, %B %d %H:%M"
	'';
      };
      gvfs.enable = true;
    };

    systemd.user.services."dunst" = {
      enable = true;
      description = "";
      wantedBy = [ "default.target" ];
      serviceConfig.Restart = "always";
      serviceConfig.RestartSec = 2;
      serviceConfig.ExecStart = "${pkgs.dunst}/bin/dunst";
    };

    # link recursively so other modules can link files in their folders
    home.configFile = {
      "sxhkd".source = "${configDir}/sxhkd";
    };
  };
}
