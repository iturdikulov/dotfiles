# modules/themes/alucard/default.nix --- a regal dracula-inspired theme

{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.theme;
    qtctConf = {
      Appearance = {
        custom_palette = false;
        icon_theme = "Papirus-Dark";
        standard_dialogs = "default";
        style = "breeze";
      };
    };

in {
  config = mkIf (cfg.active == "alucard") (mkMerge [
    # Desktop-agnostic configuration
    {
      modules = {
        theme = {
          wallpaper = mkDefault ./config/wallpaper.png;
          wallpaper_vertical = mkDefault ./config/wallpaper_vertical.png;
          gtk = {
            theme = "Dracula";
            iconTheme = "Papirus-Dark";
            cursorTheme = "Volantes Cursors";
          };
          qt = {
            platformTheme = "qt5ct";
            style = "kvantum";
          };
          fonts = {
            sans.name = "Noto Sans";
            mono.name = "FiraCode Nerd Font Mono";
          };
          colors = {
            black         = "#0E1013"; # 0
            red           = "#E55561"; # 1
            green         = "#8EBD6B"; # 2
            yellow        = "#E2B86B"; # 3
            blue          = "#4FA6ED"; # 4
            magenta       = "#BF68D9"; # 5
            cyan          = "#188C9B"; # 6
            silver        = "#ABB2BF"; # 7
            grey          = "#545862"; # 8
            brightred     = "#E06C75"; # 9
            brightgreen   = "#98C379"; # 10
            brightyellow  = "#E5C07B"; # 11
            brightblue    = "#61AFEF"; # 12
            brightmagenta = "#C678DD"; # 13
            brightcyan    = "#56B6C2"; # 14
            white         = "#C8CCD4"; # 15

            types.bg      = "#0E1415";
            types.fg      = "#CECECE";
          };
        };

        shell.zsh.rcFiles  = [ ./config/zsh/prompt.zsh ];
        shell.tmux.rcFiles = [ ./config/tmux.conf ];
        desktop.browsers = {
          firefox.userChrome = concatMapStringsSep "\n" readFile [
            ./config/firefox/userChrome.css
          ];
          qutebrowser.userStyles = concatMapStringsSep "\n" readFile
            (map toCSSFile [
              ./config/qutebrowser/userstyles/monospace-textareas.scss
              ./config/qutebrowser/userstyles/stackoverflow.scss
              ./config/qutebrowser/userstyles/xkcd.scss
            ]);
        };
      };
    }

    {
      modules.desktop.term.foot.settings = {
        main = {
          font = "${cfg.fonts.mono.name}:size=${toString cfg.fonts.mono.size}";
        };
        colors = mapAttrs (_: v: if isString v then removePrefix "#" v else v) {
          alpha = 0.95;
          background = cfg.colors.types.bg;
          foreground = cfg.colors.types.fg;
        #   selection-foreground = cfg.colors.types.panelfg;
        #   selection-background = cfg.colors.types.panelbg;
        #   urls = cfg.colors.types.highlight;
          regular0 = cfg.colors.black;
          regular1 = cfg.colors.red;
          regular2 = cfg.colors.green;
          regular3 = cfg.colors.yellow;
          regular4 = cfg.colors.blue;
          regular5 = cfg.colors.magenta;
          regular6 = cfg.colors.cyan;
          regular7 = cfg.colors.white;
          bright0 = cfg.colors.grey;
          bright1 = cfg.colors.brightred;
          bright2 = cfg.colors.brightgreen;
          bright3 = cfg.colors.brightyellow;
          bright4 = cfg.colors.brightblue;
          bright5 = cfg.colors.brightmagenta;
          bright6 = cfg.colors.brightcyan;
          bright7 = cfg.colors.silver;
        };
      };

      modules.desktop.sway.mako.settings = {
        background-color = "${cfg.colors.types.bg}f2";
        border-color = "${cfg.colors.red}ee";
        border-radius = 6;
        border-size = 1;
        default-timeout = 10000;
        font = "${cfg.fonts.sans.name} ${toString cfg.fonts.sans.size}";
        height = 300;
        # icon-path =
        #   let iconDir = "/etc/profiles/per-user/${config.user.name}/share/icons";
        #   in concatStringsSep ":" [
        #     "${iconDir}/${cfg.gtk.iconTheme.name}"
        #     "${iconDir}/gnome"
        #   ];
        # layer = "top";
        # max-history = 10;
        # max-visible = 10;
        # padding = 20;
        # progress-color = "${cfg.colors.red}2f";
        # sort = "-time";
        # text-color = cfg.colors.types.fg;
        # width = 420;
        #
        # "urgency=high" = {
        #   background-color = "${cfg.colors.types.border}ee";
        #   # border-color = "${cfg.colors.types.error}66";
        #   default-timeout = 0;
        #   text-color = "#ffffff";
        # };
        # "urgency=low" = {
        #   background-color = "${cfg.colors.types.panelbg}dd";
        #   # border-color = "${cfg.colors.types.border}BB";
        #   # text-color = cfg.colors.types.panelfg;
        #   default-timeout = 6000;
        # };
        #
        # "app-name=Spotify" = {
        #   # background-color = "${cfg.colors.types.border}DD";
        #   group-by = "app-name";
        #   max-icon-size = 150;
        #   padding = "0,0,0,18";
        #   icon-location = "right";
        # };
        #
        # "category=preview" = {
        #   group-by = "app-name";
        #   max-icon-size = 150;
        #   padding = "0,0,0,20";
        #   icon-location = "right";
        # };
        #
        # # For 'hey .osd ...' notifications
        # "app-name=OSD" = {
        #   anchor = "bottom-center";
        #   border-color = "${cfg.colors.types.border}99";
        #   border-radius = 48;
        #   border-size = 1;
        #   default-timeout = 1750;
        #   font = "${cfg.fonts.icons.name} 32";
        #   format = "%b";
        #   group-by = "app-name";
        #   height = 512;
        #   on-button-left = "none";
        #   outer-margin = "0,0,256,0";
        #   padding = "18,0";
        #   progress-color = "${cfg.colors.red}66";
        #   text-alignment = "center";
        #   width = 512;
        # };
        # "app-name=OSD category=mic" = {
        #   progress-color = "${cfg.colors.red}44";
        # };
        # "app-name=OSD category=lcd" = {
        #   progress-color = "${cfg.colors.brightred}99";
        # };
        # "app-name=OSD category=indicator" = {
        #   width = 150;
        #   padding = "32,0";
        #   font = "${cfg.fonts.icons.name} 48";
        # };
      };
    }

    (mkIf (config.modules.desktop.type != null) {
      env.GTK_THEME = config.modules.theme.gtk.theme;

      environment.systemPackages = with pkgs; [
        adwaita-icon-theme
      ];
      user.packages = with pkgs; [
        papirus-icon-theme
        dracula-theme
      ];

      # Other dotfiles
      home.configFile = with config.modules; mkMerge [
        (mkIf desktop.sway.enable {
          "waybar/style.css".source = ./config/waybar/style.css;
        })
        (mkIf (desktop.bspwm.enable || desktop.stumpwm.enable || desktop.dwm.enable || desktop.sway.enable) {
          "polybar" = { source = ./config/polybar; recursive = true; };
          "dunst/dunstrc".text = import ./config/dunstrc cfg;
          "Dracula-purple-solid-kvantum" = {
            recursive = true;
            source = "${pkgs.dracula-theme}/share/Kvantum/Dracula-purple-solid/";
            target = "Kvantum/Dracula-purple-solid";
          };
          "kvantum.kvconfig" = {
            text = ''
            [General]
            theme=Dracula-purple-solid
            '';
            target = "Kvantum/kvantum.kvconfig";
          };
        })
        (mkIf desktop.media.graphics.vector.enable {
          "inkscape/templates/default.svg".source = ./config/inkscape/default-template.svg;
        })
        (mkIf desktop.browsers.qutebrowser.enable {
          "qutebrowser/extra/theme.py".source = ./config/qutebrowser/theme.py;
        })
      ];
    })

    # Desktop (X11) theming
    (mkIf config.services.xserver.enable {
      # Login screen theme
      services.xserver.displayManager.lightdm.greeters.mini.extraConfig = ''
        [greeter]
        show-password-label = false

        [greeter-theme]
        text-color = "${cfg.colors.white}"
        password-background-color = "${cfg.colors.black}"
        window-color = "${cfg.colors.types.border}"
        border-color = "${cfg.colors.types.border}"
        password-border-radius = 0.01em
        font = "${cfg.fonts.sans.name}"
        font-size = 1.4em
      '';

      # Other dotfiles
      home.configFile = with config.modules; mkMerge [
        {
          # Sourced from sessionCommands in modules/themes/default.nix
          "xtheme/90-theme".source = ./config/Xresources;
        }
        (mkIf desktop.bspwm.enable {
          "bspwm/rc.d/00-theme".source = ./config/bspwmrc;
          "bspwm/rc.d/95-polybar".source = ./config/polybar/run.sh;
        })
      ];
    })
  ]);
}