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
    security.polkit.enable = true; # to promt root password in GUI programs
    programs.slock.enable = true; # Use slock to quick lock system, less issues with screen and it's faster

    user.packages = with pkgs; [
        (pkgs.writeScriptBin "chatgpt-cli" ''
        #!/bin/sh
        API_KEY=~/.chatgpt_api_key && test -f $API_KEY && export OPENAI_API_KEY=$(cat $API_KEY) && unset API_KEY
        xst -c chatgpt -e chatgpt
        '')
        (pkgs.writeScriptBin "wiki" ''
        #!/bin/sh
        cd ~/Wiki && xst -c wiki -e nvim Now.md
        '')
        (pkgs.writeScriptBin "trans-ru" ''
        #!/bin/sh
        xst -c trans -e trans -shell ru:en
        '')
        (pkgs.writeScriptBin "newsboat-cli" ''
        #!/bin/sh
        xst -c newsboat -e newsboat
        '')
        (pkgs.writeScriptBin "weechat-cli" ''
        #!/bin/sh
        xst -c weechat -e weechat
        '')
    ];
    home.dataFile."dwm/autostart.sh" = {
        text = ''
#!/bin/sh

# Exit if spotify already running (we already started...)
pgrep spotify && exit 1

# Load theme specific settings
[[ ! -f $XDG_CONFIG_HOME/xtheme.init ]] || $XDG_CONFIG_HOME/xtheme.init

# Bind F13 (XF86Tools) to mod3mask key
xmodmap -e "clear mod3" -e "add mod3 = XF86Tools"

# Set cursor shape
xsetroot -cursor_name left_ptr

# Load some IRL-sensentive apps and bloatware ;-)
thunderbird &
slack &
telegram-desktop &
spotify &
'';
        executable = true;
    };

    environment.systemPackages = with pkgs; [
      dunst
      libnotify
      dmenu
      alsa-utils   # for dwm-status
      xorg.xmodmap # to set mod3 key
      jumpapp      # quick switch between apps
    ];

    # My custom dmenu scripts
    env.PATH = [ "$DOTFILES_BIN/dmenu" ];

    services = {
      picom.enable = true;
      redshift.enable = true;
      xserver = {
        enable = true;

        # Configure keymap in X11
        layout = "us,ru";
        xkbVariant = "colemak_dh,";
        xkbOptions = "grp:menu_toggle,lv5:ralt_switch";

        displayManager = {
          defaultSession = "none+dwm";
          lightdm.enable = true;
          lightdm.greeters.mini.enable = true;
        };
        windowManager.dwm = {
          enable = true;
          package = pkgs.dwm.overrideAttrs (old: {
           src = pkgs.fetchFromGitHub {
             owner = "Inom-Turdikulov";
             repo = "dwm-flexipatch";
             rev = "fb19f1af3955c15c4d4d9f8d14a77f8b975aabcc";
             hash = "sha256-O2h8oCClKXeoz0PMOhm4g0Pi5cgD9JzkNukgjcD0a3Q=";
           };
        });
        };
      };
      dwm-status = {
        enable = true;
        order = ["time"];
	extraConfig = ''
separator = " / "

[time]
format = "%A, %d.%m [%B], %H:%M"
	'';
      };
      # gvfs.enable = true;
    };


    systemd = {
    user.services."dunst" = {
      enable = true;
      description = "";
      wantedBy = [ "default.target" ];
      serviceConfig.Restart = "always";
      serviceConfig.RestartSec = 2;
      serviceConfig.ExecStart = "${pkgs.dunst}/bin/dunst";
    };
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