{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;
let
  cfg = config.modules.desktop.dwm;
  configDir = config.dotfiles.configDir;
  wCfg = config.services.xserver.desktopManager.wallpaper;
in
{
  options.modules.desktop.dwm = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    security.polkit.enable = true; # to promt root password in GUI programs
      programs.slock.enable = true; # Use slock to quick lock system, less issues with screen and it's faster

    # Auto-lock on suspend
    programs.xss-lock.enable = true;
    programs.xss-lock.lockerCommand = "/run/wrappers/bin/slock";

    home.dataFile."dwm/autostart.sh" = {
      text = ''
        #!/bin/sh
        # Load theme specific settings
        [[ ! -f $XDG_CONFIG_HOME/xtheme.init ]] || $XDG_CONFIG_HOME/xtheme.init

        # Bind F13 (XF86Tools) to mod3mask key
        xmodmap -e "clear mod3" -e "add mod3 = XF86Tools"

        # Exit if programs  are already running
        pgrep wezterm && exit 1
        pgrep slack && exit 1
        pgrep firefox && exit 1

        if [ -e "$XDG_DATA_HOME/wallpaper" ]; then
         ${pkgs.feh}/bin/feh --bg-${wCfg.mode} \
           ${optionalString wCfg.combineScreens "--no-xinerama"} \
           --no-fehbg \
           $XDG_DATA_HOME/wallpaper
        fi

        # Set cursor shape
        xsetroot -cursor_name left_ptr

        # Load some GUI apps
        notify-send -t 5000 "System" "Поехали!" &
        firefox &
        slack &
        wezterm &
        sleep 2 && wezterm start --class=cmus cmus &
      '';
      executable = true;
    };

    environment.systemPackages = with pkgs; [
      libnotify
      dmenu
      alsa-utils # for dwm-status
      xorg.xmodmap # to set mod3 key
      jumpapp # quick switch between apps
    ];

    # My custom dmenu scripts
    env.PATH = [ "$DOTFILES_BIN/dmenu" ];

    services = {
      picom.enable = true;
      redshift.enable = true;
      xserver = {
        enable = true;

        # Configure keymap in X11
        xkb.layout = "us,ru";
        xkb.variant = "colemak_dh,";
        xkb.options = "grp:menu_toggle,compose:paus";

        displayManager = {
          defaultSession = "none+dwm";
          lightdm.enable = true;
          lightdm.greeters.mini.enable = true;
        };
        windowManager.dwm = {
          enable = true;
          package = pkgs.dwm.overrideAttrs (old: {
            src =
              if builtins.pathExists /home/inom/Computer/software/dwm-flexipatch
              then
                builtins.fetchGit
                  {
                    url = "file:///home/inom/Computer/software/dwm-flexipatch/";
                  }
              else
                pkgs.fetchpath {
                  repo = "dwm-flexipatch";
                  rev = "0db92acb1e38483216845cf6c600c44c8d7c33ac";
                  hash = "sha256-YmmlP6XGKS/i89M5skLBfYpktZ91vnMhdKs9fBAgQnc=";
                };
          });
        };
      };
      dwm-status = {
        enable = true;
        order = [ "time" ];
        extraConfig = ''
          separator = " / "

          [time]
          format = "%A, %d.%m [%B], %H:%M"
          	'';
      };
      gvfs.enable = true;
    };

    # High dpi
    services.xserver.dpi = 180;
    environment.variables = {
      GDK_SCALE = "2";
      GDK_DPI_SCALE = "0.5";
      _JAVA_OPTIONS = "-Dsun.java2d.uiScale=2";
    };

    systemd = {
      user.services.polkit-gnome-authentication-agent-1 = {
        description = "polkit-gnome-authentication-agent-1";
        wantedBy = [ "graphical-session.target" ];
        wants = [ "graphical-session.target" ];
        after = [ "graphical-session.target" ];
        serviceConfig = {
          Type = "simple";
          ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
          Restart = "on-failure";
          RestartSec = 1;
          TimeoutStopSec = 10;
        };
      };
    };

    # link recursively so other modules can link files in their folders
    home.configFile = {
      "sxhkd".source = "${configDir}/sxhkd";
    };
  };
}