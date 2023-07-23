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

    nixpkgs.overlays = [
      (self: super: {
        dwm = super.dwm.overrideAttrs (old: {
           src = pkgs.fetchFromGitHub {
             owner = "Inom-Turdikulov";
             repo = "dwm-flexipatch";
             rev = "364a48aa162c43f4a2094a0cef667af8ed635654";
	     hash = "sha256-qEaVn87xtatbKo8vgkwkRIHycmVsTXIIPxSAkDfDXtc=";
           };
        });
      })
    ];

    environment.systemPackages = with pkgs; [
      lightdm
      dunst
      libnotify
      dmenu
      alsa-utils
    ];

    services = {
      picom.enable = false;
      redshift.enable = true;
      xserver = {
        enable = true;

        # Configure keymap in X11
        layout = "us,ru";
        xkbVariant = "colemak_dh,";
        xkbOptions = "grp:win_space_toggle";
 
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
icons = ["奄", "奔", "墳"]

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
