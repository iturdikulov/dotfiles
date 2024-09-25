{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;
let
  cfg = config.modules.desktop.dwm;
  configDir = config.dotfiles.configDir;
  wCfg = config.services.xserver.desktopManager.wallpaper;
  localDWMSrc = "${config.user.home}/Computer/software/dwm-flexipatch/";
in
{
  options.modules.desktop.dwm = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    security.polkit.enable = true; # to promt root password in GUI programs

    # Auto-lock on suspend
    programs.xss-lock.enable = true;
    # NEXT: maybe we can better resolve this path
    programs.xss-lock.lockerCommand = "/etc/profiles/per-user/${config.user.name}/bin/i3lock-custom";

    user.packages = with pkgs; [
      (writeScriptBin "i3lock-custom" ''
        #!${stdenv.shell}
        exec ${pkgs.xorg.setxkbmap}/bin/setxkbmap -layout "us(colemak_dh)" || true &
        exec ${pkgs.playerctl}/bin/playerctl --all-players pause || true &
        exec ${pkgs.i3lock-fancy-rapid}/bin/i3lock-fancy-rapid 3 3
      '')
    ];

    home.file.".icons/default".source = "${pkgs.volantes-cursors}/share/icons/volantes_cursors";

    home.dataFile."dwm/autostart.sh" = {
      text = ''
        #!/bin/sh
        # Cursor theme
        ${pkgs.xorg.xsetroot}/bin/xsetroot -xcf ${pkgs.volantes-cursors}/share/icons/volantes_cursors/cursors/left_ptr 48 &

        # Load theme specific settings
        [[ ! -f $XDG_CONFIG_HOME/xtheme.init ]] || $XDG_CONFIG_HOME/xtheme.init

        # Bind F13 (XF86Tools) to mod3mask key
        xmodmap -e "clear mod3" -e "add mod3 = XF86Tools"

        # Exit if programs  are already running
        pgrep $TERMINAL && exit 1
        pgrep slack && exit 1

        if [ -e "$XDG_DATA_HOME/wallpaper" ]; then
         ${pkgs.feh}/bin/feh --bg-${wCfg.mode} \
           ${optionalString wCfg.combineScreens "--no-xinerama"} \
           --no-fehbg \
           $XDG_DATA_HOME/wallpaper \
           $XDG_DATA_HOME/wallpaper_vertical
        fi

        # Load some GUI apps
        notify-send -t 5000 "System" "Поехали!" &
        $TERMINAL &
        $BROWSER &
        thunderbird &
        telegram-desktop &
        sleep 2 && cmus-wr &

        slack &
        crow &
        obsidian &
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
      displayManager = {
        defaultSession = "none+dwm";
      };
      xserver = {
        enable = true;

        displayManager = {
          lightdm.enable = true;
          lightdm.greeters.mini.enable = true;
        };

        # Configure keymap in X11
        xkb.layout = "us,ru";
        xkb.variant = "colemak_dh,";
        xkb.options = "grp:menu_toggle,compose:paus";

        windowManager.dwm = {
          enable = true;
          package = pkgs.dwm.overrideAttrs (old: {
            src =
              if builtins.pathExists localDWMSrc
              then builtins.fetchGit
                  {
                    url = "file://${localDWMSrc}";
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
        order = [ "cpu_load" "time" ];
        extraConfig = ''
          separator = " / "

          [cpu_load]
          template = "{CL1} {CL5} {CL15}"
          update_interval = 30

          [time]
          format = "%A, %d.%m [%B], %H:%M"
        '';
      };
      gvfs.enable = true;
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