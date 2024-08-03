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
            theme = "Breeze-Dark";
            iconTheme = "Papirus-Dark";
            cursorTheme = "Volantes Cursors";
          };
          qt = {
            platformTheme = "gnome";
            style = "breeze";
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

    # Desktop (X11) theming
    (mkIf config.services.xserver.enable {
      environment.systemPackages = with pkgs; [
        adwaita-icon-theme
      ];
      user.packages = with pkgs; [
        papirus-icon-theme
        unstable.dracula-theme
        breeze-gtk
      ];
      fonts = {
        packages = with pkgs; [
          noto-fonts
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

      # Login screen theme
      services.xserver.displayManager.lightdm.greeters.mini.extraConfig = ''
        text-color = "${cfg.colors.white}"
        password-background-color = "${cfg.colors.black}"
        window-color = "${cfg.colors.types.border}"
        border-color = "${cfg.colors.types.border}"
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
        (mkIf desktop.apps.rofi.enable {
          "rofi/theme" = { source = ./config/rofi; recursive = true; };
          "rofi/config.rasi".source = ./config/rofi_config.rasi;
        })
        (mkIf (desktop.bspwm.enable || desktop.stumpwm.enable || desktop.dwm.enable) {
          "polybar" = { source = ./config/polybar; recursive = true; };
          "dunst/dunstrc".text = import ./config/dunstrc cfg;
          "Dracula-purple-solid-kvantum" = {
            recursive = true;
            source = "${pkgs.unstable.dracula-theme}/share/Kvantum/Dracula-purple-solid/";
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
  ]);
}