{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop;
in {
  options.modules.desktop = {
    type = with types; mkOpt (nullOr str) null;
  };

  config = mkMerge [
    (mkIf (cfg.type == "x11") {
      user.packages = with pkgs; [
        feh # image viewer
        xclip
        xdotool
        xorg.xwininfo
        xorg.xev
      ];
    })

    (mkIf (cfg.type == "wayland") {
      user.packages = with pkgs.unstable; [
        # Program     Substitutes for
        ripdrag       # xdragon (drag and drop)
        wev           # xev
        wl-clipboard  # xclip
        wtype         # xdotool (sorta)
        swappy        # swappy/Snappy/sharex
        slurp         # slop (screenshot tool)
        swayimg       # feh (as an image previewer)
        imv
      ];

      # Improves latency and reduces stuttering in high load scenarios
      security.pam.loginLimits = [
        { domain = "@users"; item = "rtprio"; type = "-"; value = 1; }
      ];
    })

    (mkIf (cfg.type != null) {
      user.packages = with pkgs; [
        libnotify
      ];

      security.polkit.enable = true; # to promt root password in GUI programs
      systemd.user.services.polkit-gnome-authentication-agent-1 = {
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

      fonts = {
        fontDir.enable = true;
        enableGhostscriptFonts = true;
        packages = with pkgs; [
          ubuntu_font_family
          dejavu_fonts
          symbola

          noto-fonts
          noto-fonts-cjk-serif
          noto-fonts-emoji
          fira-code-nerdfont
          fira-code-symbols
          fira
          open-sans
          jetbrains-mono
          siji
          font-awesome
          paratype-pt-sans
        ];
      };
    })


    (mkIf config.services.xserver.enable {
      assertions = [
        {
          assertion = (countAttrs (n: v: n == "enable" && value) cfg) < 2;
          message = "Can't have more than one desktop environment enabled at a time";
        }
        {
          assertion =
            let srv = config.services;
            in srv.xserver.enable ||
              srv.sway.enable ||
              !(anyAttrs
                (n: v: isAttrs v &&
                  anyAttrs (n: v: isAttrs v && v.enable))
                cfg);
          message = "Can't enable a desktop app without a desktop environment";
        }
      ];

      ## Apps/Services
      services.xserver.displayManager.lightdm.greeters.mini.user = config.user.name;

      # Compositor
      services.picom = {
        fade = false;
        shadow = false;
        backend = "glx";
        vSync = true;
        opacityRules = [
          "100:_NET_WM_STATE@:32a = '_NET_WM_STATE_FULLSCREEN'"
          "0:_NET_WM_STATE@:32a *= '_NET_WM_STATE_HIDDEN'"
          "0:_NET_WM_STATE@[0]:32a *= '_NET_WM_STATE_HIDDEN'"
          "0:_NET_WM_STATE@[1]:32a *= '_NET_WM_STATE_HIDDEN'"
          "0:_NET_WM_STATE@[2]:32a *= '_NET_WM_STATE_HIDDEN'"
          "0:_NET_WM_STATE@[3]:32a *= '_NET_WM_STATE_HIDDEN'"
          "0:_NET_WM_STATE@[4]:32a *= '_NET_WM_STATE_HIDDEN'"
          "99:class_g = 'xst-256color'"
          "90:class_g = 'scratch'"
        ];

        settings = {
          # Unredirect all windows if a full-screen opaque window is detected, to
          # maximize performance for full-screen windows. Known to cause
          # flickering when redirecting/unredirecting windows.
          unredir-if-possible = true;

          # GLX backend: Avoid using stencil buffer, useful if you don't have a
          # stencil buffer. Might cause incorrect opacity when rendering
          # transparent content (but never practically happened) and may not work
          # with blur-background. My tests show a 15% performance boost.
          # Recommended.
          glx-no-stencil = true;

          # Use X Sync fence to sync clients' draw calls, to make sure all draw
          # calls are finished before picom starts drawing. Needed on
          # nvidia-drivers with GLX backend for some users.
          xrender-sync-fence = true;
          # use-damage = true;??
        };
      };

      environment.systemPackages = with pkgs; [
        # SVG-based theme engine plus a config tool and extra theme
        libsForQt5.qtstyleplugin-kvantum
        qt6Packages.qtstyleplugin-kvantum
      ];

      services.xserver.displayManager.sessionCommands = ''
        # GTK2_RC_FILES must be available to the display manager.
        export GTK2_RC_FILES="$XDG_CONFIG_HOME/gtk-2.0/gtkrc"
      '';
    })
  ];
}