# Theme modules are a special beast. They're the only modules that are deeply
# intertwined with others, and are solely responsible for aesthetics. Disabling
# a theme module should never leave a system non-functional.

{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.theme;
    qtctConf = {
      Appearance = {
        icon_theme = "Papirus-Dark";
        standard_dialogs = "gtk3";
        style = "kvantum-dark";
      };

      Fonts = {
        fixed = "\"Monospace,10,-1,5,50,0,0,0,0,0\"";
        general = "\"Sans Serif,10,-1,5,50,0,0,0,0,0\"";
      };
    };

in {
  options.modules.theme = with types; {
    active = mkOption {
      type = nullOr str;
      default = null;
      apply = v: let theme = builtins.getEnv "THEME"; in
                 if theme != "" then theme else v;
      description = ''
        Name of the theme to enable. Can be overridden by the THEME environment
        variable. Themes can also be hot-swapped with 'hey theme $THEME'.
      '';
    };

    wallpaper = mkOpt (either path null) null;
    wallpaper_vertical = mkOpt (either path null) null;

    loginWallpaper = mkOpt (either path null)
      (if cfg.wallpaper != null
       then toFilteredImage cfg.wallpaper "-gaussian-blur 0x2 -modulate 70 -level 5%"
       else null);

    gtk = {
      theme = mkOpt str "";
      iconTheme = mkOpt str "";
      cursorTheme = mkOpt str "";
    };

    qt = {
      platformTheme = mkOpt str "";
      style= mkOpt str "";
    };

    onReload = mkOpt (attrsOf lines) {};

    fonts = {
      # TODO Use submodules
      mono = {
        name = mkOpt str "Monospace";
        size = mkOpt int 16;
      };
      sans = {
        name = mkOpt str "Sans";
        size = mkOpt int 12;
      };
      serif = {
        name = mkOpt str "Serif";
        size = mkOpt int 12;
      };
      emoji = {
        name = mkOpt str "Noto Color Emoji";
        size = mkOpt int 12;
      };
    };

    colors = {
      black         = mkOpt str "#000000"; # 0
      red           = mkOpt str "#FF0000"; # 1
      green         = mkOpt str "#00FF00"; # 2
      yellow        = mkOpt str "#FFFF00"; # 3
      blue          = mkOpt str "#0000FF"; # 4
      magenta       = mkOpt str "#FF00FF"; # 5
      cyan          = mkOpt str "#00FFFF"; # 6
      silver        = mkOpt str "#BBBBBB"; # 7
      grey          = mkOpt str "#888888"; # 8
      brightred     = mkOpt str "#FF8800"; # 9
      brightgreen   = mkOpt str "#00FF80"; # 10
      brightyellow  = mkOpt str "#FF8800"; # 11
      brightblue    = mkOpt str "#0088FF"; # 12
      brightmagenta = mkOpt str "#FF88FF"; # 13
      brightcyan    = mkOpt str "#88FFFF"; # 14
      white         = mkOpt str "#FFFFFF"; # 15

      # Color classes
      types = {
        bg        = mkOpt str cfg.colors.black;
        fg        = mkOpt str cfg.colors.white;
        panelbg   = mkOpt str cfg.colors.types.bg;
        panelfg   = mkOpt str cfg.colors.types.fg;
        border    = mkOpt str cfg.colors.types.bg;
        error     = mkOpt str cfg.colors.red;
        warning   = mkOpt str cfg.colors.yellow;
        highlight = mkOpt str cfg.colors.white;
      };
    };
  };

  config = mkIf (cfg.active != null) (mkMerge [
    # Read xresources files in ~/.config/xtheme/* to allow modular configuration
    # of Xresources.
    (let xrdb = ''${pkgs.coreutils}/bin/cat "$XDG_CONFIG_HOME"/xtheme/* | ${pkgs.xorg.xrdb}/bin/xrdb -load'';
     in {
       home.configFile."xtheme.init" = {
         text = xrdb;
         executable = true;
       };
       modules.theme.onReload.xtheme = xrdb;
     })

    (mkIf config.modules.desktop.bspwm.enable {
      home.configFile."bspwm/rc.d/05-init" = {
        text = "$XDG_CONFIG_HOME/xtheme.init";
        executable = true;
      };
    })

    {
      # Enable qtct for Qt applications
      qt = {
        enable = true;
        platformTheme = cfg.qt.platformTheme;
        style = cfg.qt.style;
      };

      home.configFile = {
        "xtheme/00-init".text = with cfg.colors; ''
          #define bg   ${types.bg}
          #define fg   ${types.fg}
          #define blk  ${black}
          #define red  ${red}
          #define grn  ${green}
          #define ylw  ${yellow}
          #define blu  ${blue}
          #define mag  ${magenta}
          #define cyn  ${cyan}
          #define wht  ${white}
          #define bblk ${grey}
          #define bred ${brightred}
          #define bgrn ${brightgreen}
          #define bylw ${brightyellow}
          #define bblu ${brightblue}
          #define bmag ${brightmagenta}
          #define bcyn ${brightcyan}
          #define bwht ${silver}
        '';
        "xtheme/05-colors".text = ''
          *.foreground: fg
          *.background: bg
          *.color0:  blk
          *.color1:  red
          *.color2:  grn
          *.color3:  ylw
          *.color4:  blu
          *.color5:  mag
          *.color6:  cyn
          *.color7:  wht
          *.color8:  bblk
          *.color9:  bred
          *.color10: bgrn
          *.color11: bylw
          *.color12: bblu
          *.color13: bmag
          *.color14: bcyn
          *.color15: bwht
        '';
        "xtheme/05-fonts".text = with cfg.fonts.mono; ''
          *.font: xft:${name}:pixelsize=${toString(size)}
          Emacs.font: ${name}:pixelsize=${toString(size)}
        '';
        # GTK
        "gtk-4.0/settings.ini".text = ''
          [Settings]
          ${optionalString (cfg.gtk.theme != "")
            ''gtk-theme-name=${cfg.gtk.theme}''}
          ${optionalString (cfg.gtk.iconTheme != "")
            ''gtk-icon-theme-name=${cfg.gtk.iconTheme}''}
          ${optionalString (cfg.gtk.cursorTheme != "")
            ''gtk-cursor-theme-name=${cfg.gtk.cursorTheme}''}
          gtk-cursor-theme-size=32
          gtk-xft-hinting=1
          gtk-xft-hintstyle=hintfull
          gtk-xft-rgba=none
        '';
        "gtk-3.0/settings.ini".text = ''
          [Settings]
          ${optionalString (cfg.gtk.theme != "")
            ''gtk-theme-name=${cfg.gtk.theme}''}
          ${optionalString (cfg.gtk.iconTheme != "")
            ''gtk-icon-theme-name=${cfg.gtk.iconTheme}''}
          ${optionalString (cfg.gtk.cursorTheme != "")
            ''gtk-cursor-theme-name=${cfg.gtk.cursorTheme}''}
          gtk-cursor-theme-size=32
          gtk-xft-hinting=1
          gtk-xft-hintstyle=hintfull
          gtk-xft-rgba=none
        '';
        # GTK2 global theme (widget and icon theme)
        "gtk-2.0/gtkrc".text = ''
          ${optionalString (cfg.gtk.theme != "")
            ''gtk-theme-name="${cfg.gtk.theme}"''}
          ${optionalString (cfg.gtk.iconTheme != "")
            ''gtk-icon-theme-name="${cfg.gtk.iconTheme}"''}
          gtk-font-name="Sans ${toString(cfg.fonts.sans.size)}"
        '';
        # QT4/5 global theme
        "Trolltech.conf".text = ''
          [Qt]
          ${optionalString (cfg.gtk.theme != "")
            ''style=${cfg.gtk.theme}''}
        '';
      };

      # Fix icon theme in QT applications
      programs.dconf.enable = true;

      # Other config
      home.file.".icons/default".source = "${pkgs.volantes-cursors}/share/icons/volantes_cursors";
      home-manager.users.${config.user.name}.dconf.settings."org/gnome/desktop/interface" = {
          color-scheme = "prefer-dark";
          icon-theme = "${cfg.gtk.iconTheme}";
          cursor-theme = "${cfg.gtk.cursorTheme}";
          cursor-size = 32;
      };
      home.configFile."qt5ct/qt5ct.conf".text = lib.generators.toINI { } qtctConf;
      home.configFile."qt6ct/qt6ct.conf".text = lib.generators.toINI { } qtctConf;

      # Styling
      fonts = {
        fontconfig = {
          # Fixes pixelation
          antialias = true;

          # Fixes antialiasing blur
          hinting = {
            enable = true;
          };

          subpixel = {
            rgba = "rgb";
          };

          # Use embedded bitmaps in fonts like Terminess TTF (avoid blurring).
          useEmbeddedBitmaps = true;
          defaultFonts = {
            sansSerif = [ cfg.fonts.sans.name cfg.fonts.emoji.name ];
            serif = [ cfg.fonts.serif.name cfg.fonts.emoji.name ];
            monospace = [ cfg.fonts.mono.name cfg.fonts.emoji.name ];
          };
        };
      };
    }

    (mkIf (cfg.wallpaper != null) {
      # Set the wallpaper ourselves so we don't need .background-image and/or
      # .fehbg polluting $HOME
      home.dataFile = mkMerge [
        (mkIf (cfg.wallpaper != null) {
          "wallpaper".source = cfg.wallpaper;
        })
        (mkIf (cfg.wallpaper_vertical != null) {
          "wallpaper_vertical".source = cfg.wallpaper_vertical;
        })
      ];
    })

    (mkIf (cfg.loginWallpaper != null) {
      services.xserver.displayManager.lightdm.background = cfg.loginWallpaper;
    })

    (mkIf (cfg.onReload != {})
      (let reloadTheme =
             with pkgs; (writeScriptBin "reloadTheme" ''
               #!${stdenv.shell}
               echo "Reloading current theme: ${cfg.active}"
               ${concatStringsSep "\n"
                 (mapAttrsToList (name: script: ''
                   echo "[${name}]"
                   ${script}
                 '') cfg.onReload)}
             '');
       in {
         user.packages = [ reloadTheme ];
       }))
  ]);
}